//
//  LeagueViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import UIKit
import Swinject
import Combine

class LeagueViewController: UIViewController, AnyInstantiableView, WithLoaderView {
    
    static let storyboardId: String = "leagueVC"
    
    var args: LeagueIdentity!
    private var viewModel: LeagueViewModel!
    private weak var favouriteButton: UIBarButtonItem!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadLeague()
    }
    
    func setupUI() {
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
                    case .loaded(data: let data):
                        self.hideLoader()
                        self.navigationItem.title = data.data.leagueName
                    case .error(error: let error):
                        self.hideLoader()
                        print(error)
                    default:
                        break
                }
            }.store(in: &cancellables)
    }
    
    func inject(_ container: Container) {
        viewModel = LeagueViewModel(leagueIdentity: args,
                                    model: LeagueModel(database: container.require((any AnyLeagueDatabase).self)),
                                    notificationCenter: container.require(NotificationCenter.self))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
