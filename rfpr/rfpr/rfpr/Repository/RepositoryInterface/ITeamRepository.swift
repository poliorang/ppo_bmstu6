//
//  ITeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol ITeamRepository {
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team?
    
    func updateTeam(name: String?, team: Team?) -> Any?
    func deleteTeam(name: String?) -> Any?
    
    func getTeam(name: String?) -> Team?
    func getTeams() -> [Team]?
}
