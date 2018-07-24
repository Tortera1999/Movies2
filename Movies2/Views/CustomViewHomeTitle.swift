//
//  CustomViewHomeTitle.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/24/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class CustomViewHomeTitle: UIView {

    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.85
        self.layer.shadowRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.layer.cornerRadius = 5
        super.awakeFromNib()
    }
}
