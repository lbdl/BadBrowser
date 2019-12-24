//
//  Season.swift
//  BBFication
//
//  Created by Tim Storey on 20/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Season: NSManagedObject {
    @NSManaged fileprivate(set) var name: Int
    @NSManaged fileprivate(set) var episodes: Set<Episode>
    @NSManaged fileprivate(set) var show: Show

    static func insert(into manager: PersistenceControllerProtocol, raw: SeasonRaw) -> Season {
        let season: Season = fetchSeason(forID: raw.name, fromManager: manager, withJSON: raw)
        return season
    }

    static func fetchSeason(forID seasonID: Int, fromManager manager: PersistenceControllerProtocol, withJSON raw: SeasonRaw) -> Season {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(name), seasonID)
        let season = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.name = $0.name != raw.name ? raw.name : $0.name
            $0.show = Show.fetchShow(forID: raw.show, fromManager: manager, withJSON: ShowRaw(name: raw.show))
        }
        return season
    }
}

extension Season: Managed {
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

struct SeasonRaw {
    let name: Int
    let show: String
}