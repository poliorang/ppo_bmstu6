//
//  TeamService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class TeamService: ITeamService {
    
    let teamRepository: ITeamRepository?
    let getDataService: IGetDataService?
    
    init(teamRepository: ITeamRepository, getDataService: IGetDataService) {
        self.teamRepository = teamRepository
        self.getDataService = getDataService
    }
    
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team? {
        let team = teamRepository?.createTeam(id: id, name: name, participants: participants, competitions: competitions, score: 0)
        return team
    }
    
    func updateTeam(name: String?, team: Team?) {
        teamRepository?.updateTeam(name: name, team: team)
    }
    
    func deleteTeam(name: String?) {
        teamRepository?.deleteTeam(name: name)
    }
    
    func getTeam(name: String?) -> Team? {
        let team = teamRepository?.getTeam(name: name)
        return team
    }
    
    func getTeams(parameter: SortParameter?, stepName: String?) -> [Team]? {
        let teams = teamRepository?.getTeams()
        
        guard var teams = teams else {
            return nil
        }
        
        for i in 0..<teams.count {
            var score = 0
            
            if let participants = teams[i].participants {
                
                var participantScore = 0
                for j in 0..<participants.count {
                    let steps = getDataService?.getStepsByParticipant(id: teams[i].participants![j].id, stepName: stepName)

                    if let steps = steps {
                        for step in steps {
                            
                            let loots = getDataService?.getLootsByStep(id: step.id)
                            if let loots = loots {
                                for loot in loots { participantScore += loot.score }
                            }
                        }
                    }
                    teams[i].participants![j].score = participantScore
                }
                score += participantScore
            }
            
            teams[i].score = score
        }
        
        if parameter == .ascending {
            return teams.sorted(by: { $0.score < $1.score })
        }
        
        if parameter == .decreasing {
            return teams.sorted(by: { $0.score > $1.score })
        }
        
        return teams
    }
    
}
