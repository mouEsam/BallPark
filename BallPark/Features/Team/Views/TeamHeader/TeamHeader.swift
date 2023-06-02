//
//  TeamHeader.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import UIKit

class TeamHeader: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if let view = Bundle(for: Self.self)
            .loadNibNamed(String(describing: Self.self),
                          owner: self,
                          options: nil)?.first as? UIView {
            addSubview(view)
            view.frame = bounds
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }

    func setTeam(_ team: Team, imageLoader: any AnyImageLoader) {
        title.text = team.name
        subTitle.text = team.league?.name
        imageLoader.load(imageUrl: team.logo, into: imageView, placeholder: team.sportType.flatMap { UIImage(named: $0.uiImage) })
        
    }
}
