//
//  CharacterPersistanceTests.swift
//  BBFication
//
//  Created by Timothy Storey on 24/12/2019.
//Copyright © 2019 Tim Storey. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import BBFication

class CharacterPersistanceTests: QuickSpec {
    
    
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
        
        beforeEach {
            characterRequest = NSFetchRequest<Character>(entityName: Character.entityName)
            rawData = T.readLocalData(testCase: .characters)
            T.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = CharacterMapper(storeManager: manager!)
            })
        }
        

        afterEach {
            flush()
        }
        
        context("GIVEN valid JSON") {
            
            describe("WHEN the persist methods have been called") {
                it("Creates Character Objects in the store") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let chars = try! persistentContainer?.fetch(characterRequest!)
                        let actual = chars?.first
                        expect(actual).to(beAKindOf(Character.self))
                        done()
                    }
                }
                it("creates the Bryan Cranston Character correctly"){
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        characterRequest?.predicate = NSPredicate(format: "%K == %d",#keyPath(Character.id), 1)
                        let res = try! persistentContainer?.fetch(characterRequest!)
                        let actual = res?.first
                        expect(actual!.actor.name).to(equal("Bryan Cranston"))
                        expect(actual!.occupations.count).to(equal(2))
                        done()
                    }
                }
            }
        }
        
    }
}
