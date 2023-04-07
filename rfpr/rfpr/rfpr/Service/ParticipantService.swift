//
//  ParticipantService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

class ParticipantService: IParticipantService {
    
    let participantRepository: IParticipantRepository?
    let getDataService: IGetDataService?
    
    init(participantRepository: IParticipantRepository, getDataService: IGetDataService) {
        self.participantRepository = participantRepository
        self.getDataService = getDataService
    }
    
    
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant? {
        let participant = participantRepository?.createParticipant(id: id, fullname: fullname, city: city, birthday: birthday, role: role, autorization: autorization, score: score)
        return participant
    }
    
    func updateParticipant(id: Int?, participant: Participant?) {
        participantRepository?.updateParticipant(id: id, participant: participant)
    }
    
    func deleteParticipant(id: Int?) {
        participantRepository?.deleteParticipant(id: id)
    }
    
    func getParticipant(id: Int?) -> Participant? {
        let participant = participantRepository?.getParticipant(id: id)
        return participant
    }
    
    
    func getParticipants(parameter: SortParameter?, stepName: String?) -> [Participant]? {
        
        let participants = participantRepository?.getParticipants()
        
        guard var participants = participants else {
            return nil
        }
        
        for i in 0..<participants.count {
            
            let steps = getDataService?.getStepsByParticipant(id: participants[i].id, stepName: stepName)
            
            var score = 0
            if let steps = steps {
                for step in steps {
                    
                    let loots = getDataService?.getLootsByStep(id: step.id)
                    if let loots = loots {
                        for loot in loots { score += loot.score }
                    }
                }
            }
            
            participants[i].score = score
        }
        
        if parameter == .ascending {
            return participants.sorted(by: { $0.score < $1.score })
        }
        
        if parameter == .decreasing {
            return participants.sorted(by: { $0.score > $1.score })
        }
        
        return participants
    }

}

