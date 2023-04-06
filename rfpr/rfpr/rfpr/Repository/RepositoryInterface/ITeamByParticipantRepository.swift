//
//  ITeamByParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol ITeamByParticipantRepository {
    func getTeamByParticipant(id: Int?) -> [Team]? 
}
