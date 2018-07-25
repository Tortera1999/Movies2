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
    @IBOutlet weak var voterAvgLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
     var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backdropPic.af_setImage(withURL: URL(string: movie.poster!)!)
        titleLabel.text = movie.movieTitle!
        voterAvgLabel.text = String(movie.id!)
        releaseDateLabel.text = movie.releaseDate!
        overviewLabel.text = movie.overview!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didWatch(_ sender: Any) {
        
        DataService.instance.writeToFirebase(movie: self.movie)
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
