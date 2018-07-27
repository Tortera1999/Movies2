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
import SwiftyJSON

class DetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var backdropPic: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    
     var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backdropPic.af_setImage(withURL: URL(string: movie.poster!)!)
        titleLabel.text = movie.movieTitle!
       

        overviewTextView.text = movie.overview! + " Voter's average give this movie a \(Int(movie.voteAverage!))/10!"
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didWatch(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
