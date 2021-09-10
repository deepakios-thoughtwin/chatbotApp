//
//  ProfileViewController.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 23/04/21.
//

import UIKit
import YMSupport

enum AvailabilityStatus: String {
    case available, busy, away , offline, dnd
    var color: UIColor {
        switch self {
        case .available: return .systemGreen
        case .busy: return .systemRed
        case .away: return .systemGray
        default: return .systemGray
        }
    }
}

class ProfileViewController: UITableViewController {
    @IBOutlet weak var availibilityLabel: UILabel!
    @IBOutlet weak var selectedBotLabel: UILabel!
    @IBOutlet weak var profileImage: RoundImageStatusView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedBotLabel.text = defaults.selectedBotName ?? ""
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 9: showLogoutAlert()
        case 3: showAvailabilityAlert()
        default: break
        }
    }

    private func showLogoutAlert() {
        let alertController = UIAlertController(title: "", message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(.init(title: "Logout", style: .destructive, handler: {_ in self.logout() }))
        self.present(alertController, animated: true, completion: nil)
    }

    func setAvailibility(_ status: AgentModel.Status) {
        availibilityLabel.text = status.rawValue.capitalized
        profileImage.status = status
    }

    private func showAvailabilityAlert() {
        let alertController = UIAlertController(title: "Status", message: "", preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Available", style: .default, handler: {_ in self.setAvailibility(.available)}))
        alertController.addAction(.init(title: "Busy", style: .default, handler: {_ in self.setAvailibility(.busy)}))
        alertController.addAction(.init(title: "Away", style: .default, handler: {_ in self.setAvailibility(.away)}))
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    private func logout() {
        defaults.accessToken = nil
        defaults.username = nil
        defaults.selectedBotName = nil
        SceneDelegate.shared?.showLogin()
    }
}
