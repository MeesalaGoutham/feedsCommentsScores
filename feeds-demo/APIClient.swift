//
//  APIClient.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//

//APIClient - no need-
// connectivityMonitor - internet connection (it will check the connection)
//Just in case network connectivity issue //Used guard Else is connected
//InvalidUrl
//Nointernet
//noData
//self.isConnected = true // setting true internet on
//self.isConnected = false// setting false internet off
//self.isBusy = true - one by one. if api call happened... but the method hits again then api call will go again... so by avoiding the continuous call. I used isbusy.
//didscroll(fetchFeeds)thismethod... it is calling atleast 60-70 times...isbusy set in feedsviewmodel....if it is "isbusy" then it wont go to "feedsviewmodel" isbusy=false then guard true in feedsviewmodel then apiClient.fetchFeeds will call... so there wont be multiple hits if we do pagination.




import Foundation
import Network

class APIClient {
    
    private let connectivityMonitor = NWPathMonitor()
    private(set) var isConnected: Bool = true
    private(set) var isBusy: Bool = false
    
    init() {
        connectivityMonitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
                self.isConnected = true // setting true internet on
            } else {
                print("There's no internet connection.")
                self.isConnected = false// setting false internet off
            }
        }
        //checking here continuously internet is on or not
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        connectivityMonitor.start(queue: queue)
    }
    
    /**
     Validate inputs for base url and end point then generate proper URL object
     */
    private func constructURL(baseURL: String, endPoint: String) -> URL? {
        guard endPoint.count > 0 else {
            return URL(string: baseURL)
        }
        var urlString = ""
        if baseURL.hasSuffix("/") && endPoint.hasPrefix("/") {
            urlString = String(baseURL.dropLast()).appending(endPoint)
        }
        else if (baseURL.hasSuffix("/") && !endPoint.hasPrefix("/")) ||
                !baseURL.hasSuffix("/") && endPoint.hasPrefix("/") {
            urlString = baseURL.appending(endPoint)
        }
        else {
            urlString = baseURL.appending("/").appending(endPoint)
        }
        return URL(string: urlString)
    }
    
}

// MARK: - Service calls for public interface

extension APIClient {
    
    func fetchFeeds(nextSet: String? = nil, completion: @escaping ([Feed], Error?) -> Void) {
        guard let url = constructURL(baseURL: nextSet ?? Config.feedsURL, endPoint: "") else {
            completion([], APIError.invalidURL)
            return
        }
        guard isConnected else {
            completion([], APIError.noInternet)
            return
        }
        self.isBusy = true //if api call happened... but the method hits again then api call will go again... so by avoiding the continuous call. I used isbusy.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            threadSafeCall {
                self.isBusy = false
                guard let data = data else {
                    completion([], APIError.noData)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
                    // Parse data
                    var feedsArray: [Feed] = []
                    if let dict = json as? [String: Any], let data = dict["data"] as? [String: Any], let children = data["children"] as? [[String: Any]] {
                        children.forEach { obj in
                            if let data = obj["data"] as? [String: Any] {
                                feedsArray.append(Feed(title: data["title"] as? String,
                                                       thumbnail_height: data["thumbnail_height"] as? Int,
                                                       thumbnail_width: data["thumbnail_width"] as? Int,
                                                       score: data["score"] as? Int,
                                                       num_comments: data["num_comments"] as? Int,
                                                       thumbnail: data["thumbnail"] as? String))
                            }
                        }
                    }
                    completion(feedsArray, nil)
                }
                catch let error {
                    completion([], APIError.parseError(info: error.localizedDescription))
                }
            }
        }
        task.resume()
    }
    
}
