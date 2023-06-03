//
//  TeamsViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Combine
import Swinject
import Reachability

class TeamsViewController: UIViewController, WithArgs, AnyStoryboardView, WithLoaderView, WithEmptyView, WithErrorView {
    private static let teamCellId = "teamCell"
    typealias Args = LeagueIdentity
    
    private var imageLoader: (any AnyImageLoader)!
    private var viewModel: (any AnyPlayersViewModel)!
    private var cancellables: Set<AnyCancellable> = []
    
    private var teams: [any AnyPlayer] = []
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func inject(_ container: Container) {
        imageLoader = container.require((any AnyImageLoader).self)
        viewModel = container.require((any AnyTeamsViewModelFactory).self).create(for: args)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.loadPlayers()
    }
    
    private func setupUI() {
        sectionTitle.text = viewModel.sectionTitleKey
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset.left = 10
        collectionView.contentInset.right = 10
        collectionView.contentInset.bottom = 10
        
        viewModel.uiStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                    case .loading:
                        self.showLoader()
                        self.hideEmpty()
                        self.hideError()
                    case .loaded(data: let data):
                        self.hideLoader()
                        self.hideError()
                        self.hideEmpty()
                        self.setData(data.data)
                    case .error(error: let error):
                        self.hideLoader()
                        self.hideError()
                        self.showError(message: error.localizedDescription,
                                       anchorTo: self.collectionView)
                    default:
                        break
                }
            }.store(in: &cancellables)
    }
    
    
    
}

extension TeamsViewController: UICollectionViewDataSource {
    private func setData(_ data: [any AnyPlayer]) {
        teams = data
        collectionView.reloadData()
        if data.isEmpty {
            showEmpty(message: viewModel.emptyMessageKey)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.teamCellId, for: indexPath)
        let team = teams[indexPath.item]
        
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = true
        
        let imageV = cell.viewWithTag(1) as! UIImageView
        let nameLbl = cell.viewWithTag(2) as! UILabel
        
        nameLbl.text = team.name
        
        imageLoader.load(imageUrl: team.logo, into: imageV, placeholder: team.sportType.flatMap { UIImage(named: $0.uiImage) })
        
        return cell
    }
}

extension TeamsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = teams[indexPath.row]
        if let team = item as? Team,
           team.sportType == .football || team.sportType == .tennis,
           let teamIdentity = team.identity {
            let vc = instantiate(TeamViewController.self, args: teamIdentity)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TeamsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset + (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let collectioheight = collectionView.bounds.height - insets.top - insets.bottom
        
        let width = collectioheight - 20
        return CGSize(width: width, height: collectioheight)
    }
}
