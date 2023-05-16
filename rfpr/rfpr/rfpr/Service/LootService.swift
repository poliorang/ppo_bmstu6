//
//  LootService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

class LootService: ILootService {

    let lootRepository: ILootRepository?
    let lootByStepRepository: ILootByStepRepository?
    
    init(lootRepository: ILootRepository,
         lootByStepRepository: ILootByStepRepository) {
        self.lootRepository = lootRepository
        self.lootByStepRepository = lootByStepRepository
    }
    
    func createLoot(id: String?, fish: String?, step: Step?, weight: Int?) throws -> Loot {
        guard let fish = fish,
              let weight = weight else {
                  throw ParameterError.funcParameterError
        }
        
        let loot = Loot(id: id, fish: fish, weight: weight, step: step, score: getScore(weight: weight))
        let createdLoot: Loot?
        
        do {
            createdLoot = try lootRepository?.createLoot(loot: loot)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdLoot = createdLoot else {
            throw DatabaseError.addError
        }
        
        return createdLoot
    }
    
    func updateLoot(previousLoot: Loot?, newLoot: Loot?) throws -> Loot {
        guard let previousLoot = previousLoot,
              let newLoot = newLoot else {
                  throw ParameterError.funcParameterError
        }
        
        let updatedLoot: Loot?
        do {
            updatedLoot = try lootRepository?.updateLoot(previousLoot: previousLoot, newLoot: newLoot)
        } catch DatabaseError.updateError {
            throw DatabaseError.updateError
        }
        
        guard let updatedLoot = updatedLoot else {
            throw DatabaseError.updateError
        }
        
        return updatedLoot
    }
    
    func deleteLoot(loot: Loot?) throws {
        guard let loot = loot else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try lootRepository?.deleteLoot(loot: loot)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getLootByStep(step: Step?) throws -> [Loot]? {
        guard let step = step else {
            throw ParameterError.funcParameterError
        }
        
        let loots: [Loot]?
        do {
            loots = try lootByStepRepository?.getLootByStep(step: step)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
        
        return loots
    }
    
    func getLoot(fishName: String?, score: Int?) throws -> Loot? {
        guard let fishName = fishName,
              let score = score else {
                  throw ParameterError.funcParameterError
        }
        
        let loots: [Loot]?
        do {
            try loots = lootRepository?.getLoots()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        
        guard let loots = loots else {
            throw DatabaseError.getError
        }
        
        for loot in loots {
            if loot.fish == fishName && loot.score == score {
                return loot
            }
        }
        
        return nil
    }
    
    func getLoots() throws -> [Loot]? {
        let loots: [Loot]?
        do {
            try loots = lootRepository?.getLoots()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        return loots
    }
    
    func getScore(weight: Int) -> Int {
        return weight + 500
    }
}
