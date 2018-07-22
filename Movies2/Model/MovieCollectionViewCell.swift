//
//  MovieCollectionViewCell.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/22/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterPic: UIImageView!
    
    var movie: Movie!{
        didSet{
            //print("Here")
            //moviePosterPic.image = movie.poster!
            moviePosterPic.af_setImage(withURL: URL(string: movie.poster!)!)
        }
    }
}
