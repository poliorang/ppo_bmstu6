//
//  ParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

class MockParticipantRepository: IParticipantRepository, ITeamByParticipantRepository {

    var dataManager: IDataManager
    
    init() {
        self.dataManager = MockDataManager()
    }
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant? {
        guard let id = id,
              let fullname = fullname,
              let city = city,
              let role = role else { return nil }
        
        let participant = dataManager.createParticipant(id: id, fullname: fullname, city: city, birthday: birthday, role: role, autorization: autorization, score: score)
        return participant
    }
    
    func updateParticipant(id: Int?) -> Any? {
        guard let id = id else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.participants, id: id, name: nil)
    }
    
    func deleteParticipant(id: Int?) -> Any? {
        guard let id = id else { return nil }
        
        return dataManager.deleteData(storeData: StoreDataType.participants, id: id, name: nil)
    }
    
    func getParticipant(id: Int?) -> Participant? {
        guard let id = id else { return nil }

        let participant = dataManager.getDataByIdName(storeData: StoreDataType.participants, id: id, name: nil)
        return participant as? Participant
    }
    
    
    func getParticipants(parameter: SortParameter?, stepName: String?) -> [Participant]? {
        
        let participants = dataManager.getParticipants()
        
        guard var participants = participants else {
            return nil
        }
        
        for i in 0..<participants.count {
            
            let steps = getStepsByParticipant(id: participants[i].id, stepName: stepName)
            
            var score = 0
            if let steps = steps {
                for step in steps {
                    
                    let loots = getLootsByStep(id: step.id)
                    if let loots = loots {
                        for loot in loots { score += loot.score }
                    }
                }
            }
            
            participants[i].score = score
        }
        
        if parameter == .ascending {
            return participants.sorted(by: { $0.score < $1.score })
        }
        
        if parameter == .decreasing {
            return participants.sorted(by: { $0.score > $1.score })
        }
        
        return participants
    }
    
    func getTeamByParticipant(id: Int?) -> [Team]? {
        guard let id = id else { return nil }
        
        let teams = dataManager.getBy(firstTypeOfData: StoreDataType.participants, id: id, secondTypeOfData: StoreDataType.teams)
        return teams as? [Team]
    }
    
    
    func getStepsByParticipant(id: Int?, stepName: String?) -> [Step]? {
        guard let id = id else {
            return nil
        }

        let steps: [Step]?
        if let stepName = stepName {
            steps = dataManager.stepsWithParticipantIdWithStepName(id: id, stepName: stepName)
        } else {
            steps = dataManager.stepsWithParticipantId(id: id)
        }
        
        return steps
    }
    
    
    func getLootsByStep(id: Int?) -> [Loot]? {
        guard let id = id else {
            return nil
        }

        let loots = dataManager.lootsWithSteptId(id: id)
        
        return loots
    }
                                                                                                                              
}
