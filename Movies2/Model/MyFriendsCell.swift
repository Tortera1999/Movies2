//
//  MyFriendsCell.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/28/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {
    

    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(email: String){
       
        
        emailLabel.text = email
    }

}
