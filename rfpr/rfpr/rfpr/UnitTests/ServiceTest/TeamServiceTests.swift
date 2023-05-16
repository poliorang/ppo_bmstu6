//
//  TeamServiceTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 04.04.2023.
//

import XCTest
@testable import rfpr

class TeamServiceTests: XCTestCase {

    var teamService: ITeamService!
    var teamRepository: ITeamRepository!
    var participantRepository: IParticipantByTeamRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        participantRepository = MockParticipantRepository()
        
        teamRepository = MockTeamRepository()
        teamService = TeamService(teamRepository: teamRepository,
                                  participantRepository: participantRepository,
                                  participantToTeamRepository: teamRepository as! IParticipantToTeamRepository,
                                  competitionToTeamRepository: teamRepository as! ICompetitionToTeamRepository)
    }

    override func tearDownWithError() throws {
        teamService = nil
        teamRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateTeam() throws {
        XCTAssertNoThrow(try teamService.createTeam(id: "1", name: "Батискаф", competitions: nil, score: 0))
    }
    
    func testCreateTeamNilName() throws {
        XCTAssertThrowsError(try teamService.createTeam(id: "1", name: nil, competitions: nil, score: 0))
    }
    
    func testUpdateTeam() {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        
        XCTAssertNoThrow(try teamService.updateTeam(previousTeam: team1, newTeam: team2))
    }
    
    func testUpdateTeamNoPrev() {
        let team1 = Team(id: "1", name: "d;skcmskld", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        
        XCTAssertThrowsError(try teamService.updateTeam(previousTeam: team1, newTeam: team2))
    }
    
    func testUpdateTeamNilPrev() {
        let team = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        
        XCTAssertThrowsError(try teamService.updateTeam(previousTeam: nil, newTeam: team))
    }
    
    func testUpdateTeamNilNew() {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        XCTAssertThrowsError(try teamService.updateTeam(previousTeam: team, newTeam: nil))
    }
    
    func testDeleteTeam() {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        XCTAssertNoThrow(try teamService.deleteTeam(team: team))
    }
    
    func testDeleteTeamNoTeam() {
        let team = Team(id: "1", name: "aasjncajncoasnmo", competitions: nil, score: 0)
        
        XCTAssertThrowsError(try teamService.deleteTeam(team: team))
    }
    
    func testDeleteTeamNil() {
        XCTAssertThrowsError(try teamService.deleteTeam(team: nil))
    }
    
    func testGetTeam() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        XCTAssertEqual(try teamService.getTeam(name: "Батискаф"), [team1])
    }
    
    func testGetTeamNoTeam() throws {
        XCTAssertEqual(try teamService.getTeam(name: "sldknvlskdnmls"), nil)
    }
    
    func testGetTeamNilTeam() throws {
        XCTAssertThrowsError(try teamService.getTeam(name: nil))
    }
    
    func testGetTeamMany() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        
        XCTAssertEqual(try teamService.getTeam(name: "Ба"), [team1, team2])
    }
    
    func testGetTeamNilId() throws {
        XCTAssertEqual(try teamService.getTeam(name: "ggg"), nil)
    }
    
    func testAddCompetition() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let competition = Competition(id: "1", name: "Байкал", teams: nil)
        
        XCTAssertNoThrow(try teamService.addCompetition(team: team, competition: competition))
    }
    
    func testAddCompetitionNilTeam() throws {
        let team = Team(id: "1", name: "", competitions: nil, score: 0)
        let competition = Competition(id: "1", name: "Байкал", teams: nil)
        
        XCTAssertThrowsError(try teamService.addCompetition(team: team, competition: competition))
    }
    
    func testAddCompetitionNilCompetition() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let competition = Competition(id: "1", name: "", teams: nil)
        
        XCTAssertThrowsError(try teamService.addCompetition(team: team, competition: competition))
    }
    
    func testAddParticipant() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try teamService.addParticipant(participant: participant, team: team))
    }
    
    func testAddParticipantNilTeam() throws {
        let team = Team(id: "1", name: "", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertThrowsError(try teamService.addParticipant(participant: participant, team: team))
    }
    
    func testAddParticipantNilParticipant() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try teamService.addParticipant(participant: participant, team: team))
    }
    
    func testGetTeamsByCompetition() throws {
        let competition = Competition(id: "1", name: "Байкал", teams: nil)
        let team = Team(id: "1", name: "Пелагик", competitions: [competition], score: 0)
        
        XCTAssertEqual(try teamService.getTeamsByCompetition(competitionName: "Байкал"), [team])
    }
}
