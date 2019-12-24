import Quick
import Nimble

@testable import BBFication

//MARK: - Custom Matchers for associated values in Mapped<A> object
/// The generic test functions allow us to actually pass the Mapped<Types>
/// into the Nimble matching library.
//private func beItem<A>(test: @escaping (A) -> Void = { _ in }) -> Predicate<Mapped<A>> {
//    return Predicate.define("be item") { expression, message in
//        if let actual = try expression.evaluate(),
//            case let .Value(A) = actual {
//            test(A)
//            return PredicateResult(status: .matches, message: message)
//        }
//        return PredicateResult(status: .fail, message: message)
//    }
//}
//
//private func beDecodingError<A>(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[A]>> {
//    return Predicate.define("be decoding error") { expression, message in
//        if let actual = try expression.evaluate(),
//            case let .MappingError(Error) = actual {
//            test(Error)
//            return PredicateResult(status: .matches, message: message)
//        }
//        return PredicateResult(status: .fail, message: message)
//    }
//}

class CharacterTests: QuickSpec {
    
    typealias H = Helpers
    
    override func spec() {
        var rawData: Data?
        var sut: CharacterMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?

        beforeEach {
            rawData = TestSuiteHelpers.readLocalData(testCase: .characters)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = MockPersistenceManager(managedContext: persistentContainer!)
                sut = CharacterMapper(storeManager: manager!)
            })
        }

        afterSuite {
            rawData = nil
        }
        
        context("GIVEN valid character JSON") {
            describe("WHEN we parse the feed of 63 character items") {
                it("THEN it creates a collection of Characters") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = CharacterMapper(storeManager: manager!)
                            sut?.parse(rawValue: rawData!)
                            expect(sut?.mappedValue).to(H.beItem { characters in
                                expect(characters).to(beAKindOf(Array<CharacterRaw>.self))
                            })
                            done()
                        })
                    }
                }
                it("AND the collection contains 63 items") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = CharacterMapper(storeManager: manager!)
                            sut?.parse(rawValue: rawData!)
                            expect(sut?.mappedValue).to(H.beItem { characters in
                                expect(characters.count).to(equal(63))
                            })
                            done()
                        })
                    }
                }
                it("AND the first character has the correct attributes") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = CharacterMapper(storeManager: manager!)
                            sut?.parse(rawValue: rawData!)
                            expect(sut?.mappedValue).to(H.beItem { characters in
                                let actual = characters.first!
                                expect(actual.id).to(equal(1))
                                expect(actual.actor).to(equal("Bryan Cranston"))
                                expect(actual.name).to(equal("Walter White"))
                                expect(actual.occupations.count).to(equal(2))
                                expect(actual.occupations.last!).to(equal("Meth King Pin"))
                                //rest of attributes elided...
                            })
                            done()
                        })
                    }
                }
            }
        }
    }
}
