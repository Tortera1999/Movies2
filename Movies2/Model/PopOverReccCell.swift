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
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected){
            if(hide){
                hide = false
                checkImage.isHidden = false
//                if(!DataService.instance.recommendArray.contains(emailLabel.text!)){
//                    DataService.instance.recommendArray.append(emailLabel.text!)
//                }
            }
            else{
                hide = true
                checkImage.isHidden = true
//                var count = 0
//                for item in DataService.instance.recommendArray{
//                    if(item == emailLabel.text!){
//                        DataService.instance.recommendArray.remove(at: count)
//                    }
//                    count += 1
//                }
               
            }
            //print(DataService.instance.recommendArray)
        }

      
    }
    
    func cellConfigure(email: String){
        self.emailLabel.text = email
    }
    
}
