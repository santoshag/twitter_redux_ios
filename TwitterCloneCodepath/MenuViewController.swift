import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var homeNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userContainerView: UIView!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    let user = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewControllers.append(homeNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = homeNavigationController
        
        userImageView.setImageWith((user?.profileUrl!)!)
        userImageView.layer.cornerRadius = 5
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.clipsToBounds = true
        
        userNameLabel.text = user?.name
        userHandleLabel.text = "@\((user?.screenName)!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let titles = ["home", "profile", "mentions"]
        
        let image = UIImage(named: "\(titles[indexPath.row]).png")
        cell.optionImageView.image = image
        cell.optionImageView.image = cell.optionImageView.image!.withRenderingMode(.alwaysTemplate)
        cell.optionImageView.tintColor = UIColor.white
        cell.optionLabel.text = titles[indexPath.row].capitalized
        
//        cell.contentView.layer.borderColor = UIColor.white.cgColor
//        cell.contentView.layer.borderWidth = 1.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
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
