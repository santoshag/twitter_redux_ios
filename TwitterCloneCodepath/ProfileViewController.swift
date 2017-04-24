

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerBarButtonItem: UIBarButtonItem!
    
    var tweets: [Tweet]! = []
    var user = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        UIApplication.shared.statusBarStyle = .lightContent
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        TwitterClient.sharedInstance?.userTimeline(screenName: (user?.screenName)!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 140
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error)
        })
        
        if user?.screenName == User.currentUser?.screenName {
            self.title = "Me"
            self.navigationItem.leftBarButtonItem = hamburgerBarButtonItem
        } else {
            self.title = user?.screenName
            self.navigationItem.leftBarButtonItem = nil
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return tweets!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.user = user
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.userTimeline(screenName: (user?.screenName)!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 140
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print(error)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetDetailsFromProfile" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let readTweetViewController = segue.destination as! ReadTweetViewController
            readTweetViewController.tweet = tweet
        }
    }
    

}
