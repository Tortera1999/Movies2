//
//  SearchData.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation

struct SearchData{
    var movieImage: String?
    var movieTitle: String?
    var releaseLabel: String?
    
    init(movieImage: String,movieTitle: String, releaseLabel: String ) {
        self.movieImage = movieImage
        self.movieTitle = movieTitle
        self.releaseLabel = releaseLabel
    }
}
