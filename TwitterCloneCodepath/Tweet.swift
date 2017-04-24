
import UIKit

class Tweet: NSObject {
    var id: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var favorited: Bool?
    var retweeted: Bool?
    var userImageUrl: URL?
    var userName: String?
    var userHandle: String?
    var retweeterName: String?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
        let userDictionary = dictionary["user"] as? NSDictionary
        var imageURLString = ""
        
        if dictionary["retweeted_status"] == nil {
            text = dictionary["text"] as? String
            userName = userDictionary?["name"] as? String
            userHandle = userDictionary?["screen_name"] as? String
            imageURLString = userDictionary?["profile_image_url_https"] as! String
        } else {
            let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
            text = retweetedStatus?["text"] as? String
            let retweetUserDictionary = retweetedStatus?["user"] as? NSDictionary
            userName = retweetUserDictionary?["name"] as? String
            userHandle = retweetUserDictionary?["screen_name"] as? String
            imageURLString = retweetUserDictionary?["profile_image_url_https"] as! String
            retweeterName = userDictionary?["name"] as? String
        }
        
        if imageURLString != "" {
            userImageUrl = URL(string: imageURLString)!
        } else {
            userImageUrl = nil
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
