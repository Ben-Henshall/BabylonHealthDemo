extension Bool {
  /// Negates the boolean - syntactic sugar + gives us a way to not open a closure (e.g. `Observable<Bool>.map(\.isFalse)`, rather than opening a closure
  public var isFalse: Bool { !self }
}
