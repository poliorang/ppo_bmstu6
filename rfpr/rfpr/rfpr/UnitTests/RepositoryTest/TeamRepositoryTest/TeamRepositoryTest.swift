//
//  TeamRepositoryTest.swift
//  UnitTests
//
//  Created by poliorang on 10.04.2023.
//

import XCTest
import RealmSwift
@testable import rfpr

fileprivate var teamRepository: TeamRepository!
fileprivate var config = "TeamRepositoryTest"
fileprivate var beforeTestClass: BeforeTeamRepositoryTest!

class TeamRepositoryTest: XCTestCase {

    override class func setUp() {
        super.setUp()
        do {
            teamRepository = try TeamRepository(configRealm: config)
        } catch {
            print("Не удалось открыть Realm: \(config)")
            exit(-1)
        }
        
        beforeTestClass = BeforeTeamRepositoryTest()
        
        do {
            try beforeTestClass.setupRepository(config: config)
            try beforeTestClass.createData()
        } catch {
            print("Не удалось загрузить данные: \(config)")
            exit(-1)
        }
    }

    override class func tearDown() {
        teamRepository = nil
        beforeTestClass = nil
        super.tearDown()
    }
    
    func testCreateTeam() throws {
        let team = Team(id: "5442852b2b74d595cb4f4700", name: "Батискаф", competitions: nil, score: 0)
        var createdTeam: Team?

        XCTAssertNoThrow(try createdTeam = teamRepository.createTeam(team: team))
        XCTAssertEqual(createdTeam, team)
    }

    func testUpdateTeamNilCompetition() {
        let team1 = Team(id: "5442852b2b74d595cb4f4708", name: "Update", competitions: nil, score: 0)
        let team2 = Team(id: "5442852b2b74d595cb4f4708", name: "Updated", competitions: nil, score: 0)
        var updatedTeam: Team?

        XCTAssertNoThrow(try updatedTeam = teamRepository.updateTeam(previousTeam: team1, newTeam: team2))
        XCTAssertEqual(updatedTeam, team2)
    }

    func testUpdateTeamNil() {
        let team1 = Team(id: "5442852b2b74d595cb4f4799", name: "AAA", competitions: nil, score: 0)
        let team2 = Team(id: "5442852b2b74d595cb4f4708", name: "Updated", competitions: nil, score: 0)
        var updatedTeam: Team?

        XCTAssertThrowsError(try updatedTeam = teamRepository.updateTeam(previousTeam: team1, newTeam: team2))
        XCTAssertEqual(updatedTeam, nil)
    }

    func testDeleteTeamNilCompetition() {
        let team = Team(id: "5442852b2b74d595cb4f4720", name: "Delete", competitions: nil, score: 0)

        XCTAssertNoThrow(try teamRepository.deleteTeam(team: team))
        XCTAssertEqual(try teamRepository.getTeam(id: "5442852b2b74d595cb4f4720"), nil)
    }

    func testDeleteTeamNil() {
        let team = Team(id: "5442852b2b74d595cb4f4799", name: "aaa", competitions: nil, score: 0)

        XCTAssertThrowsError(try teamRepository.deleteTeam(team: team))
    }

    func testAddCompetition() throws {
        let team = Team(id: "5442852b2b74d595cb4f4724", name: "Add Competition", competitions: nil, score: 0)
        let competition = Competition(id: "5442852b2b74d595cb4f4728", name: "Added", teams: nil)
        let newTeam = Team(id: "5442852b2b74d595cb4f4724", name: "Add Competition", competitions: [competition], score: 0)

        XCTAssertNoThrow(try teamRepository.addCompetition(team: team, competition: competition))
        XCTAssertEqual(try teamRepository.getTeam(id: "5442852b2b74d595cb4f4724"), newTeam)
    }

    func testAddCompetitionNilTeam() throws {
        let team = Team(id: "5442852b2b74d595cb4f4799", name: "", competitions: nil, score: 0)
        let competition = Competition(id: "5442852b2b74d595cb4f4728", name: "Added", teams: nil)

        XCTAssertThrowsError(try teamRepository.addCompetition(team: team, competition: competition))
        XCTAssertEqual(try teamRepository.getTeam(id: "5442852b2b74d595cb4f4799"), nil)
    }

    func testAddCompetitionNilCompetition() throws {
        let competition1 = Competition(id: "5442852b2b74d595cb4f4728", name: "Added", teams: nil)
        let team = Team(id: "5442852b2b74d595cb4f4724", name: "Add Competition", competitions: [competition1], score: 0)
        let competition = Competition(id: "5442852b2b74d595cb4f4799", name: "", teams: nil)

        XCTAssertThrowsError(try teamRepository.addCompetition(team: team, competition: competition))
        XCTAssertEqual(try teamRepository.getTeam(id: "5442852b2b74d595cb4f4724"), team)
    }

    func testAddParticipant() throws {
        let team = Team(id: "5442852b2b74d595cb4f4734", name: "AddParticipant", competitions: nil, score: 0)
        let participant = Participant(id: "5442852b2b74d595cb4f4730", lastName: "Абрамов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)

        XCTAssertNoThrow(try teamRepository.addParticipant(participant: participant, team: team))
    }

    func testAddParticipantNilParticipant() throws {
        let team = Team(id: "5442852b2b74d595cb4f4734", name: "AddParticipant1", competitions: nil, score: 0)
        let participant = Participant(id: "5442852b2b74d595cb4f4799", lastName: "", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)

        XCTAssertThrowsError(try teamRepository.addParticipant(participant: participant, team: team))
    }

    func testAddParticipantNilTeam() throws {
        let team = Team(id: "5442852b2b74d595cb4f4799", name: "", competitions: nil, score: 0)
        let participant = Participant(id: "5442852b2b74d595cb4f4730", lastName: "Абрамов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)

        XCTAssertThrowsError(try teamRepository.addParticipant(participant: participant, team: team))
    }

//    func testGetTeamByParticipant() throws {
//        let team = Team(id: "5442852b2b74d595cb4f4738", name: "Команда Гурова", competitions: nil, score: 0)
//        let participant = Participant(id: "5442852b2b74d595cb4f4742", lastName: "Гуров", firstName: "Иван", patronymic: "Иванович", team: team, city: "Москва", birthday: bith, role: "Участник", score: 0)
//
//        XCTAssertEqual(try teamRepository.getTeamByParticipant(participant: participant), team)
//    }
//
//    func testGetTeamByParticipantNilTeam() throws {
//        let participant = Participant(id: "5442852b2b74d595cb4f4755", lastName: "Артемов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, role: "Участник", score: 0)
//
//        XCTAssertEqual(try teamRepository.getTeamByParticipant(participant: participant), nil)
//    }
//
    func testGetTeams() throws {
        let team1 = Team(id: "5442852b2b74d595cb4f4738", name: "Команда Гурова", competitions: nil, score: 0)
        let team2 = Team(id: "5442852b2b74d595cb4f4734", name: "AddParticipant", competitions: nil, score: 0)
        let team3 = Team(id: "5442852b2b74d595cb4f4700", name: "Батискаф", competitions: nil, score: 0)
        
        let competition = Competition(id: "5442852b2b74d595cb4f4728", name: "Added", teams: nil)
        let team4 = Team(id: "5442852b2b74d595cb4f4724", name: "Add Competition", competitions: [competition], score: 0)
        let team5 = Team(id: "5442852b2b74d595cb4f4708", name: "Update", competitions: nil, score: 0)
        
        let teams = [team1, team2, team3, team4, team5]
        
        XCTAssertEqual(Set(try (teamRepository.getTeams() ?? [])), Set(teams))
    }
}
