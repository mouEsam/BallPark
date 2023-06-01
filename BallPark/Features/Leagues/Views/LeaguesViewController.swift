//
//  leaguesTableViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit
import Combine
import Swinject
import Reachability

private let leagueCellId = "leagueCellId"

class LeaguesViewController: UITableViewController, AnyInstantiableView, WithLoaderView, WithEmptyView, WithErrorView {
    typealias Args = SportType
    class var storyboardId: String { "leaguesVC" }
    
    private var imageLoader: (any AnyImageLoader)!
    private var viewModel: (any AnyLeaguesViewModel)!
    private var subscribers: [AnyCancellable] = []
    
    private var leagues: [League] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.uiStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleUIState)
            .store(in: &subscribers)
        setupUI()
        viewModel.loadLeagues()
    }
    
    func setupUI() {
        tableView.register(UINib(nibName: "LeagueTableViewCell",
                                 bundle: Bundle(for: LeagueTableViewCell.self)),
                           forCellReuseIdentifier: leagueCellId)
    }
    
    func inject(_ container: Container) {
        imageLoader = container.require((any AnyImageLoader).self)
        if let viewModel = container.resolve(AnyLeaguesViewModel.self) {
            self.viewModel = viewModel
        } else {
            let model = LeaguesModel(remoteService: container.require(LeaguesRemoteService.self),
                                     database: container.require((any AnyLeagueDatabase).self),
                                     fetchCacheStrategy: container.require((any AnyDataFetchCacheStrategy).self))
            viewModel = LeaguesViewModel(sportType: args, model: model)
        }
    }
    
    func handleUIState(_ state: UIState<[League]>) {
        switch (state) {
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
    }
    
    // MARK: - Table view data source
    
    private func setData(_ data: [League]) {
        leagues = data
        if data.isEmpty {
            showEmpty(message: "No leagues found")
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: leagueCellId, for: indexPath) as! LeagueTableViewCell
        
        cell.setLeague(leagues[indexPath.item], imageLoader: imageLoader)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let league = leagues[indexPath.row]
        if let leagueIdentity = league.identity {
            let vc = instantiate(LeagueViewController.self, args: leagueIdentity)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
