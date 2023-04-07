//
//  DataManager.swift
//  rfpr
//
//  Created by poliorang on 01.04.2023.
//

import Foundation

class MockDataManager: IDataManager {

    init() {  }
    
    func createLoot(id: Int?, fish: String?, weight: Int?, score: Int?, step: Step?) -> Loot? {
        guard let id = id,
              let fish = fish,
              let weight = weight,
              let score = score else { return nil }
        
        print("Data of loot type was created: \(fish), weight = \(weight)")
        return Loot(id: id, fish: fish, weight: weight, score: score, step: step)
    }
    
    func createStep(id: Int?, name: String?, participant: Participant?, competition: Competition?) -> Step? {
        guard let id = id,
              let name = name else { return nil }
        
        print("Data of step type was created: \(name)")
        return Step(id: id, name: name, participant: participant, competition: competition)
    }
    
    func createCompetition(id: Int?, name: String?, teams: [Team]?) -> Competition? {
        guard let id = id,
              let name = name else { return nil }
        
        print("Data of competition type was created: \(name)")
        return Competition(id: id, name: name, teams: teams)
    }
    
    func createTeam(id: Int?, name: String?, participants: [Participant]?, competitions: [Competition]?, score: Int) -> Team? {
        guard let id = id,
              let name = name else { return nil }
        
        print("Data of team type was created: \(name)")
        return Team(id: id, name: name, participants: participants, competitions: competitions, score: score)
        
    }
    
    func createParticipant(id: Int?, fullname: String?, city: String?, birthday: Date?, role: String?, autorization: Autorization?, score: Int) -> Participant? {
        guard let id = id,
              let fullname = fullname,
              let city = city,
              let role = role else { return nil }
        
        print("Data of participant type was created: \(fullname) from \(city)")
        return Participant(id: id, fullname: fullname, city: city, birthday: birthday, role: role, autorization: autorization, score: score)
    }
    
    
    func getParticipants() -> [Participant]? {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
        return participants
    }
    
    func getTeams() -> [Team]? {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 0),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 0),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 0)]
        
        return teams
    }
    
    
    func getData(storeData: StoreDataType) -> [Any]? {
        print("Data of \(storeData) type was received")
        
        return nil
    }
    
    func getDataByIdName(storeData: StoreDataType, id: Int?, name: String?) -> Any? {
        let competitions = [Competition(id: 1, name: "1", teams: nil),
                            Competition(id: 2, name: "2", teams: nil)]
       
        let teams = [Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0),
                     Team(id: 2, name: "2", participants: nil, competitions: nil, score: 0)]
        
        let participants = [Participant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0)]
        
        switch storeData {
        case .participants:
            return participants.first(where: { ($0).id == id })
        case .teams:
            return teams.first(where: { ($0).name == name })
        case .competitions:
            return competitions.first(where: { ($0).id == id })
        case .steps:
            return nil
        case .loots:
            return nil
        }
        
        return nil
    }
    
    func updateData(storeData: StoreDataType, id: Int?, entry: Any?, name: String?) -> Any? {
        
        return "Data of \(storeData) type was updated"
    }
    
    func deleteData(storeData: StoreDataType, id: Int?, name: String?) -> Any? {
        
        return "Data of \(storeData) type was deleted"
    }
    
    func deleteFrom(firstTypeOfData: StoreDataType, firstEntity: Any?,
                    secondTypeOfData: StoreDataType, secondEntity: Any?) -> Any? {
        return "\(firstTypeOfData) was deleted from \(secondTypeOfData)"
    }
    
    func addTo(firstTypeOfData: StoreDataType, firstEntity: Any?,
               secondTypeOfData: StoreDataType, secondEntity: Any?) -> Any? {
        return "\(firstTypeOfData) was added to \(secondTypeOfData)"
    }
    
    func getBy(firstTypeOfData: StoreDataType, id: Int?, secondTypeOfData: StoreDataType) -> [Any]? {
        let participants = [Participant(id: 1, fullname: "Иванов", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        let teams = [Team(id: 1, name: "1", participants: participants, competitions: nil, score: 0)]
        
        
        
        switch firstTypeOfData {
        case .participants:
            return nil
        case .teams:
            return teams.first(where: { ($0).id == id } )?.participants
        case .competitions:
            return nil
        case .steps:
            return nil
        case .loots:
            return nil
        }
    }
    
    func stepsWithParticipantId(id: Int) -> [Step]? {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
        let steps = [Step(id: 0, name: "1", participant: participants[0], competition: nil),
                     Step(id: 1, name: "1", participant: participants[1], competition: nil),
                     Step(id: 2, name: "1", participant: participants[2], competition: nil),
                     Step(id: 3, name: "2", participant: participants[0], competition: nil),
                     Step(id: 4, name: "2", participant: participants[1], competition: nil),
                     Step(id: 5, name: "2", participant: participants[2], competition: nil)]
        
        var returnSteps = [Step]()
        for step in steps {
            if step.participant?.id == id { returnSteps.append(step) }
        }
        
        return returnSteps
    }
    
    func stepsWithParticipantIdWithStepName(id: Int, stepName: String) -> [Step]? {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
        let steps = [Step(id: 0, name: "1", participant: participants[0], competition: nil),
                     Step(id: 1, name: "1", participant: participants[1], competition: nil),
                     Step(id: 2, name: "1", participant: participants[2], competition: nil),
                     Step(id: 3, name: "2", participant: participants[0], competition: nil),
                     Step(id: 4, name: "2", participant: participants[1], competition: nil),
                     Step(id: 5, name: "2", participant: participants[2], competition: nil)]
        
        var returnSteps = [Step]()
        for step in steps {
            if step.participant?.id == id && step.name == stepName { returnSteps.append(step) }
        }
        
        return returnSteps
    }
    
    func lootsWithSteptId(id: Int) -> [Loot]? {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                    Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
        let steps = [Step(id: 0, name: "1", participant: participants[0], competition: nil),
                     Step(id: 1, name: "1", participant: participants[1], competition: nil),
                     Step(id: 2, name: "1", participant: participants[2], competition: nil),
                     Step(id: 3, name: "2", participant: participants[0], competition: nil),
                     Step(id: 4, name: "2", participant: participants[1], competition: nil),
                     Step(id: 5, name: "2", participant: participants[2], competition: nil)]
        
        let loots = [Loot(id: 0, fish: "Щука", weight: 1500, score: 2000, step: steps[0]), // 0 уч 1 этап
                     Loot(id: 1, fish: "Окунь", weight: 500, score: 1000, step: steps[0]), // 0 уч 1 этап
                     Loot(id: 2, fish: "Сом", weight: 5000, score: 5500, step: steps[0]), // 0 уч 1 этап
                     Loot(id: 3, fish: "Сом", weight: 4500, score: 5000, step: steps[1]), // 1 уч 1 этап
                     Loot(id: 4, fish: "Окунь", weight: 350, score: 450, step: steps[2]), // 2 уч 1 этап
                     Loot(id: 5, fish: "Лещ", weight: 800, score: 1300, step: steps[3]), // 0 уч 2 этап
                     Loot(id: 6, fish: "Карп", weight: 1100, score: 1600, step: steps[4]), // 1 уч 2 этап
                     Loot(id: 7, fish: "Окунь", weight: 600, score: 1100, step: steps[5]), // 2 уч 2 этап
                     Loot(id: 8, fish: "Окунь", weight: 600, score: 1100, step: steps[5])] // 2 уч 2 этап
        
        
        var returnLoots = [Loot]()
        for loot in loots {
            if loot.step?.id == id { returnLoots.append(loot) }
        }
        
        return returnLoots
    }
}

