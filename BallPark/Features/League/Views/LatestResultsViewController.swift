//
//  LatestResultsViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Combine
import Swinject

class LatestResultsViewController: UIViewController, WithArgs, AnyStoryboardView, WithLoaderView, WithEmptyView, WithErrorView {
    private static let resultCellId = "resultCell"
    typealias Args = LeagueIdentity
    
    private var imageLoader: (any AnyImageLoader)!
    private var viewModel: LeagueEventsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private var events: [any AnyLeagueEvent] = []
    
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func inject(_ container: Container) {
        imageLoader = container.require((any AnyImageLoader).self)
        viewModel = container.require((any AnyLeagueEventsViewModelFactory).self).create(for: args, withRange: .latest)
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
        
        collectionView.contentInset.top = 10
        collectionView.contentInset.left = 10
        collectionView.contentInset.right = 10
        collectionView.contentInset.bottom = 10
        
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

extension LatestResultsViewController: UICollectionViewDataSource {
    private func setData(_ data: [any AnyLeagueEvent]) {
        events = data
        collectionView.reloadData()
        if data.isEmpty {
            showEmpty(message: "No results found")
        }
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
        
        let firstSide = event.firstSide
        let secondSide = event.secondSide
        
        let nameLbl = cell.viewWithTag(1) as! UILabel
        let dateLbl = cell.viewWithTag(2) as! UILabel
        let timeLbl = cell.viewWithTag(3) as! UILabel
        let resultLbl = cell.viewWithTag(6) as! UILabel
        let homeTeamImg = cell.viewWithTag(4) as! UIImageView
        let awayTeamImg = cell.viewWithTag(5) as! UIImageView
        
        resultLbl.text = event.eventDetails.eventFinalResult
        nameLbl.text = "\(event.firstSide.name ?? "") vs. \(event.secondSide.name ?? "")"
        dateLbl.text =  event.eventDetails.eventDate.map { dateFormatter.string(from: $0) } ?? nil
        timeLbl.text = event.eventDetails.eventTime.map { timeFormatter.string(from: $0) } ?? nil
        
        imageLoader.load(imageUrl: firstSide.logo, into: homeTeamImg, placeholder: UIImage(named: event.sportType.uiImage))
        imageLoader.load(imageUrl: secondSide.logo, into: awayTeamImg, placeholder: UIImage(named: event.sportType.uiImage))
        
        return cell
    }
}

extension LatestResultsViewController: UICollectionViewDelegate {
    
}

extension LatestResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset + (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let collectionWidth = collectionView.bounds.width - insets.right - insets.left
        
        return CGSize(width: collectionWidth, height: 120)
    }
}
