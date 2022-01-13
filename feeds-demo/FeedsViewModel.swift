//
//  FeedsViewModel.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//
// viewmodel - will do api call calling from feedsviewcontroller.

import UIKit

protocol FeedsViewDelegate: AnyObject {
    func didFinish(_ result: Result<[Feed], Error>)
}

class FeedsViewModel {
    
    private let apiClient = APIClient()
    
    weak var delegate: FeedsViewDelegate?
        
    // Hit the API to fetch the feeds
    func fetchFeeds(nextSet: String? = nil, completion: (([Feed], Error?) -> Void)? = nil) {
        guard !apiClient.isBusy else { return }
        
        apiClient.fetchFeeds(nextSet: nextSet) { [weak self] newFeeds, error in
            guard let self = self else { return }
            
            guard let err = error else {
                self.delegate?.didFinish(.success(newFeeds))
                completion?(newFeeds, nil)
                return
            }
            self.delegate?.didFinish(.failure(err))
            completion?([], err)
        }
    }
    
    
}
