//
//  ListCell.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/27/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(movieImageUrl: String, movieTitle: String, releaseDate: String){
        self.movieImage.af_setImage(withURL: URL(string: movieImageUrl)!)
        self.movieTitleLabel.text = movieTitle
        self.releaseDateLabel.text = releaseDate
    }

}
