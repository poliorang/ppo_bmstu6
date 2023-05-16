//
//  LootRepository.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//
import Foundation
import RealmSwift

class LootRepository: ILootRepository, ILootByStepRepository {
    
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
    
    func getLoot(id: String) throws -> Loot? {
        let id = try ObjectId.init(string: id)
    
        let findedLoot = realm.objects(LootRealm.self).where {
            $0._id == id
        }.first

        if let findedLoot = findedLoot {
            return findedLoot.convertLootFromRealm()
        }
        
        return nil
    }
    
    func createLoot(loot: Loot) throws -> Loot? {
        let realmLoot: LootRealm
        
        do {
            realmLoot = try loot.convertLootToRealm(realm)
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmLoot)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdLoot = try getLoot(id: "\(realmLoot._id)")
        
        do {
            let loot = try createdLoot?.convertLootToRealm(realm)
            try triggerLootToStep(loot)
        } catch {
            throw DatabaseError.triggerError
        }
        
        return createdLoot
    }
    
    func updateLoot(previousLoot: Loot, newLoot: Loot) throws -> Loot? {
        var newLoot = newLoot
        newLoot.id = nil
        
        let realmPreviousLoot = try previousLoot.convertLootToRealm(realm)
        let realmNewLoot = try newLoot.convertLootToRealm(realm)
        
        let lootFromDB = realm.objects(LootRealm.self).where {
            $0._id == realmPreviousLoot._id
        }.first
        
        guard lootFromDB != nil else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realmNewLoot._id = realmPreviousLoot._id
                realm.add(realmNewLoot, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedLoot = try getLoot(id: "\(realmNewLoot._id)")
        
        do {
            let loot = try updatedLoot?.convertLootToRealm(realm)
            try triggerLootToStep(loot)
        } catch {
            throw DatabaseError.triggerError
        }
        
        return updatedLoot
    }
    
    func deleteLoot(loot: Loot) throws {
        let realmLoot = try loot.convertLootToRealm(realm)
        
        let lootFromDB = realm.objects(LootRealm.self).where {
            $0._id == realmLoot._id
        }.first
        
        guard let lootFromDB = lootFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.delete(lootFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }

        do {
            let deletedLoot = try loot.convertLootToRealm(realm)
            try triggerLootToStep(deletedLoot)
        } catch {
            throw DatabaseError.triggerError
        }
    }
    
    func getLoots() throws -> [Loot]? {
        let lootsRealm = realm.objects(LootRealm.self)
        var loots = [Loot]()
        
        for loot in lootsRealm {
            loots.append(loot.convertLootFromRealm())
        }

        return loots.isEmpty ? nil : loots
    }
    
    func getLootByStep(step: Step) throws -> [Loot]? {
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

extension LootRepository {
    func updateStepScore(_ step: StepRealm) throws {
        let lootsRealm = realm.objects(LootRealm.self)
        
        var newScore = 0
        for loot in lootsRealm {
            if loot.step == step {
                newScore += loot.score
            }
        }
        
        let id = "\(step._id)"
        let newStep = StepRealm(id: id, name: step.name, participant: step.participant, competition: step.competition, score: newScore)
        
        do {
            try realm.write {
                realm.add(newStep, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func updateParticipantScore(_ participant: ParticipantRealm) throws {
        let stepsRealm = realm.objects(StepRealm.self)
        
        var newScore = 0
        for step in stepsRealm {
            if step.participant == participant {
                newScore += step.score
            }
        }
        
        let id = "\(participant._id)"
        let newParticipant = ParticipantRealm(id: id, lastName: participant.lastName, firstName: participant.firstName, patronymic: participant.patronymic, team: participant.team, city: participant.city, birthday: participant.birthday, score: newScore)
        
        do {
            try realm.write {
                realm.add(newParticipant, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func triggerLootToStep(_ loot: LootRealm?) throws {
        let stepsRealm = realm.objects(StepRealm.self)

        for step in stepsRealm {
            do {
                try updateStepScore(step)
            } catch {
                throw DatabaseError.updateError
            }
        }
    }
}


