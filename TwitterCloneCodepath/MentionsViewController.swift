
import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]! = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        TwitterClient.sharedInstance?.mentions(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 140
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onComposeButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let composeTweetViewController = storyboard.instantiateViewController(withIdentifier: "ComposeTweetViewController")
        let composeNavigationController = UINavigationController(rootViewController: composeTweetViewController)
        self.present(composeNavigationController, animated:true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.mentions(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 140
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        self.performSegue(withIdentifier: "showTweetDetails", sender: nil)
    }
    
    func tweetCell(tweetCell: TweetCell, userScreenName value: String) {
        TwitterClient.sharedInstance?.getUser(screenName: value, success: { (user: User) in
            self.user = user
            self.performSegue(withIdentifier: "showUserProfileFromMentions", sender: nil)
        }, failure: { (error: Error) in
            print(error)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetDetailsFromMentions" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let readTweetViewController = segue.destination as! ReadTweetViewController
            readTweetViewController.tweet = tweet
        } else if segue.identifier == "showUserProfileFromMentions" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = self.user
        }
    }


}
