//
//  OccupationRaw.swift
//  BBFication
//
//  Created by Tim Storey on 19/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation

class OccupationMapper: JSONMappingProtocol {

    internal var decoder: JSONDecodingProtocol
    internal var mappedValue: MappedValue?
    internal var persistanceManager: PersistenceControllerProtocol

    typealias MappedValue = Mapped<[OccupationRaw]>
    typealias raw = Data

    required init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol=JSONDecoder()) {
        persistanceManager = storeManager
        self.decoder = decoder
    }


    var rawValue: raw? {
        didSet {
            parse(rawValue: rawValue!)
        }
    }

    internal func parse(rawValue: Data) {
        do {
            let tmp = try decoder.decode([OccupationRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }

    internal func persist(rawJson: MappedValue) {
        if let obj = rawJson.associatedValue() as? [OccupationRaw] {
            persistanceManager.updateContext(block: {
                _ = obj.map({ [weak self] occupation in
                    guard let strongSelf = self else { return }
                    _ = Occupation.insert(into: strongSelf.persistanceManager, raw: occupation)
                })
            })
        }
    }
}

struct OccupationRaw: Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "occupation"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }

    // conveniance init for the persistance manager tests
    internal init() {
        name = ""
    }
    let name: String
}
