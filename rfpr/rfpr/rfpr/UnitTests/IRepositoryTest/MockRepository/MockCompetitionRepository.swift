//
//  CompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class MockCompetitionRepository: ICompetitionRepository, IStepToCompetitionRepository {

    private let competition1 = Competition(id: "1", name: "Урал", teams: nil)
    private let competition2 = Competition(id: "1", name: "Урал-Юг", teams: nil)
    private let competition3 = Competition(id: "1", name: "Байкал", teams: nil)
    
    private var dbCompetition = [Competition]()
    
    private let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
    private var dbStep = [Step]()
    
    private let team = Team(id: "1", name: "Увильды", competitions: nil, score: 0)
    private var dbTeam = [Team]()
    
    func createCompetition(competition: Competition) throws -> Competition? {
        dbCompetition.append(competition)
        if dbCompetition.contains(competition) == false {
            throw DatabaseError.addError
        }
        
        return competition
    }
    
    func deleteCompetition(competition removeCompetition: Competition) throws {
        dbCompetition.append(competition1)
        
        if let index = dbCompetition.firstIndex(where: { $0 == removeCompetition }) {
            dbCompetition.remove(at: index)
        } else {
            throw DatabaseError.deleteError
        }
    }
    
    func getCompetitions() throws -> [Competition]? {
        [competition1, competition2, competition3].forEach {
            dbCompetition.append($0)
        }
        
        let competition = dbCompetition
        if competition.isEmpty == false {
            return competition
        } else {
            throw DatabaseError.deleteError
        }
    }
    
    func addStep(step newStep: Step, competition newCompetition: Competition) throws {
        dbStep.append(step)
        dbCompetition.append(competition1)
        
        if let indexStep = dbStep.firstIndex(where: { $0 == newStep }) {
            if let indexCompetition = dbCompetition.firstIndex(where: { $0 == newCompetition }) {
                dbStep[indexStep].competition = dbCompetition[indexCompetition]
            } else {
                throw DatabaseError.addError
            }
        } else {
            throw DatabaseError.addError
        }
    }
}
