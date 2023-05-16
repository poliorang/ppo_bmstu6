//
//  CompetitionRepositoryTest.swift
//  UnitTestAutorization
//
//  Created by poliorang on 10.04.2023.
//

import XCTest
import RealmSwift
@testable import rfpr

fileprivate var competitionRepository: CompetitionRepository!
fileprivate var config = "CompetitionRepositoryTests"
fileprivate var beforeTestClass: BeforeCompetitionRepositoryTest!

class CompetitionRepositoryTest: XCTestCase {
    override class func setUp() {
        super.setUp()
        do {
            competitionRepository = try CompetitionRepository(configRealm: config)
        } catch {
            print("Не удалось открыть Realm: \(config)")
            exit(-1)
        }
        
        beforeTestClass = BeforeCompetitionRepositoryTest()
        
        do {
            try beforeTestClass.setupRepository(config: config)
            try beforeTestClass.createData()
        } catch {
            print("Не удалось загрузить данные: \(config)")
            exit(-1)
        }
    }

    override class func tearDown() {
        competitionRepository = nil
        beforeTestClass = nil
        super.tearDown()
    }
    
    func testCreateCompetition() throws {
        let team1 = Team(id: "6442852b2b74d595cb4f4746", name: "Увильды", competitions: nil, score: 0)
        let team2 = Team(id: "6442852b2b74d595cb4f4742", name: "Байкал", competitions: nil, score: 0)

        let competition = Competition(id: "6442852b2b74d595cb4f4750", name: "Урал", teams: [team1, team2])
        var createdCompetition: Competition?

        XCTAssertNoThrow(try createdCompetition = competitionRepository.createCompetition(competition: competition))
        XCTAssertEqual(createdCompetition, competition)
    }
    
    func testCreateCompetitionNilTeam() throws {
        let competition = Competition(id: "6442852b2b74d595cb4f4754", name: "Юг", teams: nil)
        var createdCompetition: Competition?
        
        XCTAssertNoThrow(try createdCompetition = competitionRepository.createCompetition(competition: competition))
        XCTAssertEqual(createdCompetition, competition)
    }
    
//    func testUpdateCompetition() throws {
//        let previousCompetition = Competition(id: "6442852b2b74d595cb4f4760", name: "Update", teams: nil)
//        let newCompetition = Competition(id: "6442852b2b74d595cb4f4760", name: "Updated", teams: nil)
//        var updetedCompetition: Competition?
//
//        XCTAssertNoThrow(try updetedCompetition = competitionRepository.updateCompetition(previousCompetition: previousCompetition, newCompetition: newCompetition))
//        XCTAssertEqual(updetedCompetition, newCompetition)
//    }
    
//    func testUpdateCompetitionNil() throws {
//        let previousCompetition = Competition(id: "6442852b2b74d595cb4f1760", name: "Север", teams: nil)
//        let newCompetition = Competition(id: "6442852b2b74d595cb4f1760", name: "Сахалин", teams: nil)
//
//        XCTAssertThrowsError(try competitionRepository.updateCompetition(previousCompetition: previousCompetition, newCompetition: newCompetition))
//    }
    
    func testDeleteCompetition() throws {
        let competition = Competition(id: "6442852b2b74d595cb4f4764", name: "Delete", teams: nil)
        
        XCTAssertNoThrow(try competitionRepository.deleteCompetition(competition: competition))
        XCTAssertEqual(try competitionRepository.getCompetition(id: "6442852b2b74d595cb4f4764"), nil)
    }
    
    func testDeleteCompetitionNil() throws {
        let competition = Competition(id: "1442852b2b74d595cb4f4764", name: "Атлантика", teams: nil)
        
        XCTAssertThrowsError(try competitionRepository.deleteCompetition(competition: competition))
    }

    
    func testAddStep() throws {
        let step = Step(id: "6442852b2b74d595cb4f4756", name: "Add competition", score: 0)
        let competition = Competition(id: "6442852b2b74d595cb4f4768", name: "Add", teams: nil)
        
        XCTAssertNoThrow(try competitionRepository.addStep(step: step, competition: competition))
    }
    
    func testAddStepNilStep() throws {
        let step = Step(id: "6442852b2b74d595cb4f4751", name: "", score: 0)
        let competition = Competition(id: "6442852b2b74d595cb4f4768", name: "Add", teams: nil)
        
        XCTAssertThrowsError(try competitionRepository.addStep(step: step, competition: competition))
    }
    
    func testAddStepNiCompetitionl() throws {
        let step = Step(id: "6442852b2b74d595cb4f4756", name: "Add competition", score: 0)
        let competition = Competition(id: "6442852b2b74d595cb4f4711", name: "", teams: nil)
        
        XCTAssertThrowsError(try competitionRepository.addStep(step: step, competition: competition))
    }
    
//    func testAddTeam() throws {
//        let team = Team(id: "6442852b2b74d595cb4f4776", name: "Add Competition", competitions: nil, score: 0)
//        let competition = Competition(id: "6442852b2b74d595cb4f4772", name: "Added Team", teams: nil)
//
//        XCTAssertNoThrow(try competitionRepository.addTeam(team: team, competition: competition))
//    }
//
//    func testAddTeamNilTeam() throws {
//        let team = Team(id: "6442852b2b74d595cb4f4700", name: "", competitions: nil, score: 0)
//        let competition = Competition(id: "6442852b2b74d595cb4f4772", name: "Added Team", teams: nil)
//
//        XCTAssertThrowsError(try competitionRepository.addTeam(team: team, competition: competition))
//    }
//
//    func testAddTeamNilCompetition() throws {
//        let team = Team(id: "6442852b2b74d595cb4f4700", name: "", competitions: nil, score: 0)
//        let competition = Competition(id: "6442852b2b74d595cb4f4700", name: "", teams: nil)
//
//        XCTAssertThrowsError(try competitionRepository.addTeam(team: team, competition: competition))
//    }
//    
//    func testGetCompetition() throws {
//        let competitions = [
//            Competition(id: "6442852b2b74d595cb4f4772", name: "Added Team",
//                        teams: [Team(id: "6442852b2b74d595cb4f4776", name: "Add Competition", competitions: nil, score: 0)]),
//            Competition(id: "6442852b2b74d595cb4f4768", name: "Add", teams: nil),
//            
//            Competition(id: "6442852b2b74d595cb4f4750", name: "Урал",
//                        teams: [Team(id: "6442852b2b74d595cb4f4746", name: "Увильды", competitions: nil, score: 0),
//                                Team(id: "6442852b2b74d595cb4f4742", name: "Байкал", competitions: nil, score: 0)]),
//            Competition(id: "6442852b2b74d595cb4f4754", name: "Юг", teams: nil)]
//        
//
//        XCTAssertEqual(Set(try competitionRepository.getCompetitions() ?? []), Set(competitions))
//    }
}
