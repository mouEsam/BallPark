//
//  TeamViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Swinject
import Combine

class TeamViewController: UIViewController, AnyInstantiableView, WithLoaderView {
    typealias Args = TeamIdentity
    
    static let storyboardId: String = "teamVC"
    
    private var viewModel: TeamViewModel!
    private weak var favouriteButton: UIBarButtonItem!
    private var cancellables: Set<AnyCancellable> = []
    
    func inject(_ container: Container) {
        viewModel = TeamViewModel(teamIdentity: args,
                                    model: TeamModel(database: container.require((any AnyTeamDatabase).self)),
                                    notificationCenter: container.require(NotificationCenter.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadTeam()
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
        
        viewModel.$uiState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                    case .loading:
                        self.showLoader()
                    case .loaded(data: let data):
                        self.hideLoader()
                        self.navigationItem.title = data.data.name
                    case .error(error: let error):
                        self.hideLoader()
                        print(error)
                    default:
                        break
                }
            }.store(in: &cancellables)
    }
    
}
