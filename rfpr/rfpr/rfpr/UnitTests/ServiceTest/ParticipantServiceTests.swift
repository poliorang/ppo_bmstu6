//
//  ParticipantServiceTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 04.04.2023.
//

import XCTest
@testable import rfpr

class ParticipantServiceTests: XCTestCase {
    
    var participantService: IParticipantService!
    var participantRepository: IParticipantRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        participantRepository = MockParticipantRepository()
        participantService = ParticipantService(participantRepository: participantRepository, participantByTeamRepository: participantRepository as! IParticipantByTeamRepository)
    }

    override func tearDownWithError() throws {
        participantService = nil
        participantRepository = nil
        
        try super.tearDownWithError()
    }
    
    func testCreateParticipant() throws {
        XCTAssertNoThrow(try participantService.createParticipant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0))
    }
    
    func testCreateParticipantNil() throws {
        XCTAssertThrowsError(try participantService.createParticipant(id: "1", lastName: nil, firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0))
    }
    
    func testCreateParticipantNillPatronymic() throws {
        XCTAssertNoThrow(try participantService.createParticipant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: nil, team: nil, city: "Москва", birthday: bith, score: 0))
    }
    
    func testUpdateParticipant() {
        let previousParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try participantService.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNoPrev() {
        let previousParticipant = Participant(id: "100", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertThrowsError(try participantService.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNo() {
        let previousParticipant = Participant(id: "10", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertThrowsError(try participantService.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNil() {
        XCTAssertThrowsError(try participantService.updateParticipant(previousParticipant: nil, newParticipant: nil))
    }
    
    func testDeleteParticipant() {
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        XCTAssertNoThrow(try participantService.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNoParticipant() {
        let participant = Participant(id: "100", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        XCTAssertThrowsError(try participantService.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNil() {
        let participant = Participant(id: "10", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        XCTAssertThrowsError(try participantService.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNilParticipant() {
        XCTAssertThrowsError(try participantService.deleteParticipant(participant: nil))
    }
    
    
    func testGetParticipantManyAnswer() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, score: 2650)

        let participants = [participant, participant1, participant2]

        XCTAssertEqual(Set(try participantService.getParticipant(fullname: "Иванов") ?? []), Set(participants))
    }
    
    func testGetParticipantOneAnswer() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, score: 0)
        
        let participants = [participant]
        
        XCTAssertEqual(try participantService.getParticipant(fullname: "Иванов Иван"), participants)
    }
    
    func testGetParticipantNilPatronymic() throws {
        let team = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team, city: "Москва", birthday: bith, score: 0)
        
        let participants = [participant]
        
        XCTAssertEqual(try participantService.getParticipant(fullname: "Сергей"), participants)
    }
    
    func testGetParticipantOneAnswer1() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, score: 0)
        
        let participants = [participant]
        
        XCTAssertEqual(try participantService.getParticipant(fullname: "Иван Иванов"), participants)
    }
    
    func testGetParticipantManyAnswer3() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, score: 2650)
        
        let participants = [participant, participant1, participant2]
        
        XCTAssertEqual(Set(try participantService.getParticipant(fullname: "Иван") ?? []), Set(participants))
    }
    
    func testGetParticipantNilAnswer() throws {
        XCTAssertEqual(try participantService.getParticipant(fullname: "Сидоров"), nil)
    }
    
    func testGetParticipantNilFullname() throws {
        XCTAssertThrowsError(try participantService.getParticipant(fullname: nil))
    }
    
    func testGetParticipants() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, score: 2650)
        
        let participants = [participant, participant1, participant2]
        
        XCTAssertEqual(Set(try participantService.getParticipants() ?? []), Set(participants))
    }
    
    func testGetParticipantByTeam() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team, city: "Москва", birthday: bith, score: 0)
        
        let participants = [participant1]
        
        XCTAssertEqual(try participantService.getParticipantByTeam(team: team), participants)
    }
    
    func testGetParticipantByTeamNil() throws {
        let team = Team(id: "1", name: "", competitions: nil, score: 0)
        
        XCTAssertEqual(try participantService.getParticipantByTeam(team: team), nil)
    }
}
