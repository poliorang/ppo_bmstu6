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
    var getDataRepository: IGetDataRepository!
    var getDataService: IGetDataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        getDataRepository = MockGetDataRepository()
        getDataService = GetDataService(getDataRepository: getDataRepository)
        
        participantRepository = MockParticipantRepository()
        
        teamRepository = MockTeamRepository()
        teamService = TeamService(teamRepository: teamRepository,
                                  participantRepository: participantRepository,
                                  getDataService: getDataService,
                                  participantToTeamRepository: teamRepository as! IParticipantToTeamRepository,
                                  competitionToTeamRepository: teamRepository as! ICompetitionToTeamRepository)
    }

    override func tearDownWithError() throws {
        teamService = nil
        teamRepository = nil
        getDataService = nil
        getDataRepository = nil
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
    
    func testsGetTeamsByAscendingNilStep() throws {
        
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 9800)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 6600)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 2650)
        
        let teams = [team3, team2, team1]

        XCTAssertEqual(try teamService.getTeams(parameter: .ascending, stepName: nil), teams)
    }
    
    func testsGetTeamsByDecreasingNilStep() throws {
        
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 9800)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 6600)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 2650)
        
        let teams = [team1, team2, team3]

        XCTAssertEqual(try teamService.getTeams(parameter: .decreasing, stepName: nil), teams)
    }
    
    func testsGetTeamsByNilNilStep() throws {
        
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 9800)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 6600)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 2650)
        
        let teams = [team3, team1, team2]

        XCTAssertEqual(try teamService.getTeams(parameter: nil, stepName: nil), teams)
    }
    
    func testsGetTeamsByAscending() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 1300)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 1600)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 2200)
        
        let teams = [team1, team2, team3]

        XCTAssertEqual(try teamService.getTeams(parameter: .ascending, stepName: "2"), teams)
    }
    
    func testsGetTeamsByDecreasing() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 1300)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 1600)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 2200)
        
        let teams = [team3, team2, team1]

        XCTAssertEqual(try teamService.getTeams(parameter: .decreasing, stepName: "2"), teams)
    }
    
    func testsGetTeamsByNil() throws {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 1300)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 1600)
        let team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 2200)
        
        let teams = [team3, team1, team2]

        XCTAssertEqual(try teamService.getTeams(parameter: nil, stepName: "2"), teams)
    }

}
