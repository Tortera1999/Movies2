//
//  SearchTableViewCell.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    func configureCell(searchData: SearchData){
        movieImage.af_setImage(withURL: URL(string: searchData.movieImage!)!)
        movieTitle.text = searchData.movieTitle
        releaseLabel.text = searchData.releaseLabel
    }

    
}
