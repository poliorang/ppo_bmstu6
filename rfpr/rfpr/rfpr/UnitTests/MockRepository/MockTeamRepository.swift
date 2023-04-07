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
    
    func updateTeam(name: String?, team: Team?) -> Any? {
        guard let name = name,
              let team = team else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.teams, id: nil, entry: team, name: name)
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
    
    func getTeams() -> [Team]? {
        return dataManager.getTeams()
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
}
