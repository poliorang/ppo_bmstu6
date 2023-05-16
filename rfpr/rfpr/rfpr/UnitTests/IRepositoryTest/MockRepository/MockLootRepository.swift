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
    private let step = Step(id: "1", name: "A", participant: nil, competition: nil, score: 1000)
    private var loot1 = Loot(id: "2", fish: "Щука", weight: 500, step: nil, score: 1000)
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
        db.append(loot)
        
        var loots = [Loot]()
        for loot in db {
            loots.append(loot)
        }
        
        return loots.isEmpty ? nil : loots
    }
    
    func getLootByStep(step: Step) throws -> [Loot]? {
        loot1.step = step
        db.append(loot1)
        db.append(loot)
        
        let loots = try! getLoots()
        var resultLoots = [Loot]()
        if let loots = loots {
            for loot in loots {
                if loot.step == step {
                    resultLoots.append(loot)
                }
            }
        }
        
        return resultLoots
    }
}

