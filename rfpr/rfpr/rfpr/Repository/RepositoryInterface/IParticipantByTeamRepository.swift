//
//  IParticipantByTeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol IParticipantByTeamRepository {
    func getParticipantByTeam(id: Int?) -> [Participant]?
}
