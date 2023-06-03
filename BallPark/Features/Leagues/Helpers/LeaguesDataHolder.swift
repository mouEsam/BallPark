//
//  LeaguesDataHolder.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
import UIKit

class LeaguesDataHolder: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let leagueCellId: String
    private weak var tableView: UITableView!
    private weak var view: (any AnyStoryboardView & WithEmptyView)!
    private let imageLoader: any AnyImageLoader
    
    private var leagues: [League] = []
    
    init(leagueCellId: String,
         tableView: UITableView!,
         view: some AnyStoryboardView & WithEmptyView,
         imageLoader: any AnyImageLoader) {
        self.leagueCellId = leagueCellId
        self.tableView = tableView
        self.view = view
        self.imageLoader = imageLoader
    }
    
    func setData(_ data: [League]) {
        leagues = data
        if data.isEmpty {
            view.showEmpty(message: "No leagues found")
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: leagueCellId, for: indexPath) as! LeagueTableViewCell
        
        cell.setLeague(leagues[indexPath.item], imageLoader: imageLoader)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let league = leagues[indexPath.row]
        
        if let leagueIdentity = league.identity {
            let vc = view.instantiate(LeagueViewController.self, args: leagueIdentity)
            view.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

