//
//  FeedsViewController.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//

import UIKit

class FeedsViewController: UITableViewController {
    
    private var feeds: [Feed] = []
    
    let viewModel = FeedsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.cellId)
        tableView.separatorStyle = .none
        
        viewModel.delegate = self
        viewModel.fetchFeeds() // Hit the API and get the feeds data
    }

}

extension FeedsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellId) as? FeedCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.feed = feeds[indexPath.row]
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if feeds.count > 0, distanceFromBottom < height {
            // Infinite scrolling
            viewModel.fetchFeeds(nextSet: Config.feedsURL_nextSet)
        }
    }
    
}

extension FeedsViewController: FeedsViewDelegate {
    
    func didFinish(_ result: Result<[Feed], Error>) {
        switch result {
        case .success(let feeds):
            self.feeds.append(contentsOf: feeds)
            tableView.reloadData()
        case .failure(let error):
            showError(error)
        }
    }
    
}

