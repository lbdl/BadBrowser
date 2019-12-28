import Quick
import Nimble
import CoreData

@testable import BBFication

class ScreenFilterPredicateTests: QuickSpec {

    typealias H = Helpers
    typealias T = TestSuiteHelpers
    override func spec() {

        var rawData: Data?
        var sut: CharacterMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?
        var characterRequest: NSFetchRequest<Character>?

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
            characterRequest = NSFetchRequest<Character>(entityName: Character.entityName)
            rawData = T.readLocalData(testCase: .characters)
            T.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = CharacterMapper(storeManager: manager!)
                sut?.parse(rawValue: rawData!)
                sut?.persist(rawJson: (sut?.mappedValue)!)
            })
        }

        beforeEach {
            sut?.parse(rawValue: rawData!)
            sut?.persist(rawJson: (sut?.mappedValue)!)
        }

        afterEach {
            flush()
        }

        describe("GIVEN valid JSON") {
            context("WHEN we test characters for S02 appearances") {
                it("Walter White appears") {
                    waitUntil { done in
                        characterRequest?.predicate = NSPredicate(format: "%K == %@", #keyPath(Character.name), "Walter White")
                        let resSet = try! persistentContainer?.fetch(characterRequest!)
                        let actual = resSet?.first
                        expect(actual!.appearsIn(series: 2)).to(beTrue())
                        done()
                    }
                }
                it("Todd Alquist does NOT appear") {
                    waitUntil { done in
                        characterRequest?.predicate = NSPredicate(format: "%K == %@", #keyPath(Character.name), "Todd Alquist")
                        let resSet = try! persistentContainer?.fetch(characterRequest!)
                        let actual = resSet?.first
                        expect(actual!.appearsIn(series: 2)).to(beFalse())
                        done()
                    }
                }
            }

        }
    }
}
