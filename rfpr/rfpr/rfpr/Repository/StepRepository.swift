//
//  StepRepository.swift
//  rfpr
//
//  Created by poliorang on 14.04.2023.
//

import Foundation
import RealmSwift

class StepRepository: IStepRepository, ILootToStepRepository {    

    let realm: Realm!
    var config: Realm.Configuration!
    init(configRealm: String) throws {
        do {
            config = Realm.Configuration.defaultConfiguration
            config.fileURL!.deleteLastPathComponent()
            config.fileURL!.appendPathComponent("\(configRealm).realm")
            
            self.realm = try Realm(configuration: config)
        } catch {
            throw ConnectionError.realmConnectError
        }
    }
    
    func realmDeleteAll() throws {
        do {
            try realm.write {
              realm.deleteAll()
            }
        } catch {
            throw DatabaseError.deleteAllError
        }
    }
    
    func getStep(id: String) throws -> Step? {
        let id = try ObjectId.init(string: id)
    
        let findedStep = realm.objects(StepRealm.self).where {
            $0._id == id
        }.first

        if let findedStep = findedStep {
            return findedStep.convertStepFromRealm()
        }
        
        return nil
    }
    
    func createStep(step: Step) throws -> Step? {
        let realmStep: StepRealm
        
        do {
            realmStep = try step.convertStepToRealm()
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmStep)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdStep = try getStep(id: "\(realmStep._id)")
        
        return createdStep
    }
    
    func updateStep(previousStep: Step, newStep: Step) throws -> Step? {
        var newStep = newStep
        newStep.id = previousStep.id
        
        let realmPreviousStep = try previousStep.convertStepToRealm()
        let realmNewStep = try newStep.convertStepToRealm()
        
        let stepFromDB = realm.objects(StepRealm.self).where {
            $0._id == realmPreviousStep._id
        }.first
        
        guard let _ = stepFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewStep, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedStep = try getStep(id: "\(realmNewStep._id)")

        return updatedStep
    }
    
    func deleteStep(step: Step) throws {
        let realmStep = try step.convertStepToRealm()
        
        let stepFromDB = realm.objects(StepRealm.self).where {
            $0._id == realmStep._id
        }.first
        
        guard let stepFromDB = stepFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.delete(stepFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    
    func addLoot(loot: Loot, step: Step) throws {
        let realmStep = try step.convertStepToRealm()
        let realmLoot = try loot.convertLootToRealm()
        
        let stepFromDB = realm.objects(StepRealm.self).where {
            $0._id == realmStep._id
        }.first
        
        guard let stepFromDB = stepFromDB else {
            throw ParameterError.funcParameterError
        }
        
        let lootFromDB = realm.objects(LootRealm.self).where {
            $0._id == realmLoot._id
        }.first
        
        guard let lootFromDB = lootFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                lootFromDB.step = stepFromDB
                realm.add(lootFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func deleteLoot(loot: Loot, step: Step) throws {
        let realmLoot = try loot.convertLootToRealm()
        
        let lootFromDB = realm.objects(LootRealm.self).where {
            $0._id == realmLoot._id
        }.first
        
        guard let lootFromDB = lootFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                lootFromDB.step = nil
                realm.add(lootFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
}
