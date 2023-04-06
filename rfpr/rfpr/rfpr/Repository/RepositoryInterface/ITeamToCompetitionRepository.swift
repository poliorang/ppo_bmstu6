//
//  ITeamToCompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol ITeamToCompetitionRepository {
    func addTeam(team: Team?, competition: Competition?) -> Any?
}
