//
//  StepRepository.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

class MockStepRepository: IStepRepository, ILootToStepRepository {
   
    var dataManager: IDataManager
    
    init() {
        self.dataManager = MockDataManager()
    }
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    
    func createStep(id: Int?, name: String?, participant: Participant?, competition: Competition?) -> Step? {
        guard let id = id,
              let name = name else { return nil }
        
        let step = dataManager.createStep(id: id, name: name, participant: participant, competition: competition)
        return step 
    }
    
    func updateStep(id: Int?, step: Step?) -> Any? {
        guard let id = id,
              let step = step else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.steps, id: id, entry: step, name: nil)
    }
    
    func deleteStep(id: Int?) -> Any? {
        guard let id = id else { return nil }
        
        return dataManager.deleteData(storeData: StoreDataType.steps, id: id, name: nil)
    }
    
    func addLoot(loot: Loot?, step: Step?) -> Any? {
        guard let loot = loot,
              let step = step else { return nil }
        
        return dataManager.addTo(firstTypeOfData: StoreDataType.loots, firstEntity: loot, secondTypeOfData: StoreDataType.steps, secondEntity: step)
    }
    
    func deleteLoot(loot: Loot?, step: Step?) -> Any? {
        guard let loot = loot,
              let step = step else { return nil }
        
        return dataManager.deleteFrom(firstTypeOfData: StoreDataType.loots, firstEntity: loot, secondTypeOfData: StoreDataType.steps, secondEntity: step)
    }
}

