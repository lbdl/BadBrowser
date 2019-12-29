//
//  CharacterListVireModel.swift
//  BBFication
//
//  Created by Timothy Storey on 28/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine


class ListViewModel<R: Managed>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let controller: NSFetchedResultsController<R>

    init(obj: R, ctx: ManagedContextProtocol) {
        let request = NSFetchRequest<R>(entityName: R.entityName)
        self.controller = NSFetchedResultsController<R>(fetchRequest: request, managedObjectContext: ctx as! NSManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        controller.delegate = self
        try? controller.performFetch()
    }
    
    var fetchedObjects: [R] {
        return self.controller.fetchedObjects ?? []
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    
    // MARK: ObservableObject
    var objectWillChange = ObservableObjectPublisher()
    
}

protocol SeasonFilter {
    associatedtype V
    func filterBySeason(name: Int) -> [V]
}

final class CharacterViewModel: ListViewModel<Character> {}

extension CharacterViewModel: SeasonFilter {
    func filterBySeason(name: Int) -> [Character] {
        return self.fetchedObjects.filter({
            $0.appearsIn(series: name)
        })
        
    }
}


