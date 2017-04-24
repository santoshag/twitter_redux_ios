

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var profileBackgroundUrl: URL?
    var profileBackgroundColor: String?
    var profileUseBackgroundImage: Bool?
    var tagline: String?
    var dictionary: NSDictionary?
    var location: String?
    var url: String?
    var numberTweets: Int?
    var numberFollowing: Int?
    var numberFollowers: Int?
    var following: Bool?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        var profileUrlString = dictionary["profile_image_url_https"] as? String
        profileUrlString = profileUrlString?.replacingOccurrences(of: "_normal", with: "")
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        var profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        profileBackgroundUrlString = profileBackgroundUrlString?.replacingOccurrences(of: "_normal", with: "")
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            profileBackgroundUrl = URL(string: profileBackgroundUrlString)
        }
        
        profileBackgroundColor = dictionary["profile_background_color"] as? String
        profileUseBackgroundImage = dictionary["profile_use_background_image"] as? Bool
        tagline = dictionary["description"] as? String
        location = dictionary["location"] as? String
        url = dictionary["url"] as? String
        numberTweets = dictionary["statuses_count"] as? Int
        numberFollowing = dictionary["friends_count"] as? Int
        numberFollowers = dictionary["followers_count"] as? Int
        following = dictionary["following"] as? Bool
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        
        set (user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
