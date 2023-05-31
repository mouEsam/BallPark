//
//  LeagueViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import UIKit
import Swinject
import Combine

class LeagueViewController: UIViewController, AnyInstantiableView, WithLoaderView, WithErrorView {
    typealias Args = LeagueIdentity
    
    static let storyboardId: String = "leagueVC"
    
    private var viewModel: LeagueViewModel!
    private weak var favouriteButton: UIBarButtonItem!
    private var cancellables: Set<AnyCancellable> = []
    
    private weak var nextEventsVC: NextEventsViewController!
    private weak var latestEventsVC: LatestResultsViewController!
    private weak var teamsVC: TeamsViewController!
    
    func inject(_ container: Container) {
        viewModel = LeagueViewModel(leagueIdentity: args,
                                    model: LeagueModel(database: container.require((any AnyLeagueDatabase).self)),
                                    notificationCenter: container.require(NotificationCenter.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadLeague()
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
                    return UIImage(systemName: "heart.fill")
                } else {
                    return UIImage(systemName: "heart")
                }
            }.assign(to: \.image, on: favouriteButton)
            .store(in: &cancellables)
        
        viewModel.$uiState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                    case .loading:
                        self.showLoader()
                        self.hideError()
                    case .loaded(data: let data):
                        self.hideLoader()
                        self.hideError()
                        self.setData(data.data)
                    case .error(error: let error):
                        self.hideLoader()
                        self.showError(message: error.localizedDescription)
                    default:
                        break
                }
            }.store(in: &cancellables)
    }
    
    private func setData(_ data: League) {
        navigationItem.title = data.name
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let childVC = segue.destination as? NextEventsViewController {
            nextEventsVC = childVC
            associateArgsWithChild(child: childVC)
            associateContainerWithChild(child: childVC)
        } else if let childVC = segue.destination as? LatestResultsViewController {
            latestEventsVC = childVC
            associateArgsWithChild(child: childVC)
            associateContainerWithChild(child: childVC)
        } else if let childVC = segue.destination as? TeamsViewController {
            teamsVC = childVC
            associateArgsWithChild(child: childVC)
            associateContainerWithChild(child: childVC)
        }
    }
    
}
