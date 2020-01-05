import Quick
import Nimble
import CoreData

@testable import BBFication

class CharacterViewModelTests: QuickSpec {
    typealias H = Helpers
    typealias T = TestSuiteHelpers
    override func spec() {

        var rawData: Data?
        var mapper: CharacterMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?
        var sut: CharacterViewModel?

        func flush() {

            let charReq = NSFetchRequest<Character>(entityName: Character.entityName)
            let epReq = NSFetchRequest<Episode>(entityName: Episode.entityName)
            let actReq = NSFetchRequest<Actor>(entityName: Actor.entityName)
            let showReq = NSFetchRequest<Show>(entityName: Show.entityName)
            let seasonReq = NSFetchRequest<Season>(entityName: Season.entityName)
            let apperanceReq = NSFetchRequest<Appearance>(entityName: Appearance.entityName)

            let chars = try! persistentContainer!.fetch(charReq)
            for case let char as NSManagedObject in chars {
                persistentContainer!.delete(char)
                try! persistentContainer!.save()
            }
            let eps = try! persistentContainer!.fetch(epReq)
            for case let ep as NSManagedObject in eps {
                persistentContainer!.delete(ep)
                try! persistentContainer!.save()
            }
            let actors = try! persistentContainer!.fetch(actReq)
            for case let actor as NSManagedObject in actors {
                persistentContainer!.delete(actor)
                try! persistentContainer!.save()
            }
            let shows = try! persistentContainer!.fetch(showReq)
            for case let show as NSManagedObject in shows {
                persistentContainer!.delete(show)
                try! persistentContainer!.save()
            }
            let seasons = try! persistentContainer!.fetch(seasonReq)
            for case let season as NSManagedObject in seasons {
                persistentContainer!.delete(season)
                try! persistentContainer!.save()
            }
            let appearances = try! persistentContainer!.fetch(apperanceReq)
            for case let appearance as NSManagedObject in appearances {
                persistentContainer!.delete(appearance)
                try! persistentContainer!.save()
            }
        }

        beforeSuite {
            rawData = T.readLocalData(testCase: .characters)
            T.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                mapper = CharacterMapper(storeManager: manager!)
                mapper?.parse(rawValue: rawData!)
                mapper?.persist(rawJson: (mapper?.mappedValue)!)
            })
        }

        beforeEach {
            mapper?.parse(rawValue: rawData!)
            mapper?.persist(rawJson: (mapper?.mappedValue)!)
        }

        afterSuite {
            flush()
        }

        describe("GIVEN valid JSON that has been persisted") {
            context("WHEN we apply a series filter to the model") {
                it("the character count for S01 is 26 and the unfiltered count is 63") {
                    waitUntil { done in
                        sut = CharacterViewModel(persistentContainer!)
                        let seasons = sut?.filterBySeason(filter: 0)
                        expect(seasons?.count).to(equal(63))
                        let season1 = sut?.filterBySeason(filter: 1)
                        expect(season1?.count).to(equal(26))
                        done()
                    }
                }
                it("the character count for S02 is 36") {
                    waitUntil { done in
                        sut = CharacterViewModel(persistentContainer!)
                        let s02 = sut?.filterBySeason(filter: 2)
                        expect(s02?.count).to(equal(36))
                        done()
                    }
                }
                it("the character count for filter 0 is 63") {
                    waitUntil { done in
                        sut = CharacterViewModel(persistentContainer!)
                        let s = sut?.filterBySeason(filter: 0)
                        expect(s?.count).to(equal(63))
                        done()
                    }
                }
            }

        }
    }
}
