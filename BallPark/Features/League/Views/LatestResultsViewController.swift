//
//  LatestResultsViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Combine
import Swinject

class LatestResultsViewController: UIViewController, WithArgs, AnyStoryboardView, WithLoaderView {
    private static let resultCellId = "resultCell"
    typealias Args = LeagueIdentity
    
    private var viewModel: LeagueEventsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private var events: [LeagueEvent] = []
    
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func inject(_ container: Container) {
        let model = LatestEventsModel(calendar: container.require(Calendar.self),
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

extension LatestResultsViewController: UICollectionViewDataSource {
    func setData(_ data: [LeagueEvent]) {
        events = data
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.resultCellId, for: indexPath)
        let event = events[indexPath.item]
        
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = true
        cell.backgroundColor = .blue
        
        let nameLbl = cell.viewWithTag(1) as! UILabel
        let dateLbl = cell.viewWithTag(2) as! UILabel
        let timeLbl = cell.viewWithTag(3) as! UILabel
        let firstImg = cell.viewWithTag(4) as! UIImageView
        let secondImg = cell.viewWithTag(5) as! UIImageView
        
        nameLbl.text = "\(event.homeTeam.name) vs. \(event.awayTeam.name)"
        dateLbl.text = dateFormatter.string(from: event.eventDetails.eventDate)
        timeLbl.text = timeFormatter.string(from: event.eventDetails.eventTime)
        
        return cell
    }
}

extension LatestResultsViewController: UICollectionViewDelegate {
    
}

extension LatestResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
}
