//
//  CharacterMapper.swift
//  BBFication
//
//  Created by Tim Storey on 19/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation


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
        occupations = try! container.decode([OccupationRaw].self, forKey: .occupationStrings)
        BCSSeasons = try! container.decode([Int].self, forKey: .BCSSeasons)
        BBSeasons = try! container.decode([Int].self, forKey: .BBSeasons)
        actor = try! container.decode(ActorRaw.self, forKey: .actorName)
        status = try! container.decode(String.self, forKey: .status)
    }

    let id: Int
    let name: String
    let birthday: String
    let status: String
    let img_url: String
    let occupations: [OccupationRaw]
    let BCSSeasons: [Int]
    let BBSeasons: [Int]
    let actor: ActorRaw
}
