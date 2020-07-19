//import RxSwift
//
//extension ObservableType where E == Optional<Any> {
//  public func ignoringNil<SomeResult>() -> ObservableType {
//    return self.flatMap { value in
//      guard let value = value else { return Observable<SomeResult>.empty() }
//    }
//  }
//}
