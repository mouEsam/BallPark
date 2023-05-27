//
//  StadiumImageView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit

class StadiumImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
        clipsToBounds = true
    }

}
