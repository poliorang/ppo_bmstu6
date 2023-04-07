//
//  ITeamService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol ITeamService {
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team?
    
    func updateTeam(name: String?, team: Team?)
    func deleteTeam(name: String?)
    
    func getTeam(name: String?) -> Team?
    func getTeams(parameter: SortParameter?, stepName: String?) -> [Team]?
}

