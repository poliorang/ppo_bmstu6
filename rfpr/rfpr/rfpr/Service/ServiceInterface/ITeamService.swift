//
//  ITeamService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol ITeamService {
    func createTeam(id: String?, name: String?, competitions: [Competition]?, score: Int) throws -> Team
    
    func updateTeam(previousTeam: Team?, newTeam: Team?) throws -> Team
    func deleteTeam(team: Team?) throws
    
    func getTeam(name: String?) throws -> [Team]?
    func getTeams(parameter: SortParameter?, stepName: String?) throws -> [Team]?
}

