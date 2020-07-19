/// Converts a mapping of `A` -> `B` into a function applicable to an array of `A`s
/// An alternative would be making this available through an extension, something like `MapInner`
public func map<A, B>(_ transform: @escaping (A) -> B) -> ([A]) -> [B] {
  return { values in
    values.map(transform)
  }
}

/// Identity function - often used as a way to return self (e.g. Observable<Bool>.map(identity) removes the need for opening a closure)
public func identity<T>(_ value: T) -> T {
    return value
}
