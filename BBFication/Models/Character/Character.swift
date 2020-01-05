//
//  Character.swift
//  BBFication
//
//  Created by Tim Storey on 18/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Character: NSManagedObject {
    @NSManaged fileprivate(set) var cId: Int32
    @NSManaged fileprivate(set) var birthday: String
    @NSManaged fileprivate(set) var status: String
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var img_url: String
    @NSManaged fileprivate(set) var actor: Actor
    @NSManaged fileprivate(set) var occupations: Set<Occupation>
    @NSManaged fileprivate(set) var appearances: Set<Appearance>

    static func insert(into manager: PersistenceControllerProtocol, raw: CharacterRaw) -> Character {
        let character: Character = Character.fetchCharacter(forID: raw.id, fromManager: manager, withData: raw)
        return character
    }

    static func fetchCharacter(forID characterId: Int, fromManager manager: PersistenceControllerProtocol, withData raw: CharacterRaw) -> Character {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(cId), characterId)
        let character = fetchOrCreate(fromManager: manager, matching: predicate){
            //fresh baked so add simple fields
            $0.birthday = raw.birthday != $0.birthday ? raw.birthday : $0.birthday
            $0.status = raw.status != $0.status ? raw.status : $0.status
            $0.name = raw.name != $0.name ? raw.name : $0.name
            $0.img_url = raw.img_url != $0.img_url ? raw.img_url : $0.status
            $0.cId = raw.id != $0.cId ? Int32(raw.id) : $0.cId
            $0.actor = makeActor(raw: raw.actor, manager: manager)
            $0.occupations = Set(makeOccupations(raw: raw.occupations, manager: manager))
            $0.appearances = Set(makeAppearances(raw: raw, manager: manager))
        }
        return character
    }

    fileprivate static func makeActor(raw: String, manager: PersistenceControllerProtocol) -> Actor {
        let actor = Actor.insert(into: manager, raw: raw)
        return actor
    }

    fileprivate static func makeOccupations(raw: [String], manager: PersistenceControllerProtocol) -> [Occupation] {
        //make a pred for occupations
        let objArray: [Occupation] = raw.map({ occupationRaw in
            let occupation = Occupation.insert(into: manager, raw: occupationRaw)
            return occupation
        })
        return objArray
    }

    fileprivate static func makeAppearances(raw: CharacterRaw, manager: PersistenceControllerProtocol) -> [Appearance] {
        var appearancesArr = [Appearance]()
        _ = raw.BBSeasons.map({
            let uid = manager.uid()
            let app = Appearance.fetchAppearance(forID: uid, fromManager: manager , withData: AppearanceRaw(id: uid, show: "Breaking Bad", season: $0))
            appearancesArr.append(app)
        })
    
        _ = raw.BCSSeasons.map({
            let uid = manager.uid()
            let app = Appearance.fetchAppearance(forID: uid, fromManager: manager , withData: AppearanceRaw(id: uid, show: "Better Call Saul", season: $0))
            appearancesArr.append(app)
        })
        return appearancesArr
    }


}

extension Character: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: true)]
    }

    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Character"
}

extension Character: AppearsIn {
    func appearsIn(series: Int) -> Bool {
        let appearances = getAppearances(name: series, seriesName: "Breaking Bad")
        return appearances.count > 0 ? true : false
    }

     private func getAppearances(name: Int, seriesName series: String) -> Set<Appearance> {
        let resSet = appearances.filter { app in
            return app.episode.season.name == name && app.episode.season.show.name == series
        }
        return resSet
    }

}
