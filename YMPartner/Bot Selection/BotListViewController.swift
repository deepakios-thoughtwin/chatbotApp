//
//  BotSelectionViewController.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 20/04/21.
//

import UIKit
import Combine
import YMSupport

class BotListViewController: UIViewController, StoryboardInitializable {
    static var storyboardName: String { "BotList" }

    @IBOutlet var emptyView: UIView!
    let viewModel = BotListViewModel()
    var storage = Set<AnyCancellable>()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        viewModel.botListSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.dataSource = self // to avoid initial loading
                self?.hideSpinner()
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }.store(in: &storage)

        viewModel.rowItemUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }.store(in: &storage)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSpinner()
        viewModel.loadBots()
    }

    @objc func onRefresh(refreshControl: UIRefreshControl) {
        viewModel.loadBots()
    }

    @IBAction func saveAction(_ sender: Any) {
        guard let index = tableView.indexPathForSelectedRow else {
            return }
        let botId = viewModel.bots[index.row].model.userName
        YMSupport.botId = botId

        defaults.selectedBotId = botId
        defaults.selectedBotName = viewModel.bots[index.row].model.botName
    }
}

extension BotListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.bots.count
        tableView.backgroundView = count == 0 ? emptyView : nil
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "botCell", for: indexPath) as! BotSelectionTableViewCell
        let bot = viewModel.bots[indexPath.row]
        cell.nameLabel.text = bot.model.botName
        cell.descriptionLabel.text = bot.model.botDesc
        cell.botImage.image = bot.image

        // Show already selected bot
        if bot.model.userName == defaults.selectedBotId {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
}

class BotSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var botImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = isSelected ? .checkmark : .none
    }
}
