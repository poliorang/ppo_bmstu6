//
//  ICompetitionToTeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol ICompetitionToTeamRepository {
    func addCompetition(competition: Competition?, team: Team?) -> Any? 
}
