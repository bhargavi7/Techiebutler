//
//  DetailCell.swift
//  APIParsing
//
//  Created by Bhargavi on 27/04/24.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet var lblPostId : UILabel!
    @IBOutlet var lblId : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblBody : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
