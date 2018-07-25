import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class DataService{
    
    static let instance = DataService()
    
    var movies: [Movie] = []
    
    //commenting this as we dont need it
    //var searches: [SearchData] = []
    
    
    //added one parameter here
    func downloadDataBasedOnGenre(completion: @escaping CompletionHandler, genreID: Int, keyword: String){
        
        //creating url variable
        var url : URL = URL(string: "www.google.com")!
        
        
        //deciding for what:
        if(genreID == -1){
            //Use if search tab is active
            let textNew = keyword.replacingOccurrences(of: " ", with: "%20")
            url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=50670e9c1d4037bc568a8aa9969c14f4&query=\(textNew)&page=1&language=en&include_adult=true")!
        } else{
            //Use if table view of genre movies
            url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=50670e9c1d4037bc568a8aa9969c14f4&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_genres=\(genreID)&region=US")!
        }
        
        
        
        Alamofire.request(url).responseJSON { (response) in
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
                            let imgUrl = "https://image.tmdb.org/t/p/w500\(item["poster_path"].stringValue)"
                            
                            
                            let movie = Movie(movieTitle: title, id: id, voteAverage: voteAverage, overview: overview, releaseDate: releaseDate, poster: imgUrl)
                            self.movies.append(movie)
                            NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
                            
                            
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
    
    
    
    
    //Dont need this only
    
    
//    func getKeywordRelatedMovieData(text: String, completion: @escaping CompletionHandler){
//
//
//
//        let textNew = text.replacingOccurrences(of: " ", with: "%20")
//
//        var url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=50670e9c1d4037bc568a8aa9969c14f4&query=\(textNew)&page=1&language=en&include_adult=true")
//
//
//
//        print(" \n URL: \(url)  \n text: \(textNew)")
//
//        Alamofire.request(url!).responseJSON { (response) in
//            if(response.result.error == nil){
//                guard let data = response.data else { return }
//                do{
//                    let json = try JSON(data: data)
//
//                    if let array = json["results"].array{
//
//                        self.searches = []
//
//                        for item in array{
//                            let title = item["title"].stringValue
//                            let releaseDate = item["release_date"].stringValue
//                            let imgUrl = "https://image.tmdb.org/t/p/w500\(item["poster_path"].stringValue)"
//
//
//                            let search = SearchData(movieImage: imgUrl, movieTitle: title, releaseLabel: releaseDate)
//                            self.searches.append(search)
//                            NotificationCenter.default.post(name: Notification.Name("SearchUpdated"), object: nil)
//
//
//                        }
//                    }
//                }catch{
//
//                }
//
//                completion(true)
//            }else{
//                debugPrint(response.result.error)
//                completion(false)
//
//            }
//        }
//
//    }
    
    
}
