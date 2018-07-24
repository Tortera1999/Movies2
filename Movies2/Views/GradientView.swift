//
//  GradientView.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/24/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class GradientView: UIView {

    @IBInspectable var topColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor = #colorLiteral(red: 0.1294117647, green: 0.1333333333, blue: 0.1607843137, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
