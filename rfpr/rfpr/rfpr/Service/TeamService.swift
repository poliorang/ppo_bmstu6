//
//  TeamService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class TeamService: ITeamService {
    
    let teamRepository: ITeamRepository?
    
    init(teamRepository: ITeamRepository) {
        self.teamRepository = teamRepository
    }
    
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team? {
        let team = teamRepository?.createTeam(id: id, name: name, participants: participants, competitions: competitions, score: 0)
        return team
    }
    
    func updateTeam(name: String?) {
        teamRepository?.updateTeam(name: name)
    }
    
    func deleteTeam(name: String?) {
        teamRepository?.deleteTeam(name: name)
    }
    
    func getTeam(name: String?) -> Team? {
        let team = teamRepository?.getTeam(name: name)
        return team
    }
    
    func getTeams(parameter: SortParameter?, stepName: String?) -> [Team]? {
        let teams = teamRepository?.getTeams(parameter: parameter, stepName: stepName)
        return teams
    }
    
    
}
