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
    var recommendArray: [String] = []
    var recommendArrayUID : [String] = []
    var chosenMovie: Movie?
    
    func writeRecommendationsToFirebase(recommendArray: [String], movie: Movie){
        
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()
        
        for item in recommendArrayUID{
           
            var givenBY: String?
            
            convertUIDtoEmail(uid: (Auth.auth().currentUser?.uid)!) { (result) in
                
                givenBY = result
                
                let values = ["movieTitle" : movie.movieTitle!, "id" : String(movie.id!), "voteAverage" : String(movie.voteAverage!), "overview" : movie.overview!, "releaseDate" : movie.releaseDate!, "poster" : movie.poster!, "firebaseId" : idString, "GivenBy": givenBY!] as [String: Any]
                self.REF_BASE.child("Users").child(item).child("Recommendations").child(idString).setValue(values)
            }
           
        }
        
        
    }
    
    func convertUIDtoEmail(uid: String, handler: @escaping (_ email: String)->()){
        
        REF_BASE.child("Users").observe(.value) { (userSnapshot) in
            
             guard let userSnapshot = userSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in userSnapshot{
                if user.key == uid{
                    
                    guard let innerSnapshot = user.childSnapshot(forPath: "Info").childSnapshot(forPath: "email").value as? String else {
                        return
                    }
                    
                    handler(innerSnapshot)
                    
                }
            }
        }
    }
    
    func writeToFirebase(movie: Movie){
        
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()
        
        let values = ["movieTitle" : movie.movieTitle!, "id" : String(movie.id!), "voteAverage" : String(movie.voteAverage!), "overview" : movie.overview!, "releaseDate" : movie.releaseDate!, "poster" : movie.poster!, "firebaseId" : idString] as [String: Any]
        
        REF_BASE.child("Users").child((Auth.auth().currentUser?.uid)!).child("Watched").child(idString).setValue(values)
        
    }
    
    func addFriends(email : String, uid : String){
        let value = ["email" : email, "uid" : uid]
        REF_BASE.child("Users").child((Auth.auth().currentUser?.uid)!).child("Friends").child(uid).setValue(value)
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
                    let val = ["email" : email, "uid" : (user?.uid)!]
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Info").setValue(val)
                    completion(true)
                }
            })
        }
    }
    
    
    
    
    
    func downloadDataBasedOnGenre(completion: @escaping ([Movie]?) -> (), genreID: Int, keyword: String){
        
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
                        
                        var downloadedMovies: [Movie] = []
                        
                        for item in array{
                            let title = item["title"].stringValue
                            let id = item["id"].intValue
                            let voteAverage = item["vote_average"].doubleValue
                            let overview = item["overview"].stringValue
                            let releaseDate = item["release_date"].stringValue
                            var correctReleaseDate = ""
                            if(releaseDate == ""){
                                
                            } else{
                                correctReleaseDate = self.getCorrectDate(input: "yyyy-MM-dd", output: "dd MMMM yyyy", releaseDate: releaseDate)
                            }
                            
                            let imgUrl = "https://image.tmdb.org/t/p/w500\(item["poster_path"].stringValue)"
                            
                            
                            let movie = Movie(movieTitle: title, id: id, voteAverage: voteAverage, overview: overview, releaseDate: correctReleaseDate, poster: imgUrl, user: nil)
                            downloadedMovies.append(movie)
                            NotificationCenter.default.post(name: Notification.Name("notifUserDataChanged"), object: nil)
                            
                            
                        }
                        completion(downloadedMovies)

                    }
                }catch{
                    
                }
                
            }else{
                debugPrint(response.result.error)
                completion(nil)
                
            }
        }
    }
    
    func getCorrectDate(input: String, output: String, releaseDate: String) -> String{
        var s = ""
        if(releaseDate != nil){
            s = (releaseDate.toDateString(inputFormat: input, outputFormat: output)!)
        }
        
        return s
    }
    
    func getEmails(handler: @escaping (_ emailArray: [String], _ uidArray: [String]) -> ()){
        
        
        var emailArray: [String] = []
        var uidArray: [String] = []
        
        
        REF_BASE.child("Users").observe(.value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in usersSnapshot{
                guard let innerSnapshot = user.childSnapshot(forPath: "Info").childSnapshot(forPath: "email").value as? String else {
                    return
                }
                guard let innerSnapshot2 = user.childSnapshot(forPath: "Info").childSnapshot(forPath: "uid").value as? String else {
                    return
                }
                emailArray.append(innerSnapshot)
                uidArray.append(innerSnapshot2)
            }
            handler(emailArray,uidArray)
            emailArray = []
            uidArray = []
        }
    }
    
    func getRecommendationsGivenToTheUser(handler: @escaping (_ movieArray: [Movie]) -> ()){
        
        var movieArray: [Movie] = []
        
        REF_BASE.child("Users").observe(.value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in usersSnapshot{
                if user.key == Auth.auth().currentUser?.uid{
                    
                    guard let innerSnapshot = user.childSnapshot(forPath: "Recommendations").children.allObjects as? [DataSnapshot] else { return }
                    
                    
                    for item in innerSnapshot{
                       
                        let id = 0
                        let movieTitle = item.childSnapshot(forPath: "movieTitle").value as! String
                        let overview = item.childSnapshot(forPath: "overview").value as! String
                        let poster = item.childSnapshot(forPath: "poster").value as! String
                        let releaseDate = item.childSnapshot(forPath: "releaseDate").value as! String
                        let voteAverage = item.childSnapshot(forPath: "voteAverage").value as! String
                        let movie = Movie(movieTitle: movieTitle, id: id, voteAverage: Double(voteAverage)!, overview: overview, releaseDate: releaseDate, poster: poster, user: (item.childSnapshot(forPath: "GivenBy").value as! String))
                        movieArray.append(movie)
                    }
                }
            }
            
           
            
            handler(movieArray)
            movieArray = []
        }
    }
    
    func getRecommendationsGivenByUser(handler: @escaping (_ movieArray: [Movie]) -> ()){
        
        var movieArray: [Movie] = []
        
        REF_BASE.child("Users").observe(.value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in usersSnapshot{
                if user.key != Auth.auth().currentUser?.uid{
                    
                     guard let innerSnapshot = user.childSnapshot(forPath: "Recommendations").children.allObjects as? [DataSnapshot] else { return }
                    
                    for item in innerSnapshot{
                        if(item.childSnapshot(forPath: "GivenBy").value as? String == Auth.auth().currentUser?.email){
                            let id = 0
                            let movieTitle = item.childSnapshot(forPath: "movieTitle").value as! String
                            let overview = item.childSnapshot(forPath: "overview").value as! String
                            let poster = item.childSnapshot(forPath: "poster").value as! String
                            let releaseDate = item.childSnapshot(forPath: "releaseDate").value as! String
                            let voteAverage = item.childSnapshot(forPath: "voteAverage").value as! String
                            
                                let user12 = user.childSnapshot(forPath: "Info").childSnapshot(forPath: "email").value as? String
                                let movie = Movie(movieTitle: movieTitle, id: id, voteAverage: Double(voteAverage)!, overview: overview, releaseDate: releaseDate, poster: poster, user: user12!)
                                movieArray.append(movie)
                            
                            
                        }
                    }
                }
            }
//            
//            print("\n\n \(movieArray) \nin the dataService\n ")
            handler(movieArray)
            
            movieArray = []
        
    }
    }
    
    func  getMovieList(handler: @escaping (_ movieArray: [Movie]) -> ()){
        
        var movieArray: [Movie] = []
        
        REF_BASE.child("Users").observe(.value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in usersSnapshot{
                if user.key == Auth.auth().currentUser?.uid{
                    
                    guard let innerSnapshot = user.childSnapshot(forPath: "Watched").children.allObjects as? [DataSnapshot] else { return }

                    for item in innerSnapshot{
                        //print(item)
                        let id = 0
                        let movieTitle = item.childSnapshot(forPath: "movieTitle").value as! String
                        let overview = item.childSnapshot(forPath: "overview").value as! String
                        let poster = item.childSnapshot(forPath: "poster").value as! String
                        let releaseDate = item.childSnapshot(forPath: "releaseDate").value as! String
                       
                        let voteAverage = item.childSnapshot(forPath: "voteAverage").value as! String
                        let movie = Movie(movieTitle: movieTitle, id: id, voteAverage: Double(voteAverage)!, overview: overview, releaseDate: releaseDate, poster: poster, user: nil)
                        movieArray.append(movie)
                    }
                }
            }
            handler(movieArray)
            movieArray = []
        }
        
    }
    
    func getFriendsOfCurrUser(handler: @escaping (_ emailArray: [String], _ emailArrayUID: [String]) -> ()){
        
        var emailArray: [String] = []
        var emailArrayUID: [String] = []
        
         REF_BASE.child("Users").observe(.value) { (usersSnapshot) in
        
            guard let usersSnapshot = usersSnapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for user in usersSnapshot{
                if user.key == Auth.auth().currentUser?.uid{
                    guard let innerSnapshot = user.childSnapshot(forPath: "Friends").children.allObjects as? [DataSnapshot] else { return }
                    
                    for item in innerSnapshot{
                        emailArray.append(item.childSnapshot(forPath: "email").value as! String)
                        emailArrayUID.append(item.childSnapshot(forPath: "uid").value as! String)
                    }

                }
            }
            
            handler(emailArray, emailArrayUID)
            emailArray = []
            emailArrayUID = []
        }
    }
    
    
}


extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}
