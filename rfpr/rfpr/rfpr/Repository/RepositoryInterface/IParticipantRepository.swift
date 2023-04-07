//
//  IParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

protocol IParticipantRepository {
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant?
    
    func updateParticipant(id: Int?, participant: Participant?) -> Any?
    func deleteParticipant(id: Int?) -> Any?
    
    func getParticipant(id: Int?) -> Participant?
    func getParticipants() -> [Participant]?
    
}
