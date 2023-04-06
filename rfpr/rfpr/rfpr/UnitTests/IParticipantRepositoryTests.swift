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
        let participant = Participant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0)
        XCTAssertEqual(participantRepository.createParticipant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0), participant)
    }
    
    func testUpdateParticipant() {
        XCTAssertEqual(participantRepository.updateParticipant(id: 1) as! String, "Data of participants type was updated")
    }
    
    func testUpdateParticipantNil() {
        XCTAssertNil(participantRepository.updateParticipant(id: nil))
    }
    
    func testDeleteParticipant() {
        XCTAssertEqual(participantRepository.deleteParticipant(id: 1) as! String, "Data of participants type was deleted")
    }
    
    func testDeleteParticipantNil() {
        XCTAssertNil(participantRepository.deleteParticipant(id: nil))
    }
    
    func testGetParticipant() throws {
        let participant = Participant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0)
        XCTAssertEqual(participantRepository.getParticipant(id: 1), participant)
    }
    
    func testGetParticipantNil() throws {
        XCTAssertNil(participantRepository.getParticipant(id: 5))
    }
    
    func testGetParticipantNilId() throws {
        XCTAssertNil(participantRepository.getParticipant(id: nil))
    }
    
    func testsGetParticipantsByAscending() throws {
        let participants = [Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650),
                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 9800)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: SortParameter.ascending, stepName: nil), participants)
    }
    
    func testsGetParticipantsByDecreasing() throws {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 9800),
                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: SortParameter.decreasing, stepName: nil), participants)
    }
    
    func testsGetParticipantsByNil() throws {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                    Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 9800),
                    Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: nil, stepName: nil), participants)
    }
    
    func testsGetParticipantsByStepByAscending1() throws {
        let participants = [Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 450),
                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 5000),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 8500)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: SortParameter.ascending, stepName: "1"), participants)
    }
    
    func testsGetParticipantsByStepByAscending2() throws {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 1300),
                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 1600),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2200)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: SortParameter.ascending, stepName: "2"), participants)
    }
    
    func testsGetParticipantsByStepByDecreasing() throws {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 8500),
                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 5000),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 450)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: SortParameter.decreasing, stepName: "1"), participants)
    }
    
    func testsGetParticipantsByStepByNil() throws {
        let participants = [Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 1600),
                    Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 1300),
                    Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2200)]
        
        XCTAssertEqual(participantRepository.getParticipants(parameter: nil, stepName: "2"), participants)
    }
}
