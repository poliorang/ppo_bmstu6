//
//  CompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class MockCompetitionRepository: ICompetitionRepository, IStepToCompetitionRepository,
                                 ITeamToCompetitionRepository {
  
    var dataManager: IDataManager
    
    init() {
        self.dataManager = MockDataManager()
    }
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    func createCompetition(id: Int?, name: String?, teams: [Team]?) -> Competition? {
        let competition = dataManager.createCompetition(id: id, name: name, teams: teams)
        return competition
    }
    
    func getCompetition(id: Int?) -> Competition? {
        guard let id = id else { return nil }
        let competitions = dataManager.getDataByIdName(storeData: StoreDataType.competitions, id: id, name: nil)
        return competitions as? Competition
    }
    
    func updateCompetition(name: String?, competition: Competition?) -> Any? {
        guard let name = name,
              let competition = competition else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.competitions, id: nil, entry: competition, name: name)
    }
    
    func deleteCompetition(name: String?) -> Any? {
        guard let name = name else { return nil }
        
        return dataManager.deleteData(storeData: StoreDataType.competitions, id: nil, name: name)
    }
    
    
    func addStep(step: Step?, competition: Competition?) -> Any? {
        guard let step = step,
              let competition = competition else { return nil }
        
        return dataManager.addTo(firstTypeOfData: StoreDataType.steps, firstEntity: step, secondTypeOfData: StoreDataType.competitions, secondEntity: competition)
    }
    
    
    func addTeam(team: Team?, competition: Competition?) -> Any? {
        guard let team = team,
              let competition = competition else { return nil }
        
        return dataManager.addTo(firstTypeOfData: StoreDataType.teams, firstEntity: team, secondTypeOfData: StoreDataType.competitions, secondEntity: competition)
    }
}
