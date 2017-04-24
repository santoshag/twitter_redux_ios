
import UIKit

class ReadTweetViewController: UIViewController {

    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    
    var tweet: Tweet!
    var retweeted: Bool = false
    var favorited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        userImageView.setImageWith(tweet.userImageUrl!)
        userNameLabel.text = tweet.userName
        userHandleLabel.text = "@\(tweet.userHandle!)"
//        //            tweetTimestampLabel =
        tweetTextLabel.text = tweet.text
        retweetsLabel.text = String(tweet.retweetCount)
        favoritesLabel.text = String(tweet.favoritesCount)

        let retweeterName = tweet.retweeterName
        if retweeterName != nil {
            actionImageView.isHidden = false
            actionLabel.isHidden = false
            let rt = UIImage(named: "retweet.png")
            actionImageView.image = rt
            actionLabel.text = "\(tweet.retweeterName!) Retweeted"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyButtonPush(_ sender: AnyObject) {
        let image = UIImage(named: "reply_on.png")
        replyButton.setImage(image, for: .normal)

    }
    
    @IBAction func onRetweetButtonPush(_ sender: AnyObject) {
        if self.retweeted == false {
            let idStr = tweet.id! as String
            TwitterClient.sharedInstance?.retweet(id: idStr, success: {
                print("Success Retweet")
                let image = UIImage(named: "retweet_on")
                self.retweetButton.setImage(image, for: .normal)
                self.retweeted = true
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onFavoriteButtonPush(_ sender: AnyObject) {
        if self.favorited == false {
            let idStr = tweet.id! as String
            TwitterClient.sharedInstance?.favorite(id: idStr, success: {
                print("Success Favorite")
                let image = UIImage(named: "like_on")
                self.favoriteButton.setImage(image, for: .normal)
                self.favorited = true
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
