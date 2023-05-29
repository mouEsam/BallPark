//
//  FavouriteTeamsViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import UIKit
import Combine
import Swinject
import Reachability

private let teamCellId = "teamCellId"

class FavouriteTeamsViewController: UITableViewController, AnyStoryboardView, WithLoaderView {
    class var storyboardId: String { "favouriteTeamsVC" }
    
    private var viewModel: FavouriteTeamsViewModel!
    private var subscribers: [AnyCancellable] = []
    
    private var teams: [Team] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.uiStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleUIState)
            .store(in: &subscribers)
        setupUI()
        viewModel.loadTeams()
    }
    
    func setupUI() {
        tableView.register(UINib(nibName: "TeamTableViewCell",
                                 bundle: Bundle(for: TeamTableViewCell.self)),
                           forCellReuseIdentifier: teamCellId)
    }
    
    func inject(_ container: Container) {
        let model = FavouriteTeamsModel(database: container.require((any FavouritesDatabase<Team>).self))
        viewModel = FavouriteTeamsViewModel(model: model,
                                            notificationCenter: container.require(NotificationCenter.self))
    }
    
    func handleUIState(_ state: UIState<[Team]>) {
        switch (state) {
            case .loading:
                showLoader()
            case .loaded(data: let data):
                setData(Array(data.data))
                hideLoader()
                break
            case .error(error: let error):
                print(error)
                hideLoader()
            default:
                hideLoader()
                break
        }
    }
    
    // MARK: - Table view data source
    
    func setData(_ data: [Team]) {
        teams = data
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: teamCellId, for: indexPath) as! TeamTableViewCell
        
        cell.setTeam(teams[indexPath.item])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let team = teams[indexPath.row]
        if let teamIdentity = team.identity {
            let vc = instantiate(TeamViewController.self, args: teamIdentity)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
