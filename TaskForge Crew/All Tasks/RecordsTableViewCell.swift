//
//  RecordsTableViewCell.swift
//  POS
//
//  Created by Maaz on 10/10/2024.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var NotesTV: UILabel!
    @IBOutlet weak var cornerView: UIView!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
