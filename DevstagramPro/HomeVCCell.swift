//
//  HomeVCCell.swift
//  DevstagramPro
//
//  Created by Harry Ng on 08/02/2017.
//  Copyright © 2017 Harry Ng. All rights reserved.
//

import UIKit

class HomeVCCell: UITableViewCell {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLbl: UILabel!
    
    // as a observer
    var post : Post? {
        didSet {
            updateNewsFeed()
        }
    }
    
    var videoPost: Post? {
        didSet {
            // func
        }
    }
    
    func updateNewsFeed() {
        nameLbl.text = "Erica"
        captionLbl.text = post?.caption
        
        if let photoURLString = post?.photoURL {
            let photoURL = URL(string: photoURLString)
            postImgView.sd_setImage(with: photoURL)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
