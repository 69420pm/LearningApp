class StateCompare<T> {
  T getNewestState(
    T stateA,
    T stateB,
    DateTime? aChange,
    DateTime? bChange,
    T fallback,
  ) {
    aChange = aChange ?? DateTime.now();
    bChange = bChange ?? DateTime.now();
    if (stateA == null && stateB == null) return fallback;
    if (stateA == null) return stateB;
    if (stateB == null) return stateA;

    if (aChange.isAfter(bChange)) return stateA;
    if (bChange.isAfter(aChange)) return stateB;

    if (aChange.isAtSameMomentAs(bChange) && stateA == stateB) {
      return stateA;
    }

    throw (Exception("States have same changeDate but different Content"),);
  }
}
