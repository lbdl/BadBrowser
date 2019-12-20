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
    @NSManaged fileprivate(set) var id: Int
    @NSManaged fileprivate(set) var birthday: String
    @NSManaged fileprivate(set) var status: String
    @NSManaged fileprivate(set) var nickname: String
    @NSManaged fileprivate(set) var img_url: String
    @NSManaged fileprivate(set) var actor: Actor
    @NSManaged fileprivate(set) var occupations: Set<Occupation>
    @NSManaged fileprivate(set) var appearences: Set<Appearance>

    static func insert(into manager: PersistenceControllerProtocol, raw: CharacterRaw) -> Character {
        let character: Character = Character.fetchCharacter(forID: raw.id, fromManager: manager, withData: raw)
        return character
    }

    static func fetchCharacter(forID characterId: Int, fromManager manager: PersistenceControllerProtocol, withData raw: CharacterRaw) -> Character {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), characterId)
        let character = fetchOrCreate(fromManager: manager, matching: predicate){
            //fresh baked so add simple fields
            $0.birthday = raw.birthday
            $0.status = raw.status
            $0.img_url = raw.img_url
            $0.id = raw.id
            $0.actor = makeActor(raw: raw.actor, manager: manager)
            $0.occupations = Set(makeOccupations(raw: raw.occupations, manager: manager))
        }
        return character
    }

    fileprivate static func makeActor(raw: ActorRaw, manager: PersistenceControllerProtocol) -> Actor {
        let actor = Actor.insert(into: manager, raw: raw)
        return actor
    }

    fileprivate static func makeOccupations(raw: [OccupationRaw], manager: PersistenceControllerProtocol) -> [Occupation] {
        //make a pred for occupations
        let objArray: [Occupation] = raw.map({ occupationRaw in
            let occupation = Occupation.insert(into: manager, raw: occupationRaw)
            //let profile = Profile.fetchProfile(forID: profileRaw.id, fromManager: manager, withJSON: profileRaw)
            return occupation
        })
        return objArray
    }


}

extension Character: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }

    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Character"
}
