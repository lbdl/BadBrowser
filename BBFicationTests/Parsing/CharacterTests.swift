import Quick
import Nimble

@testable import BBFication

//MARK: - Custom Matchers for associated values in Mapped<A> objects
private func beItem<A>(test: @escaping (A) -> Void = { _ in }) -> Predicate<Mapped<A>> {
    return Predicate.define("be item") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(A) = actual {
            test(A)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

private func beDecodingError<A>(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[A]>> {
    return Predicate.define("be decoding error") { expression, message in
        if let actual = try expression.evaluate(),
            case let .MappingError(Error) = actual {
            test(Error)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

class CharacterTests: QuickSpec {
    override func spec() {
        var rawData: Data?
        var sut: CharacterMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?

        beforeEach {
            rawData = TestSuiteHelpers.readLocalData(testCase: .localle)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = MockPersistenceManager(managedContext: persistentContainer!)
                sut = LocalleMapper(storeManager: manager!)
            })
        }

        afterSuite {
            rawData = nil
        }
    }
}
