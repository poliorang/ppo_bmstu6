//
//  IParticipantToTeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol IParticipantToTeamRepository {
    func addParticipant(participant: Participant, team: Team) throws
}
