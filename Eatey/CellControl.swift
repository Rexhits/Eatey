import UIKit

class CellControl: UITableViewCell {
    

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var destPlaceHolder: UILabel!
    @IBOutlet weak var tipPlaceHolder: UILabel!
    @IBOutlet weak var timePlaceHolder: UILabel!
    @IBOutlet weak var foodPlaceHolder: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myImage.layer.cornerRadius = 30.0;
        myImage.layer.masksToBounds = true;
        outerView.layer.cornerRadius = 5.0;
        outerView.layer.masksToBounds = true;
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
