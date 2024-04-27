//
//  CustomListCell.swift
//  APIParsing
//
//  Created by Bhargavi on 27/04/24.
//

import UIKit

class CustomListCell: UITableViewCell {
    
    @IBOutlet var lblId : UILabel!
    @IBOutlet var lblTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
