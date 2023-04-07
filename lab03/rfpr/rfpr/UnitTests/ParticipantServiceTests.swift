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
        participantRepository = MockParticipantRepository()
        getDataRepository = MockGetDataRepository()
        getDataService = GetDataService(getDataRepository: getDataRepository)
        participantService = ParticipantService(participantRepository: participantRepository, getDataService: getDataService)
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
        let participant = Participant(id: 1, fullname: "aaa", city: "vvv", birthday: nil, role: "aa", autorization: nil, score: 0)
        XCTAssertNoThrow(participantService.updateParticipant(id: 1, participant: participant))
    }
    
    func testUpdateParticipantNil() {
        let participant = Participant(id: 1, fullname: "aaa", city: "vvv", birthday: nil, role: "aa", autorization: nil, score: 0)
        XCTAssertNoThrow(participantService.updateParticipant(id: nil, participant: participant))
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
}
