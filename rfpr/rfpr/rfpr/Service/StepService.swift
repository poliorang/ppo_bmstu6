//
//  StepService.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

class StepService: IStepService {

    let stepRepository: IStepRepository?
    
    init(stepRepository: IStepRepository) {
        self.stepRepository = stepRepository
    }
    
    func createStep(id: String?, name: String?, participant: Participant?, competition: Competition?) throws -> Step {
        guard let name = name else {
                  throw ParameterError.funcParameterError
        }
        
        let step = Step(id: id, name: name, participant: participant, competition: competition)
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
    
    func updateStep(previousStep: Step?, newStep: Step?) throws -> Step {
        guard let previousStep = previousStep,
              let newStep = newStep else {
                  throw ParameterError.funcParameterError
        }
        
        let updatedStep: Step?
        do {
            updatedStep = try stepRepository?.updateStep(previousStep: previousStep, newStep: newStep)
        } catch DatabaseError.updateError {
            throw DatabaseError.updateError
        }
        
        guard let updatedStep = updatedStep else {
            throw DatabaseError.updateError
        }
        
        return updatedStep
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
}

