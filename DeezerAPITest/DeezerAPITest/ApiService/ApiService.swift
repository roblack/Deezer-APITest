//
//  ApiService.swift
//  DeezerAPITest
//
//  Created by Emin Roblack on 04/02/2020.
//  Copyright © 2020 Emin Roblack. All rights reserved.
//

import Foundation
import UIKit.UIImage

public enum APIResult<T> {
    case success(T?)
    case failure(APIError)
}

struct ApiService {

    let cache = NSCache<NSString, UIImage>()
    static let apiBaseUrl: String = "https://api.deezer.com/"

    enum ApiCall: String {
        case search                       = "search/artist?q="
        case artistAlbums                 = "artist/%@/albums/"
        case album                        = "album/%@"
        case tracks                       = "album/%@/tracks"
        case allTracks                    = "album/%@/tracks?limit=%d"
        
        var urlString: String {
            return ApiService.apiBaseUrl + self.rawValue
        }
    }
}

public enum APIError : Error, CustomStringConvertible {
    case InvalidURL
    // Can't connect to the server (maybe offline?)
    case ConnectionError(error: Error)
    // The server responded with a non 200 status code
    case ServerError(statusCode: Int)
    // We got no data (0 bytes) back from the server
    case NoDataError
    // The server responded with a non 200 status internal code
    case ServerInternalError(statusCode: Int, message: String?, errors: Any?)
    // Custom Error
    case BadDataError(error: Error)
    // Unauthorized access - user not verified
    case NotVerified

    public var description: String {
        switch self {
        case .InvalidURL:
            return "Invalid URL"
        case .ConnectionError(let error):
            return "Can't connect to the server (maybe offline?) ❓ Error: \(error.localizedDescription)"
        case .ServerError(let statusCode):
            return "The server responded with a non 200 status code ❓ StatusCode: \(statusCode)"
        case .NoDataError:
            return "We got no data (0 bytes) back from the server"
        case .ServerInternalError(let statusCode, let message, let errors):
            return "The server responded with a non 200 status code ❓ StatusCode: \(statusCode) ❓ Message: \(message ?? "") ❓ ServerError: \(String(describing: errors))"
        case .BadDataError(let error):
            return "Received bad data: \(error.localizedDescription)"
        case .NotVerified:
            return "User not verified"
        }
    }
}
