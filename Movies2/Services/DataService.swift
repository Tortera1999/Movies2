//
//  DataService.swift
//  MovieFinder
//
//  Created by Sehajbir Randhawa on 7/22/18.
//  Copyright © 2018 Sehajbir-Nikhil. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class DataService{
    
    static let instance = DataService()
    
    var movies: [Movie] = []
    
    
    
    func downloadDataBasedOnGenre(completion: @escaping CompletionHandler, genreID: Int){
        
     
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=50670e9c1d4037bc568a8aa9969c14f4&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_genres=\(genreID)&region=US")
        
        Alamofire.request(url!).responseJSON { (response) in
            if(response.result.error == nil){
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    
                    if let array = json["results"].array{
                        
                        self.movies = []
                        
                        for item in array{
                            let title = item["title"].stringValue
                            let id = item["id"].intValue
                            let voteAverage = item["vote_average"].doubleValue
                            let overview = item["overview"].stringValue
                            let releaseDate = item["release_date"].stringValue
                            var imgUrl = URL(string: "https://image.tmdb.org/t/p/w500\(item["poster_path"].stringValue)")
                            var img: UIImage?
                            //Getting image of url using AlamofireImage
                            Alamofire.request(imgUrl!).responseImage(completionHandler: { (response) in
                               
                                img = response.result.value
                            })
                            
                            
                            let movie = Movie(movieTitle: title, id: id, voteAverage: voteAverage, overview: overview, releaseDate: releaseDate, poster: img!)
                            self.movies.append(movie)
                            
                            
                        }
                        
                    }
                }catch{
                    
                }
                
                completion(true)
            }else{
                debugPrint(response.result.error)
                completion(false)
                
            }
        }
        
    }
    
    
}
