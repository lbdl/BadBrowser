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
}
