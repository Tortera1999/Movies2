//
//  RecommendationsViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    //Outlets
 
    @IBOutlet weak var recommendedMoviesTB: UITableView!
    
    var recommendedMovies : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendedMoviesTB.delegate = self
        recommendedMoviesTB.dataSource = self

        DataService.instance.getRecommendationsGivenOfTheUser { (returnedArray) in
            self.recommendedMovies = returnedArray
            self.recommendedMoviesTB.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recTBC", for: indexPath) as! RecommendedMoviesTableViewCell
        cell.movie = recommendedMovies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

  
}
