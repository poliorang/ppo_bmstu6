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
        let participant = Participant(id: 1, fullname: "aaa", city: "vvv", birthday: nil, role: "aa", autorization: nil, score: 0)
        XCTAssertEqual(participantRepository.updateParticipant(id: 1, participant: participant) as! String, "Data of participants type was updated")
    }
    
    func testUpdateParticipantNil() {
        let participant = Participant(id: 1, fullname: "aaa", city: "vvv", birthday: nil, role: "aa", autorization: nil, score: 0)
        XCTAssertNil(participantRepository.updateParticipant(id: nil, participant: participant))
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

}
