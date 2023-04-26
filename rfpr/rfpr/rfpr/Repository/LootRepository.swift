//
//  LootRepository.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//
import Foundation
import RealmSwift

class LootRepository: ILootRepository {
    
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
            realmLoot = try loot.convertLootToRealm()
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
        
        return createdLoot
    }
    
    func updateLoot(previousLoot: Loot, newLoot: Loot) throws -> Loot? {
        var newLoot = newLoot
        newLoot.id = previousLoot.id
        
        let realmPreviousLoot = try previousLoot.convertLootToRealm()
        let realmNewLoot = try newLoot.convertLootToRealm()
        
        let lootFromDB = realm.objects(LootRealm.self).where {
            $0._id == realmPreviousLoot._id
        }.first
        
        guard let _ = lootFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewLoot, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedLoot = try getLoot(id: "\(realmNewLoot._id)")

        return updatedLoot
    }
    
    func deleteLoot(loot: Loot) throws {
        let realmLoot = try loot.convertLootToRealm()
        
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
    }
}
