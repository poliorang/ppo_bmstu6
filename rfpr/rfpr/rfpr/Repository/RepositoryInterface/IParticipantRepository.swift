//
//  IParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

protocol IParticipantRepository {
    func createParticipant(participant: Participant) throws -> Participant?
    func updateParticipant(previousParticipant: Participant, newParticipant: Participant) throws -> Participant? 
    func deleteParticipant(participant: Participant) throws
    
    func getParticipants() throws -> [Participant]?
    func getParticipantScoreByCompetition(participant: Participant, competition: Competition, stepName: StepsName?) throws -> Participant?
}
