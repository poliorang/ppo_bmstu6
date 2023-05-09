//
//  CompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 15.04.2023.
//

import Foundation
import RealmSwift

class CompetitionRepository: ICompetitionRepository, IStepToCompetitionRepository, ITeamToCompetitionRepository {
    
    let realm: Realm!
    var config: Realm.Configuration!
    init(configRealm: String) throws {
        do {
            config = Realm.Configuration.defaultConfiguration
            config.fileURL!.deleteLastPathComponent()
            config.fileURL!.appendPathComponent("\(configRealm).realm")
            
            self.realm = try Realm(configuration: config)
        } catch {
            throw ConnectionError.realmConnectError
        }
    }
    
    func realmDeleteAll() throws {
        do {
            try realm.write {
              realm.deleteAll()
            }
        } catch {
            throw DatabaseError.deleteAllError
        }
    }
    
    func getCompetition(id: String) throws -> Competition? {
        let id = try ObjectId.init(string: id)
    
        let findedCompetition = realm.objects(CompetitionRealm.self).where {
            $0._id == id
        }.first

        if let findedCompetition = findedCompetition {
            return findedCompetition.convertCompetitionFromRealm()
        }
        
        return nil
    }
    
    func createCompetition(competition: Competition) throws -> Competition? {
        let realmCompetition: CompetitionRealm
        
        do {
            realmCompetition = try competition.convertCompetitionToRealm()
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmCompetition)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdCompetition = try getCompetition(id: "\(realmCompetition._id)")
        
        return createdCompetition
    }
    
    func updateCompetition(previousCompetition: Competition, newCompetition: Competition) throws -> Competition? {
        var newCompetition = newCompetition
        newCompetition.id = previousCompetition.id
        
        let realmPreviousCompetition = try previousCompetition.convertCompetitionToRealm()
        let realmNewCompetition = try newCompetition.convertCompetitionToRealm()
        
        let competitionsFromDB = realm.objects(CompetitionRealm.self)
        var competitionFromDB: CompetitionRealm? = nil
        
        for competition in competitionsFromDB {
            if competition._id == realmPreviousCompetition._id {
                competitionFromDB = competition
                break
            }
        }
            
        guard let _ = competitionFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewCompetition, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedCompetition = try getCompetition(id: "\(realmNewCompetition._id)")

        return updatedCompetition
    }
    
    func deleteCompetition(competition: Competition) throws {
        let realmCompetition = try competition.convertCompetitionToRealm()
        
        let competitionsFromDB = realm.objects(CompetitionRealm.self)
        var competitionFromDB: CompetitionRealm? = nil
        
        for competition in competitionsFromDB {
            if competition._id == realmCompetition._id {
                competitionFromDB = competition
                break
            }
        }
        
        guard let competitionFromDB = competitionFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.delete(competitionFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getCompetitions() throws -> [Competition]? {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let competitionsRealm = realm.objects(CompetitionRealm.self)
        var competitions = [Competition]()
        
        for competition in competitionsRealm {
            competitions.append(competition.convertCompetitionFromRealm())
        }

        return competitions.isEmpty ? nil : competitions
    }
    
    func addStep(step: Step, competition: Competition) throws {
        let realmStep = try step.convertStepToRealm()
        let realmCompetition = try competition.convertCompetitionToRealm()
        
        let stepFromDB = realm.objects(StepRealm.self).where {
            $0._id == realmStep._id
        }.first
        
        guard let stepFromDB = stepFromDB else {
            throw ParameterError.funcParameterError
        }
        
        let competitionsFromDB = realm.objects(CompetitionRealm.self)
        var competitionFromDB: CompetitionRealm? = nil
        
        for competition in competitionsFromDB {
            if competition._id == realmCompetition._id {
                competitionFromDB = competition
                break
            }
        }
        
        guard let competitionFromDB = competitionFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                stepFromDB.competition = competitionFromDB
                realm.add(stepFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func addTeam(team: Team, competition: Competition) throws {
        let realmTeam = try team.convertTeamToRealm()
        let realmCompetition = try competition.convertCompetitionToRealm()
        
        let teamsFromDB = realm.objects(TeamRealm.self)
        var teamFromDB: TeamRealm? = nil
        
        for team in teamsFromDB {
            if team._id == realmTeam._id {
                teamFromDB = team
                break
            }
        }
        
        guard let teamFromDB = teamFromDB else {
            throw ParameterError.funcParameterError
        }
        
        let competitionsFromDB = realm.objects(CompetitionRealm.self)
        var competitionFromDB: CompetitionRealm? = nil
        
        for competition in competitionsFromDB {
            if competition._id == realmCompetition._id {
                competitionFromDB = competition
                break
            }
        }
        
        guard let competitionFromDB = competitionFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                competitionFromDB.teams.append(teamFromDB)
                realm.add(competitionFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
}
