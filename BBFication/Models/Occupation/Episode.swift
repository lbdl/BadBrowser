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
    @NSManaged fileprivate(set) var id: String
    @NSManaged fileprivate(set) var season: Season
    @NSManaged fileprivate(set) var appearances: Set<Appearance>
}
