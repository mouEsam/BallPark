//
//  LeagueTableViewCell.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit
import Kingfisher

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    
    func setTeam(_ team: Team, imageLoader: (any AnyImageLoader)) {
        teamLabel.text = team.name
        
        let placeholder = UIImage(named: team.sportType?.uiImage ?? "football")
        imageLoader.load(imageUrl: team.logo, into: teamImage, placeholder: placeholder)
    }
}
