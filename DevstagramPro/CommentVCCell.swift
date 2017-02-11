//
//  CommentVCCell.swift
//  DevstagramPro
//
//  Created by Harry Ng on 11/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit

class CommentVCCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
