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
    
    private var dataHolder: LeaguesDataHolder!
    private var imageLoader: (any AnyImageLoader)!
    private var viewModel: (any AnyLeaguesViewModel)!
    private var subscribers: [AnyCancellable] = []
        
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
        
        dataHolder = LeaguesDataHolder(leagueCellId: leagueCellId,
                                       tableView: tableView,
                                       view: self,
                                       imageLoader: imageLoader)
    }
    
    func inject(_ container: Container) {
        imageLoader = container.require((any AnyImageLoader).self)
        viewModel = container.require((any AnyLeaguesViewModelFactory).self).create(for: args)
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
                self.dataHolder.setData(data.data)
            case .error(error: let error):
                self.hideLoader()
                self.hideError()
                self.showError(message: error.localizedDescription)
            default:
                break
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataHolder.numberOfSections(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHolder.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataHolder.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataHolder.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataHolder.tableView(tableView, didSelectRowAt: indexPath)
    }
}
