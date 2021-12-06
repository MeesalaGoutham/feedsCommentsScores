//
//  Config.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//

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

