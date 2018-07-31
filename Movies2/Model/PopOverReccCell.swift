//
//  PopOverReccCell.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class PopOverReccCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    //variables
    var hide: Bool = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected){
            if(hide){
                hide = false
                checkImage.isHidden = false
            }
            else{
                hide = true
                checkImage.isHidden = true
               
            }
            
        }

      
    }
    
    func cellConfigure(email: String, isSelected: Bool){
        
        self.emailLabel.text = email
        
        if(isSelected){
            checkImage.isHidden = false
        } else{
            checkImage.isHidden = true
        }
    }
    
}
