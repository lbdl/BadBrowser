//
//  TestSuiteHelpers.swift
//  BBFicationTests
//
//  Created by Tim Storey on 20/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import UIKit
import CoreData
@testable import BBFication

class MockManagedObject: NSManagedObject {
    static var entityName = "MockManagedObject"
}

class MockPersistenceManager: PersistenceControllerProtocol {
    let context: ManagedContextProtocol
    var didCallInsert: Bool?

    func updateContext(block: @escaping () -> ()) {
        print("MockPersistenceManager: called update context")
    }

    func insertObject<A>() -> A where A : Managed {
        didCallInsert = true
        return MockManagedObject() as! A
    }

    init(managedContext: ManagedContextProtocol) {
        context = managedContext
    }
}

class MockManagedContext: ManagedContextProtocol {
    var registeredObjects: Set<NSManagedObject>

    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] {
        return [MockManagedObject()] as! [T]
    }

    func save() throws {
        //
    }

    func delete(_ object: NSManagedObject) {
        //
    }

    func rollback() {
        //
    }

    init() {
        registeredObjects = Set([MockManagedObject()])
    }
}


class TestSuiteHelpers: NSObject {

    enum TestType {
        case characters
        case character
        case badCharacter

    }

    static func readLocalData(testCase: TestType) -> Data? {
        let testBundle = Bundle(for: self)
        var url: URL?

        switch testCase {
        case .characters:
            url = testBundle.url(forResource: "badLocations", withExtension: "json")
        case .character:
            url = testBundle.url(forResource: "badProfiles", withExtension: "json")
        case .badCharacter:
            url = testBundle.url(forResource: "locations", withExtension: "json")
                default:
            break
        }
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }

    // for testing without persisting data
    static func createInMemoryContainer (completion: @escaping(ManagedContextProtocol) -> ()) {
        let container = NSPersistentContainer(name: "BBModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        description.configuration = "Default"
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            guard error == nil else {
                fatalError("Failed to load in memory store \(error!)")
            }
        }
        DispatchQueue.main.async {
            completion(container.viewContext)
        }
    }
}
