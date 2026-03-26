// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:TrackIt/src/Resources/colors.res.dart';

// import 'package:TrackIt/src/global_widgets/text.ui.dart';


// class DashboardPrograms extends StatefulWidget {
//   const DashboardPrograms({
//     // required this.controller,
//     super.key,
//   });

//   @override
//   State<DashboardPrograms> createState() => _DashboardProgramsState();
// }

// class _DashboardProgramsState extends State<DashboardPrograms>
//     with SingleTickerProviderStateMixin {
//   // void _onRiveInit(Artboard artboard) {
//   //   final controller = StateMachineController.fromArtboard(
//   //     artboard,
//   //     'bodyPart',
//   //     // onStateChange: _onStateChange,
//   //   );

//   //   artboard.addController(controller!);

//   //   // _skin = controller.getTriggerInput('Skin');
//   // }

//   late AnimationController controller;

//   @override
//   void initState() {
//     controller = AnimationController(
//       /// [AnimationController]s can be created with `vsync: this` because of
//       /// [TickerProviderStateMixin].
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..addListener(() {
//         setState(() {});
//       });
//     controller.repeat(reverse: false);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 400,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         // color: Colors.grey[700]!.withOpacity(0.5)
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             DashProgramItems(
//               ontap: () {
//                 Navigator.push(context, CupertinoPageRoute(builder: (context) {
//                   return const ExerciseDetails();
//                 }));
//               },
//               controller: controller,
//               assetPath: 'assets/png/TrainerPfp.png',
//               animations: ["arms"],
//               routineTime: "Afternoon routine",
//               workoutName: "Arms",
//               // onRiveInit: _onRiveInit,
//             ),
//             DashProgramItems(
//               ontap: () {
//                 Navigator.push(context, CupertinoPageRoute(builder: (context) {
//                   return const ExerciseDetails();
//                 }));
//               },
//               controller: controller,
//               assetPath: 'assets/png/TrainerPfp.png',
//               animations: ["chest"],
//               routineTime: "Morning routine",
//               workoutName: "Chest",
//               // onRiveInit: _onRiveInit,
//             ),
//             DashProgramItems(
//               ontap: () {
//                 Navigator.push(context, CupertinoPageRoute(builder: (context) {
//                   return const ExerciseDetails();
//                 }));
//               },
//               controller: controller,
//               assetPath: 'assets/png/TrainerPfp.png',
//               animations: ["legs"],
//               routineTime: "Evening routine",
//               workoutName: "Legs",
//               // onRiveInit: _onRiveInit,
//             ),
//             DashProgramItems(
//               ontap: () {
//                 Navigator.push(context, CupertinoPageRoute(builder: (context) {
//                   return const ExerciseDetails();
//                 }));
//               },
//               controller: controller,
//               assetPath: 'assets/png/TrainerPfp.png',
//               animations: ["shoulder"],
//               routineTime: "Morning routine",
//               workoutName: "Shoulders",
//               // onRiveInit: _onRiveInit,
//             ),
//             DashProgramItems(
//               ontap: () {
//                 Navigator.push(context, CupertinoPageRoute(builder: (context) {
//                   return const ExerciseDetails();
//                 }));
//               },
//               controller: controller,
//               assetPath: 'assets/png/TrainerPfp.png',
//               animations: ["abs"],
//               routineTime: "Evening routine",
//               workoutName: "Abs",
//               // onRiveInit: _onRiveInit,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DashProgramItems extends StatefulWidget {
//   const DashProgramItems({
//     // required this.onRiveInit,
//     this.animations,
//     this.assetPath,
//     this.routineTime,
//     this.workoutName,
//     required this.controller,
//     this.ontap,
//     super.key,
//   });
//   // final OnInitCallback onRiveInit;
//   final String? assetPath;
//   final List<String>? animations;
//   final String? routineTime;
//   final String? workoutName;
//   final AnimationController controller;
//   final VoidCallback? ontap;
//   @override
//   State<DashProgramItems> createState() => _DashProgramItemsState();
// }

// class _DashProgramItemsState extends State<DashProgramItems> {
//   double _progress = 0.10;

//   void incrementProgress() {
//     setState(() {
//       _progress = (_progress + 0.01).clamp(0.0, 1.0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: GestureDetector(
//         onTap: widget.ontap,
//         child: Container(
//           width: double.infinity,
//           height: 85,
//           decoration: BoxDecoration(
//               color: Colors.black, borderRadius: BorderRadius.circular(10)),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                         height: 70,
//                         width: 70,
//                         clipBehavior: Clip.hardEdge,
//                         decoration: BoxDecoration(
//                             color: primary.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Image.asset(widget.assetPath.toString())),
//                     10.horizontalSpace,
//                     // Container(
//                     //     height: double.infinity,
//                     //     width: 5,
//                     //     decoration: BoxDecoration(
//                     //         color: blueColo,
//                     //         borderRadius: BorderRadius.circular(10))),
//                     10.horizontalSpace,
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         TextUi.bodyNormBold(
//                             widget.routineTime ?? "Morning routine",
//                             color: white),
//                         TextUi.bodySmall(
//                           widget.workoutName ?? "Arms",
//                           color: white,
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                     onPressed: () {},
//                     iconSize: 20,
//                     icon: Icon(
//                       Icons.arrow_forward,
//                       color: white,
//                     )
//                     //  CircularProgressIndicator(
//                     //   value: _progress,

//                     //   strokeWidth: 7,
//                     //   color: primary,
//                     //   // backgroundColor: primary.withOpacity(0.5),
//                     //   // valueColor: AlwaysStoppedAnimation(primary),
//                     // )
//                     ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
