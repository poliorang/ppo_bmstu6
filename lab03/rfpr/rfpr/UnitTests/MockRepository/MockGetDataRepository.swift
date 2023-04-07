//
//  MockGetDataRepository.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//

class MockGetDataRepository: IGetDataRepository {
    var dataManager: IDataManager
    
    init() {
        self.dataManager = MockDataManager()
    }
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    func stepsWithParticipantIdWithStepName(id: Int, stepName: String) -> [Step]? {
        return dataManager.stepsWithParticipantIdWithStepName(id: id, stepName: stepName)
    }
    
    func stepsWithParticipantId(id: Int) -> [Step]? {
        return dataManager.stepsWithParticipantId(id: id)
    }
    
    func lootsWithSteptId(id: Int) -> [Loot]? {
        return dataManager.lootsWithSteptId(id: id)
    }
}
