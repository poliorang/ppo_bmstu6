//
//  StepRepository.swift
//  rfpr
//
//  Created by poliorang on 14.04.2023.
//

import Foundation
import RealmSwift

class StepRepository: IStepRepository, ILootToStepRepository, IStepByParticipantRepository {
  
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
            realmStep = try step.convertStepToRealm(realm)
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
    
    func deleteStep(step: Step) throws {
        let realmStep = try step.convertStepToRealm(realm)
        
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
        let realmStep = try step.convertStepToRealm(realm)
        let realmLoot = try loot.convertLootToRealm(realm)
        
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
        let realmLoot = try loot.convertLootToRealm(realm)
        
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
    
    func getStepByParticipant(participant: Participant) throws -> [Step]? {
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
    
    func getStepByCompetition(competition: Competition) throws -> [Step]? {
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
    
    func addParticipant(participant: Participant, step: Step) throws {
        let realmStep = try step.convertStepToRealm(realm)
        let realmParticipant = try participant.convertParticipantToRealm(realm)
        
        let stepsFromDB = realm.objects(StepRealm.self)
        var stepFromDB: StepRealm? = nil
        
        for step in stepsFromDB {
            if step._id == realmStep._id {
                stepFromDB = step
                break
            }
        }
        
        guard let stepFromDB = stepFromDB else {
            throw ParameterError.funcParameterError
        }
        
        let participantsFromDB = realm.objects(ParticipantRealm.self)
        var participantFromDB: ParticipantRealm? = nil
        
        for participant in participantsFromDB {
            if participant._id == realmParticipant._id {
                participantFromDB = participant
                break
            }
        }
        
        guard let participantFromDB = participantFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                stepFromDB.participant = participantFromDB
                realm.add(stepFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getSteps() throws -> [Step]? {
        let stepsRealm = realm.objects(StepRealm.self)
        var steps = [Step]()
        
        for step in stepsRealm {
            steps.append(step.convertStepFromRealm())
        }

        return steps.isEmpty ? nil : steps
    }
}
