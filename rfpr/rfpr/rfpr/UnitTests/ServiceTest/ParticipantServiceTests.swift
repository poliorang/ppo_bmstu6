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
    var getDataService: IGetDataService!
    var getDataRepository: IGetDataRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        getDataRepository = MockGetDataRepository()
        getDataService = GetDataService(getDataRepository: getDataRepository)
        
        participantRepository = MockParticipantRepository()
        participantService = ParticipantService(participantRepository: participantRepository, getDataService: getDataService)
    }

    override func tearDownWithError() throws {
        participantService = nil
        participantRepository = nil
        getDataService = nil
        getDataRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateParticipant() throws {
        XCTAssertNoThrow(try participantService.createParticipant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0))
    }
    
    func testCreateParticipantNil() throws {
        XCTAssertThrowsError(try participantService.createParticipant(id: "1", lastName: nil, firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0))
    }
    
    func testCreateParticipantNillPatronymic() throws {
        XCTAssertNoThrow(try participantService.createParticipant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: nil, team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0))
    }
    
    func testUpdateParticipant() {
        let previousParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        
        XCTAssertNoThrow(try participantService.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNoPrev() {
        let previousParticipant = Participant(id: "100", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        
        XCTAssertThrowsError(try participantService.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNo() {
        let previousParticipant = Participant(id: "10", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        let newParticipant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        
        XCTAssertThrowsError(try participantService.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
    }
    
    func testUpdateParticipantNil() {
        XCTAssertThrowsError(try participantService.updateParticipant(previousParticipant: nil, newParticipant: nil))
    }
    
    func testDeleteParticipant() {
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        XCTAssertNoThrow(try participantService.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNoParticipant() {
        let participant = Participant(id: "100", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        XCTAssertThrowsError(try participantService.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNil() {
        let participant = Participant(id: "10", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
        XCTAssertThrowsError(try participantService.deleteParticipant(participant: participant))
    }
    
    func testDeleteParticipantNilParticipant() {
        XCTAssertThrowsError(try participantService.deleteParticipant(participant: nil))
    }
    
    
    func testGetParticipantManyAnswer() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, role: "Участник", score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, role: "Участник", score: 2650)

        let participants = [participant, participant1, participant2]

        XCTAssertEqual(Set(try participantService.getParticipant(fullname: "Иванов") ?? []), Set(participants))
    }
    
    func testGetParticipantOneAnswer() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 0)
        
        let participants = [participant]
        
        XCTAssertEqual(try participantService.getParticipant(fullname: "Иванов Иван"), participants)
    }
    
    func testGetParticipantNilPatronymic() throws {
        let team = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team, city: "Москва", birthday: bith, role: "Участник", score: 0)
        
        let participants = [participant]
        
        XCTAssertEqual(try participantService.getParticipant(fullname: "Сергей"), participants)
    }
    
    func testGetParticipantOneAnswer1() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 0)
        
        let participants = [participant]
        
        XCTAssertEqual(try participantService.getParticipant(fullname: "Иван Иванов"), participants)
    }
    
    func testGetParticipantManyAnswer3() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, role: "Участник", score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, role: "Участник", score: 2650)
        
        let participants = [participant, participant1, participant2]
        
        XCTAssertEqual(Set(try participantService.getParticipant(fullname: "Иван") ?? []), Set(participants))
    }
    
    func testGetParticipantNilAnswer() throws {
        XCTAssertEqual(try participantService.getParticipant(fullname: "Сидоров"), nil)
    }
    
    func testGetParticipantNilFullname() throws {
        XCTAssertThrowsError(try participantService.getParticipant(fullname: nil))
    }
    
    func testGetParticipantsSortedDecreasingNilStep() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, role: "Участник", score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, role: "Участник", score: 2650)
        
        let participants = [participant, participant1, participant2]
        
        XCTAssertEqual(try participantService.getParticipants(parameter: .decreasing, stepName: nil), participants)
    }
    
    func testGetParticipantsSortedAscendingNilStep() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 9800)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, role: "Участник", score: 6600)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, role: "Участник", score: 2650)
        
        let participants = [participant2, participant1, participant]

        
        XCTAssertEqual(try participantService.getParticipants(parameter: .ascending, stepName: nil), participants)
    }
    
    func testGetParticipantsSortedAscending() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 8500)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, role: "Участник", score: 5000)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, role: "Участник", score: 450)
        
        let participants = [participant2, participant1, participant]

        XCTAssertEqual(try participantService.getParticipants(parameter: .ascending, stepName: "1"), participants)
    }

    func testGetParticipantsSortedDecreasing() {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
        
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", team: team1, city: "Москва", birthday: bith, role: "Участник", score: 8500)
        let participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Петр", patronymic: "Петрович", team: team2, city: "Москва", birthday: bith, role: "Участник", score: 5000)
        let participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", team: team3, city: "Москва", birthday: bith, role: "Участник", score: 450)
        
        let participants = [participant, participant1, participant2]

        XCTAssertEqual(try participantService.getParticipants(parameter: .decreasing, stepName: "1"), participants)
    }
    
}
