
import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func tweetCell(tweetCell: TweetCell, userScreenName value: String)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            userImageView.setImageWith(tweet.userImageUrl!)
            userNameLabel.text = tweet.userName
            userHandleLabel.text = "@\(tweet.userHandle!)"
            tweetTimestampLabel.text = formatDate(date: tweet.timestamp!)
            tweetTextLabel.text = tweet.text
            retweetsLabel.text = String(tweet.retweetCount)
            likesLabel.text = String(tweet.favoritesCount)
            
            let retweeterName = tweet.retweeterName
            if retweeterName != nil {
                actionImageView.isHidden = false
                actionLabel.isHidden = false
                let rt = UIImage(named: "retweet.png")
                actionImageView.image = rt
                actionLabel.text = "\(tweet.retweeterName!) Retweeted"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetCell.handleTap))
        tapGesture.delegate = self;
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .none
//        self.selectedBackgroundView = backgroundView
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        let screenName = userHandleLabel.text as String!
        delegate?.tweetCell?(tweetCell: self, userScreenName: screenName!)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let dateStr = formatter.string(from: date)
        
        return dateStr
    }

}


