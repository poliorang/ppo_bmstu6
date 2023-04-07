//
//  Repository.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

import UIKit

class MockLootRepository: ILootRepository {
    
    var dataManager: IDataManager

    init() {
        self.dataManager = MockDataManager()
    }
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    func createLoot(id: Int?, fish: String?, weight: Int?, step: Step?) -> Loot? {
        guard let id = id,
              let fish = fish,
              let weight = weight else { return nil }
        
        let score = getScore(weight: weight)
        let loot = dataManager.createLoot(id: id, fish: fish, weight: weight, score: score, step: step)
        return loot
    }
    
    func updateLoot(id: Int?, loot: Loot?) -> Any? {
        guard let id = id,
              let loot = loot else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.loots, id: id, entry: loot, name: nil)
    }
    
    func deleteLoot(id: Int?) -> Any? {
        guard let id = id else { return nil }
        
        return dataManager.deleteData(storeData: StoreDataType.loots, id: id, name: nil)
    }
    
    func getScore(weight: Int?) -> Int? {
        if let weight = weight {
             return weight + 500
        }
        
        return nil
    }
}

