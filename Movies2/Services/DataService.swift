import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID
import Firebase
let DB_BASE = Database.database().reference()

class DataService{
    
    static let instance = DataService()
    
    var REF_BASE = DB_BASE
    var movies: [Movie] = []
    
    //commenting this as we dont need it
    //var searches: [SearchData] = []
    
    
    func writeToFirebase(movie: Movie){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()
        
        let values = ["movieTitle" : movie.movieTitle!, "id" : String(movie.id!), "voteAverage" : String(movie.voteAverage!), "overview" : movie.overview!, "releaseDate" : movie.releaseDate!, "poster" : movie.poster!, "firebaseId" : idString] as [String: Any]
        
        ref.child("Users").child((Auth.auth().currentUser?.uid)!).child(idString).setValue(values)
        
        print("Wrote to firebase correctly")
    }
    
    func signInOrRegister(completion: @escaping CompletionHandler, email: String, password: String, signInOrNot : Bool){
        if(signInOrNot){
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    completion(false)
                }
                else{
                    completion(true)
                }
            })
        } else{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    completion(false)
                }
                else{
                    completion(true)
                }
            })
        }
    }
    
    
    
    
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
    
    func  getMovieList(handler: @escaping (_ movieArray: [Movie]) -> ()){
        
        var movieArray: [Movie] = []
        
        REF_BASE.child("Users").observe(.value) { (usersSnapshot) in
            
             guard let usersSnapshot = usersSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in usersSnapshot{
                if user.key == Auth.auth().currentUser?.uid{
                    guard let innerSnapshot = user.children.allObjects as? [DataSnapshot] else { return }
                    for item in innerSnapshot{
                        let id = 0
                        let movieTitle = item.childSnapshot(forPath: "movieTitle").value as! String
                        let overview = item.childSnapshot(forPath: "overview").value as! String
                        let poster = item.childSnapshot(forPath: "poster").value as! String
                        let releaseDate = item.childSnapshot(forPath: "releaseDate").value as! String
                        let voteAverage = item.childSnapshot(forPath: "voteAverage").value as! String
                        let movie = Movie(movieTitle: movieTitle, id: id, voteAverage: Double(voteAverage)!, overview: overview, releaseDate: releaseDate, poster: poster)
                        movieArray.append(movie)
                    }
                }
                    
                
            }
            handler(movieArray)
        }
        
    }
    
    
}
