import 'dart:io';
import 'dart:convert'; // For jsonDecode
import 'dart:ui';
import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/features/home/domain/expense_entity.dart';
import 'package:TrackIt/features/home/presentation/providers/Home_provider.dart';
import 'package:TrackIt/global_widgets/appbar.ui.dart';
import 'package:TrackIt/global_widgets/button.ui.dart';
import 'package:TrackIt/global_widgets/notification_snackbar.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiAssistanScreen extends StatefulWidget {
  const AiAssistanScreen({super.key});

  @override
  State<AiAssistanScreen> createState() => _AiAssistanScreenState();
}

class _AiAssistanScreenState extends State<AiAssistanScreen> {
  XFile? _imageFile;
  String _geminiResponse = '';
  List<Map<String, dynamic>> _extractedItems = [];
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    setState(() {
      _imageFile = image;
      _geminiResponse = ''; // Clear previous response
      _extractedItems = []; // Clear previous items
    });
  }

  Future<void> _scanReceiptWithGemini() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating, // MODIFIED
          content: Text('Please select an image first.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _geminiResponse = 'Scanning receipt...'; // Initial user feedback
      _extractedItems = []; // Clear previous items when starting a new scan
    });

    try {
      final imageBytes = await _imageFile!.readAsBytes();
      final gemini = Gemini.instance;

      final prompt =
          "Analyze this receipt image and extract the following information in strict JSON format. "
          "The output should *only* be the JSON object, with no surrounding text, comments, or markdown fences (like ```json). "
          "The JSON should contain: "
          "a list of items, each with 'name' (string), 'quantity' (number, default to 1 if not explicit), and 'price' (number). "
          "Also, extract the 'total_amount' (number). "
          "If an item price is not explicitly stated but a total price for multiple quantities is, "
          "calculate the individual item price if possible. "
          "If the image is not a receipt or contains no discernible receipt information, respond with a plain text message *only* indicating that it's not a receipt and cannot be processed, without any JSON structure. "
          "For example JSON: {\"items\": [{\"name\": \"Milk\", \"quantity\": 1, \"price\": 5.99}, {\"name\": \"Bread\", \"quantity\": 2, \"price\": 3.50}], \"total_amount\": 12.99}";

      final response = await gemini.prompt(
        parts: [
          Part.text(prompt),
          Part.bytes(imageBytes),
        ],
      );

      if (response != null &&
          response.content != null &&
          response.content!.parts != null &&
          response.content!.parts!.isNotEmpty) {
        String? rawExtractedText;
        final lastPart = response.content!.parts!.last;

        if (lastPart is TextPart) {
          rawExtractedText = lastPart.text;
        } else {
          setState(() {
            _geminiResponse =
                'Gemini returned an unexpected content type (not text).';
            _isLoading = false;
          });
          return;
        }

        if (rawExtractedText != null) {
          // Keep raw text for internal debugging but don't show to user yet
          print('--- Raw extractedText for JSON parsing ---');
          print(rawExtractedText);
          print('--- End of raw extractedText ---');

          // --- START JSON CLEANING ---
          String cleanJsonText = rawExtractedText.trim();

          // Attempt to remove markdown code block fences
          if (cleanJsonText.startsWith('```json')) {
            cleanJsonText = cleanJsonText.substring('```json'.length);
          } else if (cleanJsonText.startsWith('```')) {
            cleanJsonText = cleanJsonText.substring('```'.length);
          }
          if (cleanJsonText.endsWith('```')) {
            cleanJsonText =
                cleanJsonText.substring(0, cleanJsonText.length - '```'.length);
          }
          cleanJsonText = cleanJsonText.trim();

          // Further refine by finding the actual JSON object block
          final startIndex = cleanJsonText.indexOf('{');
          final endIndex = cleanJsonText.lastIndexOf('}');

          if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            cleanJsonText = cleanJsonText.substring(startIndex, endIndex + 1);
          } else {
            // If after all cleaning, we still can't find a JSON block, it's likely not JSON
            setState(() {
              _geminiResponse =
                  'Could not find a valid JSON response from Gemini.';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating, // MODIFIED
                content:
                    Text('Could not find a valid JSON response from Gemini.'),
              ),
            );
            return;
          }
          // --- END JSON CLEANING ---

          // Re-check for non-receipt messages AFTER cleaning
          if (cleanJsonText.toLowerCase().contains('not a receipt') ||
              cleanJsonText.toLowerCase().contains('cannot be completed') ||
              cleanJsonText.toLowerCase().contains('no receipt information') ||
              cleanJsonText.length < 10) {
            // Add a length check for very short non-JSON responses
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating, // MODIFIED
                content:
                    Text('The image is not a receipt or cannot be processed.'),
              ),
            );
            setState(() {
              _geminiResponse =
                  'The provided image is not a receipt or contains no extractable information.';
            });
            return;
          }

          // Now, attempt to parse the cleaned JSON text
          try {
            final Map<String, dynamic> parsedJson = jsonDecode(cleanJsonText);
            if (parsedJson.containsKey('items') &&
                parsedJson['items'] is List) {
              setState(() {
                _extractedItems =
                    List<Map<String, dynamic>>.from(parsedJson['items']);
                // SUCCESS: Set user-friendly message
                _geminiResponse =
                    'Receipt scanned successfully! Found ${_extractedItems.length} items.';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating, // MODIFIED
                  content: Text('Receipt scanned successfully!'),
                ),
              );
            } else {
              setState(() {
                _geminiResponse =
                    'Gemini responded, but "items" list not found or invalid in JSON.';
              });
            }
          } catch (e) {
            setState(() {
              _geminiResponse = 'Failed to parse receipt data. Error: $e';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating, // MODIFIED
                content: Text(
                    'Failed to parse receipt data. Please try again with a clear receipt.'),
              ),
            );
            print('JSON Decode Error on cleaned text: $e');
            print('Cleaned JSON that failed: $cleanJsonText');
          }
        } else {
          setState(() {
            _geminiResponse = 'Gemini did not return any text content.';
          });
        }
      } else {
        setState(() {
          _geminiResponse =
              'No response, invalid response structure, or empty content from Gemini.';
        });
      }
    } catch (e) {
      String errorMessage;
      if (e is GeminiException) {
        if (e.statusCode == 503) {
          errorMessage =
              'Server is temporarily unavailable. Please try again in a moment.';
        } else if (e.statusCode == 400) {
          errorMessage = 'Bad request: Please ensure your input is valid.';
        } else {
          errorMessage =
              'Gemini API Error: ${e.message} (Status Code: ${e.statusCode})';
        }
        print('Gemini API Error: ${e.message}, Status: ${e.statusCode}');
      } else {
        errorMessage = 'An unexpected error occurred: ${e.toString()}';
        print('General error scanning receipt: $e');
      }

      setState(() {
        _geminiResponse = 'Error: $errorMessage';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating, // Already floating, no change needed
          content: Text(errorMessage),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // MODIFIED _addAsBudget FUNCTION
  Future<void> _addAsBudget(
      HomeProvider homeProvider, String _currentUserId) async {
    if (_extractedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content:
              Text('No items extracted from the receipt to add to budget.'),
        ),
      );
      return;
    }

    // Get the HomeProvider instance
    // Make sure HomeProvider is provided higher up in your widget tree (e.g., in main.dart)

    setState(() {
      _isLoading = true; // Show loading indicator while saving
      _geminiResponse = 'Adding items to budget...';
    });

    List<Expense> expensesToSave = [];

    // Loop through extracted items and convert them to Expense objects
    for (var itemMap in _extractedItems) {
      // Safely extract data, providing default values if null or wrong type
      final String name = itemMap['name']?.toString() ?? 'Unknown Item';
      final num quantityNum = itemMap['quantity'] as num? ?? 1;
      final num priceNum = itemMap['price'] as num? ?? 0.0;

      final double quantity = quantityNum.toDouble();
      final double price = priceNum.toDouble();

      final double totalAmountForItem = quantity * price;

      // Create an Expense object for each item
      final Expense newExpense = Expense(
        id: '', // Assuming your database generates this ID
        title: name,
        amount: totalAmountForItem,
        description:
            'From receipt: ${quantity}  x  \$${price.toStringAsFixed(2)}', // Default description
        createdAt: DateTime.now().toString(),
        userId: _currentUserId, // Use your actual user ID here
        category: 'Other', // Default category, user can re-categorize later
      );
      expensesToSave.add(newExpense);
    }

    try {
      // Pass the list of expenses to the HomeProvider
      bool success =
          await homeProvider.saveExpense(expensesToSave).catchError((e) {
        print('Error saving batch of expenses: $e');
        ShowNotificationSnack.showError(
            context, 'Error', e); // Assuming ShowNotificationSnack is defined
        return false; // Indicate failure for the batch
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
                'Successfully added ${expensesToSave.length} items to budget!'),
          ),
        );
        // Optionally clear extracted items and response after successful save
        setState(() {
          _extractedItems = [];
          _geminiResponse = ''; // Clear the Gemini response text
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
                'Failed to add items to budget. Check console for details.'),
          ),
        );
        setState(() {
          _geminiResponse = 'Failed to add items to budget.';
        });
      }
    } catch (e) {
      print('Unexpected error in _addAsBudget during batch save: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('An unexpected error occurred: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    print(
        'Batch adding to budget complete. Final extracted items state: $_extractedItems');
  }

  void _publishToRepository() {
    // TODO: Implement logic to publish _extractedItems to online repository
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating, // MODIFIED
        content: Text('Items published to repository (dummy action).'),
      ),
    );
    print('Publishing to repository: $_extractedItems');
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final _currentUserId = Supabase.instance.client.auth.currentUser!.id;
    final isLoading = context.watch<HomeProvider>().isLoading;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MainAppbarUi(
        titleColor: colorScheme.inverseSurface,
        title: 'Ai Assistant',
        showBackButton: false,
      ),
      body: Container(
        clipBehavior: Clip.hardEdge,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: _imageFile == null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/png/backgroundImg.png"))
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(_imageFile!.path),
                    ))),
        child: ClipRRect(
          // Clip the blur effect to match border radius
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 3, sigmaY: 3), // Increase blur for more glass effect
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              decoration: BoxDecoration(
                color: colorScheme.onSecondaryContainer
                    .withOpacity(0.2), // Slight white overlay
                borderRadius: BorderRadius.circular(20),
              ),

              width: double.infinity,
              // height: 200,
              // margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              // padding: EdgeInsets.all(12),

              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _imageFile == null
                        ? TextUi.bodyMedBold(
                            color: colorScheme.onSurfaceVariant,
                            'No image selected.',
                          )
                        : Container(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Pick from Gallery'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_imageFile != null)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _scanReceiptWithGemini,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Scan with Gemini'),
                      ),
                    const SizedBox(height: 20),
                    if (_geminiResponse.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gemini Response:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            20.verticalSpace,
                            TextUi.bodySmall(_geminiResponse),
                            if (_extractedItems.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Extracted Items:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ..._extractedItems.map((item) => Text(
                                      '- ${item['name']} x${item['quantity']}  -  ${formatCurrency(double.parse(item['price'].toString()))}')),
                                  const SizedBox(height: 20),
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: PrimaryButtonUi(
                                          loading: isLoading,
                                          backgroundColor: colorScheme.primary,
                                          textStyle: bodySmall,
                                          text: 'Add to Budget',
                                          onPressed: () {
                                            _addAsBudget(
                                                homeProvider, _currentUserId);
                                          },
                                          // icon: const Icon(Icons.wallet),
                                          // label: const Text(),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: PrimaryButtonUi(
                                          backgroundColor: colorScheme.primary,
                                          textStyle: bodySmall,
                                          text: 'Publish',
                                          onPressed: _publishToRepository,
                                          // icon: const Icon(Icons.cloud_upload),
                                          // label:
                                          //     const Text(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    100.verticalSpace
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
