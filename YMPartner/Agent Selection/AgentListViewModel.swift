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
    
    func loadAgents(){
        YMSupport.getAgents
    }
    
}
