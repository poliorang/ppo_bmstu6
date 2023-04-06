//
//  CompetitionService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class CompetitionService: ICompetitionService {
    
    let competitionRepository: ICompetitionRepository?
    
    init(competitionRepository: ICompetitionRepository) {
        self.competitionRepository = competitionRepository
    }
    
    func createCompetition(id: Int?, name: String?, teams: [Team]?) -> Competition? {
        let competition = competitionRepository?.createCompetition(id: id, name: name, teams: teams)
        return competition
    }
    
    func getCompetition(id: Int?) -> Competition? {
        let competition = competitionRepository?.getCompetition(id: id)
        return competition
    }
    
    func updateCompetition(name: String?) {
        competitionRepository?.updateCompetition(name: name)
    }
    
    func deleteCompetition(name: String?) {
        competitionRepository?.deleteCompetition(name: name)
    }
}
