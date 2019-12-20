//
//  Show.swift
//  BBFication
//
//  Created by Tim Storey on 20/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Show: NSManagedObject {
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var seasons: Set<Season>

    static func insert(into manager: PersistenceControllerProtocol, raw: ShowRaw) -> Show {
        let show: Show = fetchShow(forID: raw.name, fromManager: manager, withJSON: raw)
        return show
    }

    static func fetchShow(forID showID: String, fromManager manager: PersistenceControllerProtocol, withJSON raw: ShowRaw) -> Show {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(name), showID)
        let show = fetchOrCreate(fromManager: manager, matching: predicate) {
            if $0.name != raw.name {
                $0.name = raw.name
            }
        }
        return show
    }
}

extension Show: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: true)]
    }

    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Show"
}

struct ShowRaw {
    let name:String
}

