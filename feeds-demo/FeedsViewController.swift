//
//  FeedsViewController.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//
//first app load the ViewController will loads
//then comes in to viewdidload then will set the tableview
//fetchFeeds() // Hit the API and get the feeds data
//extension FeedsViewController {
// below tableview delegate methods... intial ga 0 so not display...once fetchfeeds -From service will get data then parsing then didfinish will hits..
//then will get results - contains 2 things - 1.success(feedsarray) 2.error(fails)
//1.ifsuccesss  -  then will takes "feedsarray" and
//if fails then "error" will take

//kind of enum type -> success - if sucess then only feeds will come and  Result<[Feed], Error>) will get nil -
//utility function is there - so will show user if there is no internet connection("nointernetconnection") - extension FeedsViewController: FeedsViewDelegate
// Infinite scrolling - scrollViewDidScroll
//for better performance used sdwebimage - concentrated on memory as well...so it will release the memory...
// how many times will - scroll...  that many times will call the api...
// nextSet when infinite scrolling
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
    // below tableview delegate methods... intial ga 0 so not display...once fetchfeeds -From service will get data after parsing then didfinish will hits
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feeds.count
    }
    // feed(feedsCell) will set here through cellforrowatindex from feedsVC - settermethod.
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
            viewModel.fetchFeeds(nextSet: Config.feedsURL_nextSet) // nextSet when calls when infinite scrolling...if we sent nextset it will takes and do... otherwise feedsurl will takes.
        }
    }
    
}

extension FeedsViewController: FeedsViewDelegate {
    //once fetchfeeds will get data then didfinish will hits
    func didFinish(_ result: Result<[Feed], Error>) { //then will get results - contains 2 things if - sucess then only feeds Result<[Feed], Error>) will get nil
        switch result {
        case .success(let feeds):
            self.feeds.append(contentsOf: feeds)
            tableView.reloadData()
        case .failure(let error):
            showError(error)
        }
    }
    
}

