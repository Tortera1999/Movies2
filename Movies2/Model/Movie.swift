//
//  Movie.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/22/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation
import UIKit

class Movie{
    var movieTitle: String?
    var id: Int?
    var voteAverage: Double?
    var overview: String?
    var releaseDate: String?
    var poster: String?
    var user: String?
    
    init(movieTitle: String, id: Int, voteAverage: Double, overview: String, releaseDate: String, poster: String, user: String?){
        self.movieTitle = movieTitle
        self.id = id
        self.voteAverage = voteAverage
        self.overview = overview
        self.releaseDate = releaseDate
        self.poster = poster
        self.user = user
    }
    
    func toString(){
        print(self.movieTitle!)
    }
}
