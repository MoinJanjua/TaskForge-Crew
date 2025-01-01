//
//  PMTableViewCell.swift
//  TaskForge Crew
//
//  Created by Maaz on 24/12/2024.
//

import UIKit

class PMTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var JoinDatelabel: UILabel!
    
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
        
//        makeImageViewCircular(imageView: ImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
