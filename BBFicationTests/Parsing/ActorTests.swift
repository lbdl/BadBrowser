import Quick
import Nimble

@testable import BBFication

//MARK: - Custom Matchers for associated values in Mapped<A> objects
private func beItem(test: @escaping (A) -> Void = { _ in }) -> Predicate<Mapped<A>> {
    return Predicate.define("be item") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(A) = actual {
            test(A)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

private func beDecodingError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[A]>> {
    return Predicate.define("be decoding error") { expression, message in
        if let actual = try expression.evaluate(),
            case let .MappingError(Error) = actual {
            test(Error)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

class ActorTests: QuickSpec {
    override func spec() {

    }
}
