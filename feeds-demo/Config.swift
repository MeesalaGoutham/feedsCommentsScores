//
//  Config.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//

//2 URL’s
//If none of the cases then default - like unknown error
//Feed url
//URL declare. If any errors from service. Then not going as it is error. Just used some custom urls.
//So used
//APIErrors
//feedURL_nextURL

import Foundation

struct Config {
    static let feedsURL = "http://www.reddit.com/.json"
    static let feedsURL_nextSet = "http://www.reddit.com/.json?after="
}

enum APIError: LocalizedError {
    case `default`
    case invalidURL
    case noData
    case parseError(info: String)
    case noInternet
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided."
        case .noData:
            return "Data not available at this moment."
        case .parseError(let info):
            return "Parse error occured." + " " + info
        case .noInternet:
            return "Internet not available."
        default:
            return "Unknown error occured."
        }
    }
}

