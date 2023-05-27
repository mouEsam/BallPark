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
    
    func setLeague(_ league: League) {
        leagueLabel.text = league.leagueName
        
        let placeholder = UIImage(named: league.sportType?.uiImage ?? "football")
        if let leagueLogo = league.leagueLogo,
           let imageUrl = URL(string: leagueLogo) {
            KF.url(imageUrl)
              .placeholder(placeholder)
              .loadDiskFileSynchronously()
              .cacheMemoryOnly()
              .fade(duration: 0.25)
              .set(to: leagueImage)
        } else {
            leagueImage.image = placeholder
        }
        
    }
}
