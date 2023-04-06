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
        participantService = ParticipantService(participantRepository: participantRepository)
    }

    override func tearDownWithError() throws {
        participantService = nil
        participantRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateParticipant() throws {
        let participant = Participant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0)
        XCTAssertEqual(participantService.createParticipant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0), participant)
    }
    
    func testUpdateParticipant() {
        XCTAssertNoThrow(participantService.updateParticipant(id: 1))
    }
    
    func testUpdateParticipantNil() {
        XCTAssertNoThrow(participantService.updateParticipant(id: nil))
    }
    
    func testDeleteParticipant() {
        XCTAssertNoThrow(participantService.deleteParticipant(id: 1))
    }
    
    func testDeleteParticipantNil() {
        XCTAssertNoThrow(participantService.deleteParticipant(id: nil))
    }
    
    func testGetParticipant() throws {
        let participant = Participant(id: 1, fullname: "Ivan", city: "Moscow", birthday: nil, role: "Refeere", autorization: nil, score: 0)
        XCTAssertEqual(participantService.getParticipant(id: 1), participant)
    }
    
    func testGetParticipantNil() throws {
        XCTAssertNil(participantService.getParticipant(id: 5))
    }
    
    func testGetParticipantNilId() throws {
        XCTAssertNil(participantService.getParticipant(id: nil))
    }

//    func testsGetParticipantsByAscending() throws {
//        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role:                          "Участник", autorization: nil, score: nil),
//                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 3, fullname: "Егоров", city: "Екатеринбург", birthday: nil, role: "Участник", autorization: nil, score: nil)]
//        
//        XCTAssertEqual(participantService.getParticipants(parameter: SortParameter.ascending, stepName: nil), participants)
//    }
//    
//    func testsGetParticipantsByDecreasing() throws {
//        let participants = [Participant(id: 3, fullname: "Егоров", city: "Екатеринбург", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role:                          "Участник", autorization: nil, score: nil)]
//        
//        XCTAssertEqual(participantService.getParticipants(parameter: SortParameter.decreasing, stepName: nil), participants)
//    }
//    
//    func testsGetParticipantsByNil() throws {
//        let participants = [Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role:                          "Участник", autorization: nil, score: nil),
//                            Participant(id: 3, fullname: "Егоров", city: "Екатеринбург", birthday: nil, role: "Участник", autorization: nil, score: nil),
//                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: nil)]
//        
//        XCTAssertEqual(participantService.getParticipants(parameter: nil, stepName: nil), participants)
//    }

}
