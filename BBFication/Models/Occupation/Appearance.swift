//
//  Appearance.swift
//  BBFication
//
//  Created by Tim Storey on 20/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData

final class Appearance: NSManagedObject {
    @NSManaged fileprivate(set) var id: String
    @NSManaged fileprivate(set) var character: Character
    @NSManaged fileprivate(set) var episode: Episode

    static func insert(into manager: PersistenceControllerProtocol, raw: AppearanceRaw) -> Appearance {
        let appearance: Appearance = Appearance.fetchAppearance(forID: raw.id, fromManager: manager, withData: raw)
        return appearance
    }

    static func fetchAppearance(forID appearanceId: String, fromManager manager: PersistenceControllerProtocol, withData raw: AppearanceRaw) -> Appearance {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), appearanceId)
        let appearance = fetchOrCreate(fromManager: manager, matching: predicate){
            $0.id = raw.id != $0.id ? raw.id : $0.id
            if !($0.episode.season.show.name == raw.show && raw.season == $0.episode.season.name) {
                let epID = manager.uid()
                $0.episode = Episode.fetchEpisode(forID: epID, fromManager: manager, withJSON: EpisodeRaw(id: epID, show: raw.show, season: raw.season))
            }
        }
        return appearance
    }

}

extension Appearance: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }


}

struct AppearanceRaw {
    let id: String
    let show: String
    let season: Int
}
