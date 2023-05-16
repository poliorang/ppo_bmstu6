//
//  ParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

class MockParticipantRepository: IParticipantRepository,
                                 IParticipantByTeamRepository {
    private let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
    private let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
    private let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)

    private var participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 9800)
    private var participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: nil, city: "Москва", birthday: bith, score: 6600)
    private var participant3 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: nil, city: "Москва", birthday: bith, score: 2650)
    
    private var step1 = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
    private var step2 = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
    private var step3 = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
    private var step4 = Step(id: "1", name: "Второй день", participant: nil, competition: nil, score: 0)
    
    private var dbParticipants = [Participant]()
    
    func createParticipant(participant newParticipant: Participant) throws -> Participant? {
        dbParticipants.append(newParticipant)
        if dbParticipants.contains(newParticipant) == false {
            throw DatabaseError.addError
        }
        
        return newParticipant
    }
    
    func updateParticipant(previousParticipant: Participant, newParticipant: Participant) throws -> Participant? {
        dbParticipants.append(participant1)
        
        if let index = dbParticipants.firstIndex(where: { $0 == previousParticipant }) {
            dbParticipants.remove(at: index)
            dbParticipants.append(newParticipant)
        } else {
            throw DatabaseError.updateError
        }
        
        return newParticipant
    }
    
    func deleteParticipant(participant removeParticipant: Participant) throws {
        dbParticipants.append(participant1)
        
        if let index = dbParticipants.firstIndex(where: { $0 == removeParticipant }) {
            dbParticipants.remove(at: index)
        } else {
            throw DatabaseError.deleteError
        }
    }
    
    func getParticipants() throws -> [Participant]? {
        participant1.team = team1
        participant2.team = team2
        participant3.team = team3
        
        step1.participant = participant1
        step2.participant = participant2
        step3.participant = participant3
        
        [participant3, participant1, participant2].forEach {
            dbParticipants.append($0)
        }
        
        let participants = dbParticipants
        if participants.isEmpty == false {
            return participants
        } else {
            throw DatabaseError.deleteError
        }
    }

    func getParticipantByTeam(team: Team) throws -> [Participant]? {
        dbParticipants.removeAll()
        participant1.team = team1
        participant2.team = team2
        participant3.team = team3
        
        [participant1, participant2, participant3].forEach {
            dbParticipants.append($0)
        }
        
        var resultParticipant = [Participant]()
        for participant in dbParticipants {
            if participant.team == team { resultParticipant.append(participant) }
        }
        
        return resultParticipant.isEmpty ? nil : resultParticipant
    }
    
    
    func getParticipantScoreByCompetition(participant: Participant, competition: Competition, stepName: StepsName?) throws -> Participant? {
        return nil
    }
}
