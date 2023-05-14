//
//  LootExtencion.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import RealmSwift

extension Loot {
    func convertLootToRealm(_ realm: Realm) throws -> LootRealm {
        // проверка, что уже есть в бд
        var lootFromDB: LootRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            lootFromDB = realm.objects(LootRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let lootFromDB = lootFromDB {
            return lootFromDB
        }
        
        do {
            return try LootRealm(id: self.id, fish: self.fish, weight: self.weight, step: self.step?.convertStepToRealm(realm), score: self.score)
        } catch {
            throw DatabaseError.addError
        }
    }
}
