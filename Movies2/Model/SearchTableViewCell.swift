//
//  SearchTableViewCell.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    var movie: Movie!{
        didSet{
            //didset is an inbuilt method which will set the attributes to the imageview, label etc
            
            //Setting to movie attributes
            movieImage.af_setImage(withURL: URL(string: movie.poster!)!)
            movieTitle.text = movie.movieTitle!
            releaseLabel.text = movie.releaseDate!
            
        }
    }
    
    //dont need it, see up how i will do
//    func configureCell(searchData: SearchData){
//        movieImage.af_setImage(withURL: URL(string: searchData.movieImage!)!)
//        movieTitle.text = searchData.movieTitle
//        releaseLabel.text = searchData.releaseLabel
//    }

    
}
