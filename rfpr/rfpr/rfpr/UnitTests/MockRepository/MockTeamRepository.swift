//
//  TeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class MockTeamRepository: ITeamRepository, ICompetitionToTeamRepository,
                          IParticipantByTeamRepository, IParticipantToTeamRepository {

    var dataManager: IDataManager
    
    init() {
        self.dataManager = MockDataManager()
    }
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team? {
        guard let id = id,
              let name = name else { return nil }
        let team = dataManager.createTeam(id: id, name: name, participants: participants, competitions: competitions, score: score)
        return team
    }
    
    func updateTeam(name: String?) -> Any? {
        guard let name = name else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.teams, id: nil, name: name)
    }
    
    func deleteTeam(name: String?) -> Any? {
        guard let name = name else { return nil }
        
        return dataManager.deleteData(storeData: StoreDataType.teams, id: nil, name: name)
    }
    
    func getTeam(name: String?) -> Team? {
        guard let name = name else { return nil }
        
        let team = dataManager.getDataByIdName(storeData: StoreDataType.teams, id: nil, name: name)
        return team as? Team
    }
    
    func getTeams(parameter: SortParameter?, stepName: String?) -> [Team]? {
        let teams = dataManager.getTeams()
        
        guard var teams = teams else {
            return nil
        }
        
        for i in 0..<teams.count {
            var score = 0
            
            if let participants = teams[i].participants {
                
                var participantScore = 0
                for j in 0..<participants.count {
                    let steps = getStepsByParticipant(id: teams[i].participants![j].id, stepName: stepName)

                    if let steps = steps {
                        for step in steps {
                            
                            let loots = getLootsByStep(id: step.id)
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
    
    
    func addCompetition(competition: Competition?, team: Team?) -> Any? {
        guard let competition = competition,
              let team = team else { return nil }

        return dataManager.addTo(firstTypeOfData: StoreDataType.competitions, firstEntity: competition, secondTypeOfData: StoreDataType.teams, secondEntity: team)
    }

    
    func getParticipantByTeam(id: Int?) -> [Participant]? {
        guard let id = id else { return nil }
        let participant = dataManager.getBy(firstTypeOfData: StoreDataType.teams, id: id, secondTypeOfData: StoreDataType.participants)
        return participant as? [Participant]
    }
    
    func addParticipant(participant: Participant?, team: Team?) -> Any? {
        guard let participant = participant,
              let team = team else { return nil }
        
        return dataManager.addTo(firstTypeOfData: StoreDataType.participants, firstEntity: participant, secondTypeOfData: StoreDataType.teams, secondEntity: team)
    }
    
    func getStepsByParticipant(id: Int?, stepName: String?) -> [Step]? {
        guard let id = id else {
            return nil
        }

        let steps: [Step]?
        if let stepName = stepName {
            steps = dataManager.stepsWithParticipantIdWithStepName(id: id, stepName: stepName)
        } else {
            steps = dataManager.stepsWithParticipantId(id: id)
        }
        
        return steps
    }
    
    
    func getLootsByStep(id: Int?) -> [Loot]? {
        guard let id = id else {
            return nil
        }

        let loots = dataManager.lootsWithSteptId(id: id)
        
        return loots
    }
}
