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




}
