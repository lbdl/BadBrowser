//
//  Occupation.swift
//  BBFication
//
//  Created by Tim Storey on 18/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Occupation: NSManagedObject {
    @NSManaged fileprivate(set) var name: String

    static func insert(into manager: PersistenceControllerProtocol, raw: String) -> Occupation {
        let occupation: Occupation = Occupation.fetchOccupation(forID: raw, fromManager: manager)
        return occupation
    }

    static func fetchOccupation(forID occupationName: String, fromManager manager: PersistenceControllerProtocol) -> Occupation {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(name), occupationName)
        let occupation = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.name = $0.name != occupationName ? occupationName : $0.name
        }
        return occupation
    }

}


extension Occupation: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: true)]
    }

    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Occupation"
}
