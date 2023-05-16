//
//  StepService.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

class StepService: IStepService {

    let stepRepository: IStepRepository?
    
    let stepByParticipantRepository: IStepByParticipantRepository?
    let lootToStepRepository: ILootToStepRepository?
    
    init(stepRepository: IStepRepository,
         stepByParticipantRepository: IStepByParticipantRepository,
         lootToStepRepository: ILootToStepRepository) {
        self.stepRepository = stepRepository
        self.stepByParticipantRepository = stepByParticipantRepository
        self.lootToStepRepository = lootToStepRepository
    }
    
    func createStep(id: String?, name: String?, participant: Participant?, competition: Competition?) throws -> Step {
        guard let name = name else {
                  throw ParameterError.funcParameterError
        }
        
        let step = Step(id: id, name: name, participant: participant, competition: competition, score: 0)
        let createdStep: Step?
        
        do {
            createdStep = try stepRepository?.createStep(step: step)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdStep = createdStep else {
            throw DatabaseError.addError
        }
        
        return createdStep
    }
    
    func deleteStep(step: Step?) throws {
        guard let step = step else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try stepRepository?.deleteStep(step: step)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getStepByParticipant(participant: Participant?) throws -> [Step]?  {
        guard let participant = participant else {
            throw ParameterError.funcParameterError
        }
        
        let steps: [Step]?
        do {
            steps = try stepByParticipantRepository?.getStepByParticipant(participant: participant)
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        return steps
    }
    
    func getStepByName(stepName: String?) throws -> [Step]? {
        guard let stepName = stepName else {
            throw ParameterError.funcParameterError
        }
        
        let steps: [Step]?
        
        do {
            steps = try stepRepository?.getSteps()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        guard let steps = steps else {
            return nil
        }
        
        var resultSteps = [Step]()
        for step in steps {
            if step.name == stepName {
                resultSteps.append(step)
            }
        }
        
        return resultSteps.isEmpty ? nil : resultSteps
    }
    
    func getStepByCompetition(competition: Competition?) throws -> [Step]? {
        guard let competition = competition else {
            throw ParameterError.funcParameterError
        }
        
        let steps: [Step]?
        do {
            steps = try stepRepository?.getStepByCompetition(competition: competition)
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        return steps
    }
    
    func addParticipant(participant: Participant?, step: Step?) throws {
        guard let participant = participant,
              let step = step else {
                  throw ParameterError.funcParameterError
        }
        
        try stepRepository?.addParticipant(participant: participant, step: step)
    }
    
    func addLoot(loot: Loot?, step: Step?) throws {
        guard let loot = loot,
              let step = step else {
                  throw ParameterError.funcParameterError
        }
        
        do {
            try lootToStepRepository?.addLoot(loot: loot, step: step)
        } catch {
            throw DatabaseError.addError
        }
    }
    
    func deleteLoot(loot: Loot?, step: Step?) throws {
        guard let loot = loot,
              let step = step else {
                  throw ParameterError.funcParameterError
        }
        
        do {
            try lootToStepRepository?.deleteLoot(loot: loot, step: step)
        } catch {
            throw DatabaseError.deleteError
        }
    }
}

