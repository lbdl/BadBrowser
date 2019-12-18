//
//  Mapped.swift
//  BBFication
//
//  Created by Tim Storey on 18/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation

/// An enum with associated values to be used by the
/// JSONMappingProtocol as a retur type that can encapsulate
/// any decoding errors or the decoded type held in generic type A
enum Mapped<A> {
    case MappingError(Error)
    case Value(A)

    func associatedValue() -> Any {
        switch self {
        case .MappingError(let value):
            return value
        case .Value(let value):
            return value
        }
    }
}
