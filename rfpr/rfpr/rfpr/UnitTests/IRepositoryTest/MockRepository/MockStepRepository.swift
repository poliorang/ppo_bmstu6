//
//  StepRepository.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

class MockStepRepository: IStepRepository, ILootToStepRepository {
    
    private let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil)
    private let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
    
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
}

