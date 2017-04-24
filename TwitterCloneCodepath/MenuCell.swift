

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let borderLayer = CALayer()
//        let lineHeight:CGFloat = 0.5
//        borderLayer.frame = CGRect(x: 0, y: self.frame.height - lineHeight , width: UIScreen.main.bounds.width, height: lineHeight)
//        borderLayer.backgroundColor = UIColor.white.cgColor
//        self.layer.addSublayer(borderLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
