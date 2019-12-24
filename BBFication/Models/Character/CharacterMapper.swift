//
//  CharacterMapper.swift
//  BBFication
//
//  Created by Tim Storey on 19/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation

class CharacterMapper: JSONMappingProtocol {

    internal var decoder: JSONDecodingProtocol
    internal var mappedValue: MappedValue?
    internal var persistanceManager: PersistenceControllerProtocol

    typealias MappedValue = Mapped<[CharacterRaw]>
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
            let tmp = try decoder.decode([CharacterRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }

    internal func persist(rawJson: MappedValue) {
        if let obj = rawJson.associatedValue() as? [CharacterRaw] {
            persistanceManager.updateContext(block: {
                _ = obj.map({ [weak self] location in
                    guard let strongSelf = self else { return }
                    _ = Character.insert(into: strongSelf.persistanceManager, raw: location)
                })
            })
        }
    }
}

struct CharacterRaw: Decodable {

    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name = "name"
        case birthday = "birthday"
        case img_url = "img"
        case status = "status"
        case occupationStrings = "occupation"
        case BCSSeasons = "better_call_saul_appearance"
        case actorName = "portrayed"
        case BBSeasons = "appearance"

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try! container.decode(Int.self, forKey: .id)
        name = try! container.decode(String.self, forKey: .name)
        birthday = try! container.decode(String.self, forKey: .birthday)
        img_url = try! container.decode(String.self, forKey: .img_url)
        occupations = try! container.decode([String].self, forKey: .occupationStrings)
        BCSSeasons = try! container.decode([Int].self, forKey: .BCSSeasons)
        BBSeasons = try! container.decode([Int].self, forKey: .BBSeasons)
        actor = try! container.decode(String.self, forKey: .actorName)
        status = try! container.decode(String.self, forKey: .status)
    }

    let id: Int
    let name: String
    let birthday: String
    let status: String
    let img_url: String
    let occupations: [String]
    let BCSSeasons: [Int]
    let BBSeasons: [Int]
    let actor: String
}
