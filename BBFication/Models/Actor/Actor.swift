//
//  Actor.swift
//  BBFication
//
//  Created by Tim Storey on 18/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Actor: NSManagedObject {
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var characters: Set<Character>?

    static func insert(into manager: PersistenceControllerProtocol, raw: ActorRaw) -> Actor {
        let actor: Actor = Actor.fetchActor(forID: raw.name, fromManager: manager)
        return actor
    }

    static func fetchActor(forID actorName: String, fromManager manager: PersistenceControllerProtocol) -> Actor {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(name), actorName)

        let actor = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.name = actorName
        }
        return actor
    }

}

extension Location: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }

    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Location"
}
