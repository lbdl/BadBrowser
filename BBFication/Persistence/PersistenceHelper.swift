//
//  PersistenceHelper.swift
//  BBFication
//
//  Created by Tim Storey on 18/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import UIKit
import CoreData

class PersistenceHelper: NSObject {

    static func createProductionContainer (completion: @escaping(NSManagedObjectContext) -> ()) {
        let container = NSPersistentContainer(name: "AirTasks")
        container.loadPersistentStores { (_, error) in
            guard error == nil else {
                fatalError("Failed to load store: \(error!)")
            }
            DispatchQueue.main.async {
                completion(container.viewContext)
            }
        }
    }
}
