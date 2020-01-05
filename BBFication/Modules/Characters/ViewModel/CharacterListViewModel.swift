//
//  CharacterListViewModel.swift
//  BBFication
//
//  Created by Tim Storey on 29/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation

protocol SeasonFilter {
    func filterBySeason(filter: Int) -> [Character]
}

final class CharacterViewModel: ListViewModel<Character> {
    var filteredObjects: [Character]?
    let availableSeasons:[Int] = [0,1,2,3,4,5]
}

extension CharacterViewModel: SeasonFilter {
    func filterBySeason(filter: Int) -> [Character] {
        filteredObjects = filter == 0 ? self.fetchedObjects : self.fetchedObjects.filter({return $0.appearsIn(series: filter) })
        return filteredObjects ?? []
    }

}
