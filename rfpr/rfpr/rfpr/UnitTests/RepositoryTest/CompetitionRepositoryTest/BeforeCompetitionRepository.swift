//
//  BeforeCompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 22.04.2023.
//

class BeforeCompetitionRepositoryTest {
    var competitionRepository: CompetitionRepository!
    var stepRepository: StepRepository!
    var teamRepository: TeamRepository!
    
    func setupRepository(config: String) throws {
        do {
            teamRepository = try TeamRepository(configRealm: config)
            competitionRepository = try CompetitionRepository(configRealm: config)
            stepRepository = try StepRepository(configRealm: config)
            
            try teamRepository.realmDeleteAll()
            try competitionRepository.realmDeleteAll()
            try stepRepository.realmDeleteAll()
        } catch {
            print("Не удалось открыть Realm: \(config)")
            throw DatabaseError.openError
        }
    }
    
    func createData() throws {
        let step = Step(id: "6442852b2b74d595cb4f4756", name: "Add competition", score: 0)

//        let сompetitionUpdate = Competition(id: "6442852b2b74d595cb4f4760", name: "Update", teams: nil)
        let competitionDelete = Competition(id: "6442852b2b74d595cb4f4764", name: "Delete", teams: nil)
        let competitionAddStep = Competition(id: "6442852b2b74d595cb4f4768", name: "Add", teams: nil)
        let competitionAddTeam = Competition(id: "6442852b2b74d595cb4f4772", name: "Added Team", teams: nil)
        
        let team = Team(id: "6442852b2b74d595cb4f4776", name: "Add Competition", competitions: nil, score: 0)
        
        do {
            try [step].forEach {
                try _ = stepRepository.createStep(step: $0)
                
            }
            try [competitionDelete, competitionAddStep, competitionAddTeam].forEach {
                try _ = competitionRepository.createCompetition(competition: $0)
            }
            try [team].forEach {
                try _ = teamRepository.createTeam(team: $0)
            }
        } catch {
                throw DatabaseError.addError
        }
    }
    
}
