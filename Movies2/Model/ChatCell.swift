//
//  ChatCell.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 8/6/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tvLeadingconstraint: NSLayoutConstraint!
    @IBOutlet weak var tvTrailingconstraint: NSLayoutConstraint!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(content: String){
        textView.text = content
    }

}
