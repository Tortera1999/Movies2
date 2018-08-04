//
//  GroupTableViewCell.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
