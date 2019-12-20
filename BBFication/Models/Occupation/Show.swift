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
}
