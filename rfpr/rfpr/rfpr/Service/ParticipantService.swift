//
//  ParticipantService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

class ParticipantService: IParticipantService {
    
    let participantRepository: IParticipantRepository?
    
    init(participantRepository: IParticipantRepository) {
        self.participantRepository = participantRepository
    }
    
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant? {
        let participant = participantRepository?.createParticipant(id: id, fullname: fullname, city: city, birthday: birthday, role: role, autorization: autorization, score: score)
        return participant
    }
    
    func updateParticipant(id: Int?) {
        participantRepository?.updateParticipant(id: id)
    }
    
    func deleteParticipant(id: Int?) {
        participantRepository?.updateParticipant(id: id)
    }
    
    func getParticipant(id: Int?) -> Participant? {
        let participant = participantRepository?.getParticipant(id: id)
        return participant
    }
    
    func getParticipants(parameter: SortParameter?, stepName: String?) -> [Participant]? {
        let participants = participantRepository?.getParticipants(parameter: parameter, stepName: stepName)
        return participants
    }
    
}

