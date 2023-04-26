//
//  TeamService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class TeamService: ITeamService {
    
    let teamRepository: ITeamRepository?
    let participantRepository: IParticipantByTeamRepository?
    let getDataService: IGetDataService?
    
    init(teamRepository: ITeamRepository,
         participantRepository: IParticipantByTeamRepository,
         getDataService: IGetDataService) {
        
        self.teamRepository = teamRepository
        self.participantRepository = participantRepository
        self.getDataService = getDataService
    }
    
    func createTeam(id: String?, name: String?, competitions: [Competition]?, score: Int) throws -> Team {
        guard let id = id,
              let name = name else {
                  throw ParameterError.funcParameterError
        }
        
        let team = Team(id: id, name: name, competitions: competitions, score: 0)
        let createdTeam: Team?
        
        do {
            createdTeam = try teamRepository?.createTeam(team: team)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdTeam = createdTeam else {
            throw DatabaseError.addError
        }
        
        return createdTeam
    }
    
    func updateTeam(previousTeam: Team?, newTeam: Team?) throws -> Team {
        guard let previousTeam = previousTeam,
              let newTeam = newTeam else {
                  throw ParameterError.funcParameterError
        }
        
        let updatedTeam: Team?
        do {
            updatedTeam = try teamRepository?.updateTeam(previousTeam: previousTeam, newTeam: newTeam)
            
        } catch DatabaseError.updateError {
            throw DatabaseError.updateError
        }
        
        guard let updatedTeam = updatedTeam else {
            throw DatabaseError.updateError
        }
        
        return updatedTeam
    }
    
    func deleteTeam(team: Team?) throws {
        guard let team = team else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try teamRepository?.deleteTeam(team: team)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getTeam(name: String?) throws -> [Team]? {
        guard let name = name else {
            throw ParameterError.funcParameterError
        }
        
        let teams: [Team]?
        do {
            try teams = teamRepository?.getTeams()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        guard let teams = teams else {
            return nil
        }
        
        var resultTeams = [Team]()
        
        for team in teams {
            if team.name.contains(name) {
                resultTeams.append(team)
            }
        }
        
        if resultTeams.isEmpty { return nil }
        
        return resultTeams
    }
    
    func getTeams(parameter: SortParameter?, stepName: String?) throws -> [Team]? {
        let teams = try teamRepository?.getTeams()

        guard var teams = teams else {
            return nil
        }
        
        for i in 0..<teams.count {
            var score = 0

            
            var participants: [Participant]?
            do {
                participants = try participantRepository?.getParticipantByTeam(team: teams[i])
            } catch {
                throw DatabaseError.getError
            }
            
            if var participants = participants {
                var participantScore = 0
                if participants.count == 0 { continue }
                for j in 0..<participants.count {
                    let steps = getDataService?.getStepsByParticipant(participant: participants[j], stepName: stepName)

                    
                    if let steps = steps {
                        
                        for step in steps {
                            let loots = getDataService?.getLootsByStep(step: step)
                            if let loots = loots {
                                for loot in loots { participantScore += loot.score }
                            }
                        }
                    }
                    participants[j].score = participantScore
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
