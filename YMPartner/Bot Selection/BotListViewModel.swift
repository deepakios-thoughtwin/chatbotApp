//
//  BotSelectionViewModel.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 21/04/21.
//

import Foundation
import Combine
import YMSupport

class BotListViewModel {
    var bots = [(model: BotModel, image: UIImage?)]() {
        didSet {
            botListSubject.send()
        }
    }

    var botListSubject = PassthroughSubject<Void, Never>()
    var rowItemUpdatePublisher = PassthroughSubject<Int, Never>()

    /// Loads bots from the SDK and sets the list to bots variable
    /// Bot images are loaded separately and and are published on `rowItemUpdatePublisher`
    func loadBots() {
        YMSupport.getBots { [weak self] botList, error in
            guard let self = self else { return }
            if let error = error {
                print("ERROR handle \(error)")
            } else if let bots = botList {
                self.bots = bots.map { bot in
                    (model: bot, image: bot.botIcon.map(URLCache.shared.image(atURL:)) ?? nil)
                }
                self.loadAllImages()
            }
        }
    }

    private func loadAllImages() {
        for (i, bot) in bots.enumerated() where bots[i].image == nil && bot.model.botIcon != nil {
            URLSession.shared.dataTask(with: bot.model.botIcon!) { (data, _, error) in
                if let data = data {
                    self.bots[i].image = UIImage(data: data)
                    self.rowItemUpdatePublisher.send(i)
                }
            }.resume()
        }
    }

    func setBot(atIndex row: Int, completion: Int) {
        defaults.selectedBotId = bots[row].model.userName
    }
}

extension URLCache {
    func image(atURL url: URL) -> UIImage? {
        guard let resp = cachedResponse(for: URLRequest(url: url)) else {
            return nil
        }
        return UIImage(data: resp.data)
    }
}
