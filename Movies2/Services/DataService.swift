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

class DataService{
    
    static let instance = DataService()
    
    var movieTitles: [String] = []
    
    
    
    func downloadTitlesBasedOnGenre(completion: @escaping CompletionHandler, genreID: Int){
        
        self.movieTitles = []
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=50670e9c1d4037bc568a8aa9969c14f4&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_genres=\(genreID)")
        
        Alamofire.request(url!).responseJSON { (response) in
            if(response.result.error == nil){
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    
                    if let array = json["results"].array{
                        for item in array{
                            self.movieTitles.append("\(item["original_title"].stringValue)")
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
