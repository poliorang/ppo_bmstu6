//
//  ParticipantRepositoryTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 10.04.2023.
//

import XCTest
import RealmSwift
@testable import rfpr

fileprivate var participantRepository: ParticipantRepository!
fileprivate var config = "ParticipantRepositoryTests"
fileprivate var beforeTestClass: BeforeParticipantRepositoryTest!

class ParticipantRepositoryTest: XCTestCase {
    override class func setUp() {
        super.setUp()
        do {
            participantRepository = try ParticipantRepository(configRealm: config)
        } catch {
            print("Не удалось открыть Realm: \(config)")
            exit(-1)
        }
        
        beforeTestClass = BeforeParticipantRepositoryTest()
        
        do {
            try beforeTestClass.setupRepository(config: config)
            try beforeTestClass.createData()
        } catch {
            print("Не удалось загрузить данные: \(config)")
            exit(-1)
        }
    }

    override class func tearDown() {
        participantRepository = nil
        beforeTestClass = nil
        super.tearDown()
    }
    
    func testCreateParticipant() throws {
        let participant = Participant(id: "4442852b2b74d595cb4f4708", lastName: "Петров", firstName: "Петр", patronymic: "Петрович", city: "Москва", birthday: bith, score: 0)
        var createdParticipant: Participant?
        
        XCTAssertNoThrow(try createdParticipant = participantRepository.createParticipant(participant: participant))
        XCTAssertEqual(createdParticipant, participant)
    }
    
    func testCreateParticipantNillPatronymic() throws {
        let participant = Participant(id: "4442852b2b74d595cb4f4712", lastName: "Егоров", firstName: "Егор", patronymic: nil, city: "Москва", birthday: bith, score: 0)
        var createdParticipant: Participant?
        
        XCTAssertNoThrow(try createdParticipant = participantRepository.createParticipant(participant: participant))
        XCTAssertEqual(createdParticipant, participant)
    }
    
    func testUpdateParticipant() {
        let previousParticipant = Participant(id: "4442852b2b74d595cb4f4700", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "4442852b2b74d595cb4f4700", lastName: "Иванов", firstName: "Сергей", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        var updatedParticipant: Participant?
        
        XCTAssertNoThrow(try updatedParticipant = participantRepository.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
        XCTAssertEqual(updatedParticipant, newParticipant)
    }
    
    func testUpdateParticipantNil() {
        let previousParticipant = Participant(id: "1142852b2b74d595cb4f4700", lastName: "Кириллов", firstName: "Кирилл", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        let newParticipant = Participant(id: "4442852b2b74d595cb4f4700", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        var updatedParticipant: Participant?
        
        XCTAssertThrowsError(try updatedParticipant = participantRepository.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant))
        XCTAssertEqual(updatedParticipant, nil)
    }
    
    func testDeleteParticipant() {
        let participant = Participant(id: "4442852b2b74d595cb4f4704", lastName: "Алексеев", firstName: "Алексей", city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try participantRepository.deleteParticipant(participant: participant))
        XCTAssertEqual(try participantRepository.getParticipant(id: "4442852b2b74d595cb4f4704"), nil)
    }
    
    func testDeleteParticipantNil() {
        let participant = Participant(id: "1142852b2b74d595cb4f4704", lastName: "Гринев", firstName: "Иван", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        
        XCTAssertThrowsError(try participantRepository.deleteParticipant(participant: participant))
    }
    
    func testGetParticipantByTeam() throws {
        let team = Team(id: "4442852b2b74d595cb4f4732", name: "Козлов и Захаров", competitions: nil, score: 0)
        let participant1 = Participant(id: "4442852b2b74d595cb4f4720", lastName: "Козлов", firstName: "Иван", team: team, city: "Москва", birthday: bith, score: 0)
        let participant3 = Participant(id: "4442852b2b74d595cb4f4728", lastName: "Захаров", firstName: "Иван", team: team, city: "Москва", birthday: bith, score: 0)

        let teams = [participant1, participant3]

        XCTAssertEqual(try participantRepository.getParticipantByTeam(team: team), teams)
    }
    
    func testGetParticipants() throws {
        let team = Team(id: "4442852b2b74d595cb4f4732", name: "Козлов и Захаров", competitions: nil, score: 0)
        
        let participant1 = Participant(id: "4442852b2b74d595cb4f4720", lastName: "Козлов", firstName: "Иван", team: team, city: "Москва", birthday: bith, score: 0)
        let participant2 = Participant(id: "4442852b2b74d595cb4f4728", lastName: "Захаров", firstName: "Иван", team: team, city: "Москва", birthday: bith, score: 0)
        
        let participant3 = Participant(id: "4442852b2b74d595cb4f4700", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        let participant4 = Participant(id: "4442852b2b74d595cb4f4708", lastName: "Петров", firstName: "Петр", patronymic: "Петрович", city: "Москва", birthday: bith, score: 0)
        let participant5 = Participant(id: "4442852b2b74d595cb4f4712", lastName: "Егоров", firstName: "Егор", city: "Москва", birthday: bith, score: 0)
        let participant6 = Participant(id: "4442852b2b74d595cb4f4724", lastName: "Звягин", firstName: "Иван", team: nil, city: "Москва", birthday: bith, score: 0)
        
        let participants = [participant1, participant2, participant3,
                            participant4, participant5, participant6]

        XCTAssertEqual(Set(try participantRepository.getParticipants() ?? []), Set(participants))
    }
}
