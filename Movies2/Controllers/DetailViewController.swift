//
//  DetailViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var backdropPic: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var backView: UIView!
    
    
    
     var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = backView.frame.width/2 - 10
        backView.clipsToBounds = true
      
        backdropPic.af_setImage(withURL: URL(string: movie.poster!)!)
        titleLabel.text = movie.movieTitle!
       

        overviewTextView.text = movie.overview! + " Voter's average give this movie a \(Int(movie.voteAverage!))/10!"
        
        overviewTextView.isEditable = false
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didWatch(_ sender: Any) {
        

        
        DataService.instance.getMoviesWatched(movieTitle: self.titleLabel.text!) { (failure) in
            print(failure)
            if(!failure){
                print("shit")
                DataService.instance.writeToFirebase(movie: self.movie)
            }
            
            
            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    

}
