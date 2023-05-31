//
//  LeagueTableViewCell.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit
import Kingfisher

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    
    func setLeague(_ league: League, imageLoader: (any AnyImageLoader)) {
        leagueLabel.text = league.name
        
        let placeholder = UIImage(named: league.sportType?.uiImage ?? "football")
        imageLoader.load(imageUrl: league.logo, into: leagueImage, placeholder: placeholder)
    }
}
