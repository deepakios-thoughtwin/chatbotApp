//
//  AgentListViewController.swift
//  YMPartner
//
//  Created by mac on 09/09/21.
//

import UIKit
import Combine
import YMSupport

class AgentListViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    let viewModel = AgentListViewModel()
    var storage = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        viewModel.agentListSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.dataSource = self
                self?.hideSpinner()
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }.store(in: &storage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSpinner()
        viewModel.loadAgents()
    }

    @objc func onRefresh(refreshControl: UIRefreshControl) {
        viewModel.loadAgents()
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
        cell.agentName.text = obj.model.agentProfile?.name ?? ""
        cell.descriptionLabel.text = obj.model.agentProfile?.description
        cell.agentImage.imageView.image = obj.image
        cell.agentImage.status = obj.model.status ?? .away
        return cell
    }
}

class AgentTableViewCell: UITableViewCell {
    @IBOutlet weak var agentImage:RoundImageStatusView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

