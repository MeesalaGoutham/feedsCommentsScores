//
//  FeedCell.swift
//  feeds-demo
//
//  Created by Goutham Meesala on 05/12/21.
//

import UIKit
import SDWebImage

class FeedCell: UITableViewCell {

    private let feedTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let feedImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let feedCommentsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let feedScoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var feed: Feed? {
        didSet {
            configureCell()
        }
    }
        
    private func configureCell() {
        guard let feed = feed else { return }
        
        feedTitleLabel.text = feed.title
        feedCommentsLabel.text = "Comments: " + (feed.num_comments?.toString() ?? "")
        feedScoreLabel.text = "Score: " + (feed.score?.toString() ?? "")
        
        if let urlString = feed.thumbnail, let url = URL(string: urlString) {
            feedImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "glasses"))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(feedTitleLabel)
        contentView.addSubview(feedImageView)

        let hStack = UIStackView(arrangedSubviews: [feedCommentsLabel,feedScoreLabel])
        hStack.distribution = .fillEqually
        hStack.axis = .horizontal
        hStack.spacing = 0
        contentView.addSubview(hStack)
        
        feedTitleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: feedImageView.topAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0, enableInsets: false)
        
        feedImageView.anchor(top: feedTitleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: hStack.topAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: CGFloat(feed?.thumbnail_width ?? 0), height: CGFloat(feed?.thumbnail_height ?? 0), enableInsets: false)
        
        hStack.anchor(top: feedImageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var cellId: String {
        "FeedCell"
    }

}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func downloadImage(url: URL, completion: ((UIImage?) -> Void)? = nil) {
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = imageFromCache
            completion?(imageFromCache)
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion?(image)
                }
            }
        }.resume()
    }
    
}
