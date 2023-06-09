//
//  SportsViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import UIKit
import Swinject

private let reuseIdentifier = "sportCell"

class SportsViewController: UICollectionViewController, AnyStoryboardView {
    
    private let sports = [SportType.football,
                          SportType.basketball,
                          SportType.tennis,
                          SportType.cricket]
    
    lazy var layout = collectionViewLayout as! UICollectionViewFlowLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle(self)
        tabBarController?.delegate = self
        
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 10,
                                           bottom: collectionView.safeAreaInsets.bottom,
                                           right: 10)
//        collectionView.contentInset.top = collectionView.safeAreaInsets.top
//        collectionView.contentInset.bottom = collectionView.safeAreaInsets.bottom
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        let sportType = sports[indexPath.item]
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        imageView.image = UIImage(named: sportType.uiImage)
        label.text = sportType.rawValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = instantiate(LeaguesViewController.self, args: sports[indexPath.item]);
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SportsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let insets = layout.sectionInset + collectionView.contentInset
        let width = collectionView.bounds.width - layout.minimumInteritemSpacing - insets.left - insets.right
        let height = collectionView.bounds.height - layout.minimumLineSpacing - insets.top - insets.bottom
        
        return CGSize(width: width/2, height: height/2)
    }
}

extension SportsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setupNavigationTitle(viewController)
    }
    
    func setupNavigationTitle(_ viewController: UIViewController) {
        tabBarController?.navigationItem.title = viewController.navigationItem.title
    }
}
