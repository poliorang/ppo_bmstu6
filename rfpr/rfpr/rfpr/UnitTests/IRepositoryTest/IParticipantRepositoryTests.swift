//
//  IParticipantRepositoryTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 04.04.2023.
//

import XCTest
@testable import rfpr

class IParticipantRepositoryTests: XCTestCase {

    var participantRepository: MockParticipantRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        participantRepository = MockParticipantRepository()
    }

    override func tearDownWithError() throws {
        participantRepository = nil
        try super.tearDownWithError()
    }

    func testCreateParticipant() throws {
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try participantRepository.createParticipant(participant: participant))
    }
    
    func testCreateParticipantNillPatronymic() throws {
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: nil, team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try participantRepository.createParticipant(participant: participant))
    }
    
    func testUpdateParticipant() {
        let previousParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try participantRepository.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNil() {
        let previousParticipant = Participant(id: "10", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertThrowsError(try participantRepository.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testDeleteParticipant() {
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        XCTAssertNoThrow(try participantRepository.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNil() {
        let participant = Participant(id: "10", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        XCTAssertThrowsError(try participantRepository.deleteParticipant(participant: participant))
    }
    
    func testGetParticipants() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, score: 2650)
        
        let participants = [participant, participant1, participant2]
        
        XCTAssertEqual(Set(try participantRepository.getParticipants() ?? []), Set(participants))
    }
    
    func testGetParticipantByTeam() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team, city: "Москва", birthday: bith, score: 0)
        
        let participants = [participant1]
        
        XCTAssertEqual(try participantRepository.getParticipantByTeam(team: team), participants)
    }
    
    func testGetParticipantByTeamNil() throws {
        let team = Team(id: "1", name: "", competitions: nil, score: 0)
        
        XCTAssertEqual(try participantRepository.getParticipantByTeam(team: team), nil)
    }
}
