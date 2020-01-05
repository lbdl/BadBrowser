//
//  Episode.swift
//  BBFication
//
//  Created by Tim Storey on 20/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Episode: NSManagedObject {
    @NSManaged fileprivate(set) var eId: String
    @NSManaged fileprivate(set) var season: Season
    @NSManaged fileprivate(set) var appearances: Set<Appearance>

    static func insert(into manager: PersistenceControllerProtocol, raw: EpisodeRaw) -> Episode {
        let episode: Episode = fetchEpisode(forID: raw.eId, fromManager: manager, withJSON: raw)
        return episode
    }

    static func fetchEpisode(forID epID: String, fromManager manager: PersistenceControllerProtocol, withJSON raw: EpisodeRaw) -> Episode {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(eId), epID)
        let episode = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.eId = raw.eId != $0.eId ? raw.eId : $0.eId
            $0.season = raw.season == $0.season.name ? $0.season : fetchSeason(forID: raw.season, fromManager: manager, withJSON: raw)

        }
        return episode
    }

    static func fetchSeason(forID seasonId: Int, fromManager manager: PersistenceControllerProtocol, withJSON raw: EpisodeRaw) -> Season {
        let season = Season.insert(into: manager, raw: SeasonRaw(name: raw.season, show: raw.show))
        return season
    }
}

extension Episode: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(eId), ascending: true)]
    }
    
    static var entityName = "Episode"
}


struct EpisodeRaw {
    let eId:String
    let show: String
    let season: Int
}
