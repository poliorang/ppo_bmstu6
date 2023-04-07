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
    
    func updateParticipant(id: Int?, participant: Participant?) -> Any? {
        guard let id = id,
              let participant = participant else { return nil }
        
        return dataManager.updateData(storeData: StoreDataType.participants, id: id, entry: participant, name: nil)
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
    
    func getParticipants() -> [Participant]? {
        return dataManager.getParticipants()
    }

    func getTeamByParticipant(id: Int?) -> [Team]? {
        guard let id = id else { return nil }
        
        let teams = dataManager.getBy(firstTypeOfData: StoreDataType.participants, id: id, secondTypeOfData: StoreDataType.teams)
        return teams as? [Team]
    }
}
