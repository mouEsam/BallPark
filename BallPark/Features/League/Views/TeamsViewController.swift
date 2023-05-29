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

class TeamsViewController: UIViewController, WithArgs, AnyStoryboardView, WithLoaderView {
    private static let teamCellId = "teamCell"
    typealias Args = LeagueIdentity
    
    private var viewModel: TeamsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private var teams: [Team] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func inject(_ container: Container) {
        let model = TeamsModel(remoteService: container.require(TeamsRemoteService.self),
                               teamsDatabase: container.require((any AnyTeamDatabase).self),
                               leagueDatabase: container.require((any AnyLeagueDatabase).self),
                               reachability: container.resolve(Reachability.self))
        viewModel = TeamsViewModel(leagueIdentity: args,
                                   model: model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.loadLeagues()
    }
    
    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.$uiState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                    case .loading:
                        self.showLoader()
                    case .loaded(data: let data):
                        self.hideLoader()
                        self.setData(data.data)
                    case .error(error: let error):
                        self.hideLoader()
                        print(error)
                    default:
                        break
                }
            }.store(in: &cancellables)
    }
    
    
    
}

extension TeamsViewController: UICollectionViewDataSource {
    func setData(_ data: [Team]) {
        teams = data
        collectionView.reloadData()
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
        cell.backgroundColor = .blue
        
        let imageV = cell.viewWithTag(1) as! UIImageView
        let nameLbl = cell.viewWithTag(2) as! UILabel
        
        nameLbl.text = team.name
        return cell
    }
}

extension TeamsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let team = teams[indexPath.row]
        if let teamIdentity = team.identity {
            let vc = instantiate(TeamViewController.self, args: teamIdentity)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TeamsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = height - 20
        return CGSize(width: width, height: height)
    }
}
