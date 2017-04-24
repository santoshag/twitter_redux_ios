
import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    let user = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.setImageWith((user?.profileUrl!)!)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        userNameLabel.text = user?.name
        userHandleLabel.text = "@\((user?.screenName)!)"
        tweetTextView.text = "What's happening?"
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: AnyObject) {
        let statusString = tweetTextView.text as String
        TwitterClient.sharedInstance?.statusUpdate(status: statusString, success: {
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
//        if (tweetTextView.text != "") {
//            var tweetParams = NSDictionary()
//            tweetParams["text"] = tweetTextView.text as AnyObject!
//            tweetParams["timestamp"] = Date() as AnyObject!
//            tweetParams["userImageUrl"] = (user?.profileUrl!)! as AnyObject!
//            
//            
//            var tweet = Tweet()
//            var selectedCategories = [String]()
//            
//            
//            delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tweetTextView.textColor == UIColor.lightGray {
            tweetTextView.text = nil
            tweetTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGray
        }
    }

}
