//
//  ITeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol ITeamRepository {
    func createTeam(team: Team) throws -> Team?
    
    func updateTeam(previousTeam: Team, newTeam: Team) throws -> Team?
    func deleteTeam(team: Team) throws
    
    func getTeams() throws -> [Team]?
    
    func getTeamScoreByCompetition(team: Team, competition: Competition, stepName: StepsName?) throws -> Team? 
}
