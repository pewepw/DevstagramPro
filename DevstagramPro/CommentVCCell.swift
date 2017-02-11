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
    
    // as a observer
    var comment : Comment? {
        didSet {
            updateView()
        }
    }
    
    var user:  User? {
        didSet {
            setUpUserInfo()
        }
    }

    func updateView() {
        commentLbl.text = comment?.commentText
        
    }
    
    func setUpUserInfo() {
        nameLbl.text = user?.username
        if let photoURLString = user?.profileImageURL {
            let photoURL = URL(string: photoURLString)
            avaImg.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLbl.text = ""
        commentLbl.text = ""
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avaImg.image = UIImage(named: "placeholderImg")
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
