//
//  StepRepository.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

class MockStepRepository: IStepRepository, ILootToStepRepository, IStepByParticipantRepository {
    private var step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
    private let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
    private let participant = Participant(id: "1", lastName: "a", firstName: "a", patronymic: nil, team: nil, city: "a", birthday: bith, score: 0)
    private let competition = Competition(id: "1", name: "aaa", teams: nil)
    
    private var dbSteps = [Step]()
    private var dbLoots = [Loot]()
    
    func createStep(step: Step) throws -> Step? {
        dbSteps.append(step)
        if dbSteps.contains(step) == false {
            throw DatabaseError.addError
        }
        
        return step
    }
    
    func updateStep(previousStep: Step, newStep: Step) throws -> Step? {
        dbSteps.append(step)
        
        if let index = dbSteps.firstIndex(where: { $0 == previousStep }) {
            dbSteps.remove(at: index)
            dbSteps.append(newStep)
        } else {
            throw DatabaseError.updateError
        }
        
        return newStep
    }
    
    func deleteStep(step removeStep: Step) throws {
        dbSteps.append(step)
        
        if let index = dbSteps.firstIndex(where: { $0 == removeStep }) {
            dbSteps.remove(at: index)
        } else {
            throw DatabaseError.deleteError
        }
    }
    
    func addLoot(loot newLoot: Loot, step newStep: Step) throws {
        dbSteps.append(step)
        dbLoots.append(loot)
        
        if let indexStep = dbSteps.firstIndex(where: { $0 == newStep }) {
            if let indexLoot = dbLoots.firstIndex(where: { $0 == newLoot }) {
                dbLoots[indexLoot].step = newStep
            } else {
                var newLoot = newLoot
                newLoot.step = dbSteps[indexStep]
                dbLoots.append(newLoot)
            }
        } else {
            throw DatabaseError.addError
        }
    }
    
    func deleteLoot(loot newLoot: Loot, step newStep: Step) throws {
        dbSteps.append(step)
        dbLoots.append(loot)
        
        if let indexLoot = dbLoots.firstIndex(where: { $0 == newLoot }) {
            dbLoots[indexLoot].step = nil
        } else {
            throw DatabaseError.addError
        }
    }
    
    func getSteps() throws -> [Step]? {
        dbSteps.append(step)
        
        var steps = [Step]()
        for step in dbSteps {
            steps.append(step)
        }
        
        return steps.isEmpty ? nil : steps
    }
   
    func getStepByCompetition(competition: Competition) throws -> [Step]? {
        step.competition = competition
        
        let steps = try! getSteps()
        
        var resultSteps = [Step]()
        if let steps = steps {
            for step in steps {
                if step.competition == competition {
                    resultSteps.append(step)
                }
            }
        }
        
        return resultSteps.isEmpty ? nil : resultSteps
    }
    
    func getStepByParticipant(participant: Participant) throws -> [Step]? {
        step.participant = participant
        
        let steps = try! getSteps()
        
        var resultSteps = [Step]()
        if let steps = steps {
            for step in steps {
                if step.participant == participant {
                    resultSteps.append(step)
                }
            }
        }
        
        return resultSteps
    }
    
    func addParticipant(participant: Participant, step: Step) throws {
        var step = step
        step.participant = participant
    }
}
