//
//  DataManager.swift
//  BBFication
//
//  Created by Tim Storey on 18/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import UIKit
import Foundation

protocol DataControllerPrototcol {
    func fetch()
}

enum SessionType {
    case backgroundSession
    case sharedSession
    case emphemeralSession
}

enum HttpMethods: String {
    case get = "GET"
}

enum EndPoint: String {
    case characters
}

/// The data manager is intended to be passed between view controllers as a data handler
/// for remote data access and local data persistence.
/// It is only implemented for default sessions although it is intended to be extended
/// for background tasks.
///
/// This implementation also makes no considerations of authentication etc although
/// the data manager should handle all of this as per the servers requirements internally
/// and in an opaque manner as far as the consumers of the manager are concerned
///
/// A view controller should not need to know anything about it other
/// than to call the methods it needs as defined in the DataController protocol.
///
/// Data fetched is stored in CoreData. The views should be updated via a fetched results controller.

class DataManager: NSObject, DataControllerPrototcol {
    let persistenceManager: PersistenceControllerProtocol
    let dataSession: URLSessionProtocol
    let characterHander: AnyMapper<[CharacterRaw]>

    private let scheme: String = "https"
    private let host: String = "breakingbadapi.com"

    /// - Returns: an instance of DataManager
    ///
    /// - parameters:
    ///     - storeManager: an object conforming to the PerssistenceController protocol that handles persisting data
    ///     - networkManager: an object conforming to the URLSessionProtocol that fetches data
    ///     - configuration: a enumeration defining the tyle of sessionPersistenceManager, in this case default
    ///     - parser: a object conforming to the JSONMapper protocol passed as Type Erased object as we use associated types in the protocol
    required init(storeManager: PersistenceControllerProtocol, urlSession: URLSessionProtocol, configuration: SessionType = .sharedSession, parser: AnyMapper<Mapped<[CharacterRaw]>>) {
        persistenceManager = storeManager
        dataSession = urlSession
    }

    /// Fetches all JSON via the API really this method should throw
    /// and pass the error up the chain for both data fetch errors and parse/persist errors.
    /// Furthermore it should handle server codes other than straight success, namely 300, 400, 500 and the like
    /// however it doesn't, its naive and trusting **AKA** "I'm being lazy"
    /// - Returns: void
    func fetch()  {
        guard let url = buildURL(forEndPoint: .characters) else { return }
        guard let request = makeRequest(fromUrl: url) else { return }
        let task = dataSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            if error == nil  {
                guard let urlResponse = response as? HTTPURLResponse else { return }
                if  200...299 ~= urlResponse.statusCode {
                    guard let rawdata = data else { return }
                    strongSelf.characterHander.parse(rawValue: rawdata)
                    guard let val = strongSelf.characterHander.mappedValue else { return }
                    switch val {
                    case .MappingError:
                        //handle the parsing error
                        print ("mapping error \(val.associatedValue())")
                    case .Value:
                        strongSelf.characterHander.persist(rawJson: val)
                    }
                }
            } else {
                //handle the network error
                //not implemented
            }
        }
        task.resume()
    }


    private func buildURL(forEndPoint endPoint: EndPoint) -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host

        switch endPoint {
        case .characters:
                urlComponents.path = "/api/characters"
        }

        return urlComponents.url
    }


    private func makeRequest(fromUrl url: URL, forMethod method: HttpMethods = HttpMethods.get) -> URLRequest? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        return request as URLRequest
    }

}
