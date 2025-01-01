//
//  UserTableViewCell.swift
//  POS
//
//  Created by Maaz on 09/10/2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var JoinDatelabel: UILabel!
    @IBOutlet weak var SaleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 12
        
        // Set up shadow properties
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4.0
        contentView.layer.masksToBounds = false
        
        // Set background opacity
        contentView.alpha = 1.5 // Adjust opacity as needed
        
        makeImageViewCircular(imageView: ImageView)    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func makeImageViewCircular(imageView: UIImageView) {
           // Ensure the UIImageView is square
           imageView.layer.cornerRadius = imageView.frame.size.width / 2
           imageView.clipsToBounds = true
       }

}
