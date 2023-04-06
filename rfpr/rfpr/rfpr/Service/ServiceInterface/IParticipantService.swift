//
//  IParticipantService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

import Foundation

protocol IParticipantService {
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant?
    
    func updateParticipant(id: Int?)
    func deleteParticipant(id: Int?)
    
    func getParticipant(id: Int?) -> Participant?
    func getParticipants(parameter: SortParameter?, stepName: String?) -> [Participant]?
}
