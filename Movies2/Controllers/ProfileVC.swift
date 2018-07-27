//
//  ProfileVC.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/27/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var myListTableView: UITableView!
    
    var moviesArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myListTableView.delegate = self
        myListTableView.dataSource = self
        DataService.instance.getMovieList { (returnedMovieArray) in
            self.moviesArray = returnedMovieArray
            self.myListTableView.reloadData()
        }
        userName.text = Auth.auth().currentUser?.email

       
    }
    
    //TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = myListTableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell{
            cell.configureCell(movieImageUrl: moviesArray[indexPath.row].poster!, movieTitle: moviesArray[indexPath.row].movieTitle!, releaseDate: moviesArray[indexPath.row].releaseDate!)
            return cell
        }
        return ListCell()
    }
    


  

}
