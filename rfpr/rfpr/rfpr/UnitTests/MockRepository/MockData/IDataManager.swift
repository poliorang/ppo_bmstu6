//
//  IDataManager.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

import Foundation

enum StoreDataType {
    case participants
    case teams
    case competitions
    case steps
    case loots
}

protocol IDataManager {
    func createLoot(id: Int?, fish: String?, weight: Int?, score: Int?, step: Step?) -> Loot?
    func createStep(id: Int?, name: String?, participant: Participant?, competition: Competition?) -> Step?
    func createCompetition(id: Int?, name: String?, teams: [Team]?) -> Competition? 
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team?
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant?
    
    
    func getData(storeData: StoreDataType) -> [Any]?
    func getDataByIdName(storeData: StoreDataType, id: Int?, name: String?) -> Any?
    
    func updateData(storeData: StoreDataType, id: Int?, name: String?) -> Any?
    func deleteData(storeData: StoreDataType, id: Int?, name: String?) -> Any?

    func addTo(firstTypeOfData: StoreDataType, firstEntity: Any?,
               secondTypeOfData: StoreDataType, secondEntity: Any?) -> Any?
    func deleteFrom(firstTypeOfData: StoreDataType, firstEntity: Any?,
                    secondTypeOfData: StoreDataType, secondEntity: Any?) -> Any?
    
    func getBy(firstTypeOfData: StoreDataType, id: Int?, secondTypeOfData: StoreDataType) -> [Any]?
    
    func stepsWithParticipantId(id: Int) -> [Step]?
    func stepsWithParticipantIdWithStepName(id: Int, stepName: String) -> [Step]?
    func lootsWithSteptId(id: Int) -> [Loot]?
    func getParticipants() -> [Participant]?
    func getTeams() -> [Team]?
    
}
