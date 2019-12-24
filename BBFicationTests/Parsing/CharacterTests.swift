import Quick
import Nimble

@testable import BBFication


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
        context("GIVEN a malformed JSON payload") {
            
            beforeEach {
                rawData = TestSuiteHelpers.readLocalData(testCase: .badCharacter)
                TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                    persistentContainer = container
                    manager = MockPersistenceManager(managedContext: persistentContainer!)
                    sut = CharacterMapper(storeManager: manager!)
                })
            }
            
            afterSuite {
                rawData = nil
            }
            describe("WHEN we parse a feed") {
                it("throws an error") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            sut?.parse(rawValue: rawData!)
                            expect(sut?.mappedValue).to(H.beDecodingError())
                            done()
                        })
                    }
                }
            }
        }
    }
}
