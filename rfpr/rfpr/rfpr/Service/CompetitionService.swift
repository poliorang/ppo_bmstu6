//
//  CompetitionService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class CompetitionService: ICompetitionService {
    
    let competitionRepository: ICompetitionRepository?
    let stepToCompetitionRepository: IStepToCompetitionRepository?
    
    init(competitionRepository: ICompetitionRepository,
         stepToCompetitionRepository: IStepToCompetitionRepository) {
        self.competitionRepository = competitionRepository
        self.stepToCompetitionRepository = stepToCompetitionRepository
    }
    
    func createCompetition(id: String?, name: String?, teams: [Team]?) throws -> Competition {
        guard let name = name else {
                  throw ParameterError.funcParameterError
        }
        
        let competition = Competition(id: id, name: name, teams: teams)
        let createdCompetition: Competition?
        
        do {
            createdCompetition = try competitionRepository?.createCompetition(competition: competition)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdCompetition = createdCompetition else {
            throw DatabaseError.addError
        }
        
        return createdCompetition
    }
    
    func deleteCompetition(competition: Competition?) throws {
        guard let competition = competition else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try competitionRepository?.deleteCompetition(competition: competition)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getCompetition(name: String?) throws -> [Competition]? {
        guard let name = name else {
            throw ParameterError.funcParameterError
        }
        
        let competitions: [Competition]?
        do {
            try competitions = competitionRepository?.getCompetitions()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        guard let competitions = competitions else {
            return nil
        }
        
        var resultCompetitions = [Competition]()
        
        for competition in competitions {
            if competition.name.contains(name) {
                resultCompetitions.append(competition)
            }
        }
        
        return resultCompetitions.isEmpty ? nil : resultCompetitions
    }
    
    func getCompetitions() throws -> [Competition]? {
        let competitions: [Competition]?
        do {
            try competitions = competitionRepository?.getCompetitions()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        return competitions
    }
    
    func addStep(step: Step?, competition: Competition?) throws {
        guard let step = step,
              let competition = competition else {
                  throw ParameterError.funcParameterError
        }
        
        do {
            try stepToCompetitionRepository?.addStep(step: step, competition: competition)
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
    }
}
