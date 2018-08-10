//
//  SearchForGroupTableViewCell.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/8/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class SearchForGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var GroupNameLabel: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
