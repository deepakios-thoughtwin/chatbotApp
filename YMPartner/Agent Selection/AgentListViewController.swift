//
//  AgentListViewController.swift
//  YMPartner
//
//  Created by mac on 09/09/21.
//

import UIKit
import Combine

class AgentListViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    let viewModel = AgentListViewModel()
    var storage = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        self.tableView.dataSource = self // to avoid initial loading
        self.hideSpinner()
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        
        viewModel.agentListSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.dataSource = self // to avoid initial loading
                self?.hideSpinner()
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }.store(in: &storage)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        showSpinner()
//        viewModel.loadBots()
    }

    @objc func onRefresh(refreshControl: UIRefreshControl) {
       // viewModel.loadBots()
    }

    
}
extension AgentListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.agents.count
        tableView.backgroundView = count == 0 ? emptyView : nil
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agentCell", for: indexPath) as! AgentTableViewCell
        let obj = viewModel.agents[indexPath.row]
//        cell.agentName.text = obj.model.agent
//        cell.descriptionLabel.text = obj.model.botDesc
//        cell.agentImage.image = obj.image
//
//        // Show already selected bot
//        if obj.model.userName == defaults.selectedBotId {
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//        }
        return cell
    }
}

class AgentTableViewCell: UITableViewCell {
    @IBOutlet weak var agentImage: UIImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = isSelected ? .checkmark : .none
    }
}
