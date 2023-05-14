//
//  BeforeStepRepository.swift
//  rfpr
//
//  Created by poliorang on 22.04.2023.
//

class BeforeStepRepositoryTest {
    var lootRepository: LootRepository!
    var stepRepository: StepRepository!
    
    func setupRepository(config: String) throws {
        do {
            stepRepository = try StepRepository(configRealm: config)
            lootRepository = try LootRepository(configRealm: config)
            
            try stepRepository.realmDeleteAll()
            try lootRepository.realmDeleteAll()
        } catch {
            print("Не удалось открыть Realm: \(config)")
            throw DatabaseError.openError
        }
    }
    
    func createData() throws {
        let stepUpdate = Step(id: "6442852b2b74d595cb4f4164", name: "Третий день", participant: nil, competition: nil, score: 0)
        let stepDelete = Step(id: "6442852b2b74d595cb4f4768", name: "Пятый день", participant: nil, competition: nil, score: 0)
        let stepAddLoot = Step(id: "6442852b2b74d595cb4f4772", name: "A день", participant: nil, competition: nil, score: 0)
        let stepUpdateLoot = Step(id: "6442852b2b74d595cb4f4776", name: "U день", participant: nil, competition: nil, score: 0)
        let stepDeleteLoot = Step(id: "6442852b2b74d595cb4f4780", name: "D день", participant: nil, competition: nil, score: 0)

        let lootAdd = Loot(id: "6442852b2b74d595cb4f4784", fish: "Осетр", weight: 350, score: 850)
        let lootDelete = Loot(id: "6442852b2b74d595cb4f4768", fish: "Щука", weight: 350, score: 850)
        
        do {
            try [stepUpdate, stepDelete, stepAddLoot, stepUpdateLoot, stepDeleteLoot].forEach {
                try _ = stepRepository.createStep(step: $0)
            }
            
            try [lootAdd, lootDelete].forEach {
                try _ = lootRepository.createLoot(loot: $0)
            }
        } catch {
                throw DatabaseError.addError
        }
    }
    
}

