//
//  Repository.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

import Foundation
var bith = Date()

class MockLootRepository: ILootRepository, ILootByStepRepository {


    private let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
    private var db = [Loot]()
    
    func createLoot(loot newLoot: Loot) throws -> Loot? {
        db.append(newLoot)
        if db.contains(newLoot) == false {
            throw DatabaseError.addError
        }
        
        return newLoot
    }
    
    func updateLoot(previousLoot: Loot, newLoot: Loot) throws -> Loot? {
        db.append(loot)
        
        if let index = db.firstIndex(where: { $0 == previousLoot }) {
            db.remove(at: index)
            db.append(newLoot)
        } else {
            throw DatabaseError.updateError
        }
        
        return newLoot
    }
    
    func deleteLoot(loot removeLoot:Loot) throws {
        db.append(loot)
        
        if let index = db.firstIndex(where: { $0 == removeLoot }) {
            db.remove(at: index)
        } else {
            throw DatabaseError.deleteError
        }
    }
    
    func getScore(weight: Int?) -> Int? {
        if let weight = weight {
             return weight + 500
        }
        
        return nil
    }
    
    func getLoots() throws -> [Loot]? {
        return nil
    }
    
    func getLootByStep(step: Step) throws -> [Loot]? {
        return nil
    }
}

