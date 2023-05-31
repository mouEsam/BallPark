//
//  NextEventsViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Combine
import Swinject


class NextEventsViewController: UIViewController, AnyStoryboardView, WithArgs, WithLoaderView, WithEmptyView, WithErrorView {
    private static let eventCellId = "eventCell"
    typealias Args = LeagueIdentity
    
    private var imageLoader: (any AnyImageLoader)!
    private var viewModel: LeagueEventsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private var events: [LeagueEvent] = []
    
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func inject(_ container: Container) {
        imageLoader = container.require((any AnyImageLoader).self)
        let model = NextEventsModel(calendar: container.require(Calendar.self),
                                    remoteService: container.require(LeagueEventsRemoteService.self))
        viewModel = LeagueEventsViewModel(leagueIdentity: args,
                                          model: model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        timeFormatter.dateFormat = "HH:mm"
        
        setupUI()
        viewModel.loadLeagues()
    }
    
    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset.left = 10
        collectionView.contentInset.right = 10
        
        viewModel.$uiState
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
                        self.showError(message: error.localizedDescription)
                    default:
                        break
                }
            }.store(in: &cancellables)
    }
    
    
    
}

extension NextEventsViewController: UICollectionViewDataSource {
    private func setData(_ data: [LeagueEvent]) {
        events = data
        collectionView.reloadData()
        if data.isEmpty {
            showEmpty(message: "No events found")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.eventCellId, for: indexPath)
        let event = events[indexPath.item]
        
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = true
        cell.backgroundColor = .blue
        
        let homeTeam = event.homeTeam
        let awayTeam = event.awayTeam
        
        let nameLbl = cell.viewWithTag(1) as! UILabel
        let dateLbl = cell.viewWithTag(2) as! UILabel
        let timeLbl = cell.viewWithTag(3) as! UILabel
        
        nameLbl.text = "\(homeTeam.name) vs. \(awayTeam.name)"
        dateLbl.text = dateFormatter.string(from: event.eventDetails.eventDate)
        timeLbl.text = timeFormatter.string(from: event.eventDetails.eventTime)
        
        return cell
    }
}

extension NextEventsViewController: UICollectionViewDelegate {
    
}

extension NextEventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset + (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let collectionHeight = collectionView.bounds.height - insets.top - insets.bottom
        
        return CGSize(width: 200, height: collectionHeight)
    }
}
