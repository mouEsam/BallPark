//
//  TeamViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Swinject
import Combine
import Reachability

class TeamViewController: UIViewController, AnyInstantiableView, WithLoaderView, WithEmptyView, WithErrorView {
    typealias Args = TeamIdentity
    
    static let playerCellId = "playerCell"
    static let storyboardId: String = "teamVC"
    
    private var imageLoader: (any AnyImageLoader)!
    private var viewModel: TeamViewModel!
    private var playersViewModel: PlayersViewModel!
    private weak var favouriteButton: UIBarButtonItem!
    private var cancellables: Set<AnyCancellable> = []
    
    private var team: Team? = nil
    private var players: [Player] = []
    
    private weak var headerView: TeamHeader!
    private weak var headerTopConstraint: NSLayoutConstraint!
    private weak var headerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func inject(_ container: Container) {
        imageLoader = container.require((any AnyImageLoader).self)
        viewModel = TeamViewModel(teamIdentity: args,
                                  model: TeamModel(database: container.require((any AnyTeamDatabase).self)),
                                  notificationCenter: container.require(NotificationCenter.self))
        playersViewModel = PlayersViewModel(teamIdentity: args,
                                            model: PlayersModel(remoteService: container.require(PlayersRemoteService.self),
                                                                playersDatabase: container.require((any AnyPlayerDatabase).self),
                                                                teamsDatabase: container.require((any AnyTeamDatabase).self),
                                                                reachability: container.require(Reachability.self)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadTeam()
        playersViewModel.loadPlayers()
    }
    
    private func setupUI() {
        let favouriteButton = UIBarButtonItem(image: nil,
                                              style: .plain,
                                              target: viewModel,
                                              action: #selector(viewModel.toggleFavourite))
        
        navigationItem.rightBarButtonItem = favouriteButton
        self.favouriteButton = favouriteButton
        viewModel.$isFavourite
            .receive(on: DispatchQueue.main)
            .map { isFavourite in
                if isFavourite == true {
                    return UIImage(systemName: "star.fill")
                } else {
                    return UIImage(systemName: "star")
                }
            }.assign(to: \.image, on: favouriteButton)
            .store(in: &cancellables)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.$uiState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                    case .loaded(data: let data):
                        self.setTeamData(data.data)
                    case .error(error: let error):
                        self.showError(message: error.localizedDescription)
                    default:
                        break
                }
            }.store(in: &cancellables)
        
        playersViewModel.$uiState
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
                        print(data.data.count)
                    case .error(error: let error):
                        self.hideLoader()
                        self.hideEmpty()
                        self.showError(message: error.localizedDescription)
                    default:
                        break
                }
            }.store(in: &cancellables)
        
        
        let headerView = TeamHeader(frame: .zero)
        let heigth = CGFloat(260)
        headerView.alpha = 0.0
        collectionView.addSubview(headerView)
        collectionView.contentInset = UIEdgeInsets(top: heigth,
                                                   left: 10,
                                                   bottom: 10,
                                                   right: 10)
        
        //        NSLayoutConstraint.deactivate([collectionViewTopConstraint])
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerTopConstraint = headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
        let headerBottomConstraint = headerView.heightAnchor.constraint(equalToConstant: heigth)
        
        NSLayoutConstraint.activate([
            headerTopConstraint,
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBottomConstraint,
        ])
        
        self.headerView = headerView
        self.headerTopConstraint = headerTopConstraint
        self.headerBottomConstraint = headerBottomConstraint
    }
    
    private func setTeamData(_ data: Team) {
        navigationItem.title = data.name
        team = data
        headerView.alpha = 1.0
        headerView.setTeam(data, imageLoader: imageLoader)
    }
    
}

extension TeamViewController: UICollectionViewDataSource {
    private func setData(_ data: [Player]) {
        players = data
        if players.isEmpty {
            showEmpty(message: "No players found")
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.playerCellId, for: indexPath)
        
        let player = players[indexPath.item]
        
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = true
        cell.backgroundColor = .blue
        
        let imageV = cell.viewWithTag(1) as! UIImageView
        let nameLbl = cell.viewWithTag(2) as! UILabel
        
        nameLbl.text = player.name
        imageLoader.load(imageUrl: player.image, into: imageV, placeholder: team.flatMap { $0.sportType.flatMap { UIImage(named: $0.uiImage) } })
        
        return cell
    }
}

extension TeamViewController: UICollectionViewDelegate {}

extension TeamViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let insets = collectionView.contentInset + layout.sectionInset
        let collectionWidth = collectionView.bounds.width - insets.left - insets.right
        let targetWidth = collectionWidth / floor(collectionWidth / 150) - (layout.minimumInteritemSpacing / 2)
        let height = targetWidth + 20
        let width = targetWidth
        return CGSize(width: width, height: height)
    }
}

