enum ViewState { busy, idle }

extension ViewStateX on ViewState {
  bool get isBusy => this == ViewState.busy;
  bool get isIdle => this == ViewState.idle;
}
