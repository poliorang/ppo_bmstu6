//
//  IParticipantService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

import Foundation

protocol IParticipantService {
    func createParticipant(id: String?, lastName: String?, firstName: String?, patronymic: String?, team: Team?, city: String?, birthday: Date?, score: Int) throws -> Participant
    
    func updateParticipant(previousParticipant: Participant?, newParticipant: Participant?) throws -> Participant
    func deleteParticipant(participant: Participant?) throws
    
    func getParticipant(fullname: String?) throws -> [Participant]?
    func getParticipants() throws -> [Participant]?
    
    func getParticipantByTeam(team: Team?) throws -> [Participant]?
    func getParticipantsScoreByCompetition(participants: [Participant]?, competition: Competition?, stepName: StepsName?, parameter: SortParameter?) throws -> [Participant]?
}
