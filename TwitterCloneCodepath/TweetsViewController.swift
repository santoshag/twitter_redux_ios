import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]! = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        UIApplication.shared.statusBarStyle = .lightContent
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        let logo = UIImage(named: "logo_white.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
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
    
    @IBAction func onHamburgerClick(_ sender: Any) {
//        let translation = sender.translation(in: view)
//        let velocity = sender.velocity(in: view)
//        
//        if sender.state == UIGestureRecognizerState.began {
//            originalLeftMargin = leftMarginConstraint.constant
//        } else if sender.state == UIGestureRecognizerState.changed {
//            leftMarginConstraint.constant = originalLeftMargin + translation.x
//            
//        } else if sender.state == UIGestureRecognizerState.ended {
//            
//            UIView.animate(withDuration: 0.3, animations: {
//                if velocity.x > 0 {
//                    self.leftMarginConstraint.constant =  self.view.frame.size.width - 50
//                } else {
//                    self.leftMarginConstraint.constant = 0
//                }
//                self.view.layoutIfNeeded()
//            })
//        }
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
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 140
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            }, failure: { (error: Error) in
                print(error)
        })
    }
    
    func tweetCell(tweetCell: TweetCell, userScreenName value: String) {
        TwitterClient.sharedInstance?.getUser(screenName: value, success: { (user: User) in
            self.user = user
            self.performSegue(withIdentifier: "showUserProfileFromHome", sender: nil)
        }, failure: { (error: Error) in
            print(error)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetDetailsFromHome" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let readTweetViewController = segue.destination as! ReadTweetViewController
            readTweetViewController.tweet = tweet
        } else if segue.identifier == "showUserProfileFromHome" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = self.user
        }
    }

}
