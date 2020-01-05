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

        context("GIVEN valid JSON") {
            
            describe("WHEN the persist methods have been called") {
                it("Creates Character Objects in the store") {
                    waitUntil { done in
                        let chars = try! persistentContainer?.fetch(characterRequest!)
                        let actual = chars?.first
                        expect(actual).to(beAKindOf(Character.self))
                        done()
                    }
                }
                it("creates the Bryan Cranston Character correctly"){
                    waitUntil { done in
                        characterRequest?.predicate = NSPredicate(format: "%K == %d",#keyPath(Character.cId), 1)
                        let res = try! persistentContainer?.fetch(characterRequest!)
                        let actual = res?.first
                        expect(actual!.occupations.count).to(equal(2))
                        expect(actual!.appearances.count).to(equal(5))
                        expect(actual!.nickname).to(equal("Heisenberg"))
                        done()
                    }
                }
                it("Walter White has the correct Actor") {
                    waitUntil { done in
                        let expectedName = "Bryan Cranston"
                        characterRequest?.predicate = NSPredicate(format: "%K == %d", #keyPath(Character.cId), 1)
                        let res = try! persistentContainer?.fetch(characterRequest!)
                        let character = res?.first!
                        let actorReq = NSFetchRequest<Actor>(entityName: Actor.entityName)
                        actorReq.predicate = NSPredicate(format: "%K == %@", #keyPath(Actor.name), expectedName)
                        let aRes = try! persistentContainer?.fetch(actorReq)
                        let actor = aRes?.first!
                        expect(actor).to(equal(character?.actor))
                        expect(actor?.name).to(equal("Bryan Cranston"))
                        done()
                    }
                }
                it("Walter White appears in all the shows seasons") {
                    waitUntil{ done in
                        characterRequest?.predicate = NSPredicate(format: "%K == %d", #keyPath(Character.cId), 1)
                        let res = try! persistentContainer?.fetch(characterRequest!)
                        let character = res?.first!
                        _ = character?.appearances.map{
                            switch $0.episode.season.name {
                            case 1:
                                expect($0.episode.season.show.name).to(equal("Breaking Bad"))
                            case 2:
                                expect($0.episode.season.show.name).to(equal("Breaking Bad"))
                            case 3:
                                expect($0.episode.season.show.name).to(equal("Breaking Bad"))
                            case 4:
                                expect($0.episode.season.show.name).to(equal("Breaking Bad"))
                            case 5:
                                expect($0.episode.season.show.name).to(equal("Breaking Bad"))
                            default:
                                fail()
                            }
                        }
                        done()
                    }
                }
                it("Mike Ermantraut appears in both BB seasons(2,3,4,5) and BCS seasons(1,2,3,4)") {
                    waitUntil { done in
                        characterRequest?.predicate = NSPredicate(format: "%K == %@", #keyPath(Character.name), "Mike Ehrmantraut")
                        let res = try! persistentContainer?.fetch(characterRequest!)
                        
                        let character = res?.first!
                        expect(character?.appearances.count).to(equal(8))
                        
                        let showReq = NSFetchRequest<Show>(entityName: Show.entityName)
                        showReq.predicate = NSPredicate(format: "%K == %@", #keyPath(name), "Breaking Bad")
                        let bbRes = try! persistentContainer?.fetch(showReq)
                        let bb = bbRes?.first!
                        
                        showReq.predicate = NSPredicate(format: "%K == %@", #keyPath(name), "Better Call Saul")
                        let bcsRes = try! persistentContainer?.fetch(showReq)
                        let bcs = bcsRes?.first!
                        
                        for app in character!.appearances {
                            switch app.episode.season.show.name {
                            case "Breaking Bad":
                                switch app.episode.season.name {
                                case 1:
                                    fail("Mike isn't in BB season 1")
                                case 2:
                                    expect(app.episode.season.show.name).to(equal(bb?.name))
                                case 3:
                                    expect(app.episode.season.show.name).to(equal(bb?.name))
                                case 4:
                                    expect(app.episode.season.show.name).to(equal(bb?.name))
                                case 5:
                                    expect(app.episode.season.show.name).to(equal(bb?.name))
                                default:
                                    fail()
                                }
                            case "Better Call Saul":
                                switch app.episode.season.name {
                                case 1:
                                    expect(app.episode.season.show.name).to(equal(bcs?.name))
                                case 2:
                                    expect(app.episode.season.show.name).to(equal(bcs?.name))
                                case 3:
                                    expect(app.episode.season.show.name).to(equal(bcs?.name))
                                case 4:
                                    expect(app.episode.season.show.name).to(equal(bcs?.name))
                                case 5:
                                    fail("Mike isnt in BCS season 5")
                                default:
                                    fail()
                                }
                            default:
                                  fail()
                            }
                        }
                        done()
                        }
                        }
                    }
                }
            }
        }
        
    

