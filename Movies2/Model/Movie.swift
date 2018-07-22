//
//  Movie.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/22/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation

class Movie{
    var movieTitle: String?
    var id: Int?
    var voteAverage: Double?
    var overview: String?
    var releaseDate: String?
    
    init(movieTitle: String, id: Int, voteAverage: Double, overview: String, releaseDate: String){
        self.movieTitle = movieTitle
        self.id = id
        self.voteAverage = voteAverage
        self.overview = overview
        self.releaseDate = releaseDate
    }
}
