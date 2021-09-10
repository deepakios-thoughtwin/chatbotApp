//
//  AgentListViewModel.swift
//  YMPartner
//
//  Created by mac on 09/09/21.
//

import Foundation
import Combine
import YMSupport

class AgentListViewModel {
    var agents = [(model : AgentModel , image: UIImage?)](){
        didSet {
            agentListSubject.send()
        }
    }
    
    var agentListSubject = PassthroughSubject<Void, Never>()
    var rowItemUpdatePublisher = PassthroughSubject<Int, Never>()
    
    func loadAgents() {
        YMSupport.getAgents { [weak self] agentList, error in
            guard let self = self else { return }
            if let error = error {
                print("ERROR handle \(error)")
            } else if let agents = agentList {
                self.agents = agents.map { bot in
                    (model: bot, image: bot.agentProfile?.profilePicture.map(URLCache.shared.image(atURL:)) ?? nil)
                }
               self.loadAllImages()
            }
        }
    }
    
    private func loadAllImages(){
        for (i, agent) in agents.enumerated() where agents[i].image == nil && agent.model.agentProfile?.profilePicture != nil {
            URLSession.shared.dataTask(with: (agent.model.agentProfile?.profilePicture!)!) { (data, _, error) in
                if let data = data {
                    self.agents[i].image = UIImage(data: data)
                    self.rowItemUpdatePublisher.send(i)
                }
            }.resume()
        }
    }
}
