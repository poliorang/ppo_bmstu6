//
//  MockGetDataRepository.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//

class MockGetDataRepository: IGetDataRepository {
    
    private let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
    private let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
    private let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
    
    var participants = [Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", city: "Москва", birthday: bith, role: "Участник", score: 0),
                       Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", city: "Москва", birthday: bith, role: "Участник", score: 0),
                       Participant(id: "1", lastName: "Иванов", firstName: "Сергей", city: "Москва", birthday: bith, role: "Участник", score: 0)]
    
    func stepsWithParticipantId(participant: Participant) -> [Step]? {
        participants[0].team = team1
        participants[1].team = team2
        participants[2].team = team3
        
        let steps = [Step(id: "0", name: "1", participant: participants[0], competition: nil, score: 0),
                     Step(id: "1", name: "1", participant: participants[1], competition: nil, score: 0),
                     Step(id: "2", name: "1", participant: participants[2], competition: nil, score: 0),
                     Step(id: "3", name: "2", participant: participants[0], competition: nil, score: 0),
                     Step(id: "4", name: "2", participant: participants[1], competition: nil, score: 0),
                     Step(id: "5", name: "2", participant: participants[2], competition: nil, score: 0)]
        
        var resultSteps = [Step]()
        for step in steps {
            if step.participant == participant { resultSteps.append(step) }
        }

        if resultSteps.isEmpty { return nil }
        
        return resultSteps
    }

    func stepsWithParticipantIdWithStepName(participant: Participant, stepName: String) -> [Step]? {
        participants[0].team = team1
        participants[1].team = team2
        participants[2].team = team3
        
        let steps = [Step(id: "0", name: "1", participant: participants[0], competition: nil, score: 0),
                     Step(id: "1", name: "1", participant: participants[1], competition: nil, score: 0),
                     Step(id: "2", name: "1", participant: participants[2], competition: nil, score: 0),
                     Step(id: "3", name: "2", participant: participants[0], competition: nil, score: 0),
                     Step(id: "4", name: "2", participant: participants[1], competition: nil, score: 0),
                     Step(id: "5", name: "2", participant: participants[2], competition: nil, score: 0)]
        
        var resultSteps = [Step]()
        for step in steps {
            if step.participant == participant && step.name == stepName { resultSteps.append(step) }
        }
        
        if resultSteps.isEmpty { return nil }
            
        return resultSteps
    }
    
    func lootsWithSteptId(step matchStep: Step) -> [Loot]? {
        let steps = [Step(id: "0", name: "1", participant: participants[0], competition: nil, score: 0),
                     Step(id: "1", name: "1", participant: participants[1], competition: nil, score: 0),
                     Step(id: "2", name: "1", participant: participants[2], competition: nil, score: 0),
                     Step(id: "3", name: "2", participant: participants[0], competition: nil, score: 0),
                     Step(id: "4", name: "2", participant: participants[1], competition: nil, score: 0),
                     Step(id: "5", name: "2", participant: participants[2], competition: nil, score: 0)]
        
        let loots = [Loot(id: "0", fish: "Щука", weight: 1500, step: steps[0], score: 2000), // 0 уч 1 этап
                    Loot(id: "1", fish: "Окунь", weight: 500, step: steps[0], score: 1000), // 0 уч 1 этап
                    Loot(id: "2", fish: "Сом", weight: 5000, step: steps[0], score: 5500), // 0 уч 1 этап
                    Loot(id: "3", fish: "Сом", weight: 4500, step: steps[1], score: 5000), // 1 уч 1 этап
                    Loot(id: "4", fish: "Окунь", weight: 350, step: steps[2], score: 450), // 2 уч 1 этап
                    Loot(id: "5", fish: "Лещ", weight: 800, step: steps[3], score: 1300), // 0 уч 2 этап
                    Loot(id: "6", fish: "Карп", weight: 1100, step: steps[4], score: 1600), // 1 уч 2 этап
                    Loot(id: "7", fish: "Окунь", weight: 600, step: steps[5], score: 1100), // 2 уч 2 этап
                    Loot(id: "8", fish: "Окунь", weight: 600, step: steps[5], score: 1100),] // 2 уч 2 этап
        
        var resultLoots = [Loot]()
        for loot in loots {
            if loot.step == matchStep {
                resultLoots.append(loot)
            }
        }
        
        if resultLoots.isEmpty { return nil }

        return resultLoots
    }
}
