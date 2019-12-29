//
//  ListViewModel.swift
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

    internal var _objects: [R]?

    init(ctx: ManagedContextProtocol) {
        let request = R.sortedFetchRequest
        self.controller = NSFetchedResultsController<R>(fetchRequest: request, managedObjectContext: ctx as! NSManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        controller.delegate = self
        try? controller.performFetch()
    }
    
    var fetchedObjects: [R] {
        guard let obj = _objects else {
            _objects = self.controller.fetchedObjects ?? []
            return _objects!
        }
        return obj
    }

    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        _objects = self.controller.fetchedObjects ?? []
        objectWillChange.send()
    }
    
    // MARK: ObservableObject
    var objectWillChange = ObservableObjectPublisher()
    
}

protocol SeasonFilter {
    func filterBySeason()
}

final class CharacterViewModel: ListViewModel<Character> {
    var seasonFilter: Int?
}

extension CharacterViewModel: SeasonFilter {
    func filterBySeason() {
        guard let f = seasonFilter else {return}

        let filteredObjects = self.fetchedObjects.filter({
            return $0.appearsIn(series: f)
        })
        
        self._objects = filteredObjects
    }
}


