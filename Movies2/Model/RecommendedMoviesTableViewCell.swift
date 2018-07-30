//
//  RecommendedMoviesTableViewCell.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RecommendedMoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var posterPic: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var recommendedBy: UILabel!
    
    var movie: Movie!{
        didSet{
            posterPic.af_setImage(withURL: URL(string: movie.poster!)!)
            titleLabel.text = movie.movieTitle!
            releaseDateLabel.text = movie.releaseDate!
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
