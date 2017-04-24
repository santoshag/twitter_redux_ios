

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    @IBOutlet weak var leftCellView: UIView!
    @IBOutlet weak var centerCellView: UIView!
    @IBOutlet weak var rightCellView: UIView!
    @IBOutlet weak var noTweets: UILabel!
    @IBOutlet weak var noFollowing: UILabel!
    @IBOutlet weak var noFollowers: UILabel!

    var user: User! {
        didSet {
            userImageView.setImageWith((user?.profileUrl!)!)
            userNameLabel.text = user?.name
            userHandleLabel.text = "@\((user?.screenName)!)"
            
            let backgroundImageData = try! Data(contentsOf: (user?.profileBackgroundUrl!)!)
            UIGraphicsBeginImageContext(backgroundImageView.frame.size)
            UIImage(data: backgroundImageData)?.draw(in: backgroundImageView.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            backgroundImageView.backgroundColor = UIColor(patternImage: image)
            locationLabel.text = user?.location
            let numberTweets = String((user?.numberTweets)!)
            let numberFollowing = String((user?.numberFollowing)!)
            let numberFollowers = String((user?.numberFollowers)!)
            noTweets.text = numberTweets
            noFollowing.text = numberFollowing
            noFollowers.text = numberFollowers
            userDescriptionLabel.text = user?.tagline
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 5
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.clipsToBounds = true
        locationImageView.image = locationImageView.image!.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor.white
        
        leftCellView.layer.borderWidth = 1
        leftCellView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        centerCellView.layer.borderWidth = 1
        centerCellView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        rightCellView.layer.borderWidth = 1
        rightCellView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
