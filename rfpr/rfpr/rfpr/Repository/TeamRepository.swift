//
//  TeamRepository.swift
//  rfpr
//
//  Created by poliorang on 15.04.2023.
//

import Foundation
import RealmSwift

class TeamRepository: ITeamRepository, ICompetitionToTeamRepository,
                      IParticipantToTeamRepository, ITeamByParticipantRepository {
    
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
    
    func getTeam(id: String) throws -> Team? {
        let id = try ObjectId.init(string: id)
    
        let findedTeam = realm.objects(TeamRealm.self).where {
            $0._id == id
        }.first

        if let findedTeam = findedTeam {
            return findedTeam.convertTeamFromRealm()
        }
        
        return nil
    }
    
    
    func createTeam(team: Team) throws -> Team? {
        let realmTeam: TeamRealm
        
        do {
            realmTeam = try team.convertTeamToRealm()
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmTeam)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdTeam = try getTeam(id: "\(realmTeam._id)")
        
        return createdTeam
    }
    
    func updateTeam(previousTeam: Team, newTeam: Team) throws -> Team? {
        var newTeam = newTeam
        newTeam.id = previousTeam.id
        
        let realmPreviousTeam = try previousTeam.convertTeamToRealm()
        let realmNewTeam = try newTeam.convertTeamToRealm()
        
        let teamsFromDB = realm.objects(TeamRealm.self)
        var teamFromDB: TeamRealm? = nil
        
        for team in teamsFromDB {
            if team._id == realmPreviousTeam._id {
                teamFromDB = team
                break
            }
        }
            
        guard teamFromDB != nil else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewTeam, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedTeam = try getTeam(id: "\(realmNewTeam._id)")

        return updatedTeam
    }
    
    func deleteTeam(team: Team) throws {
        let realmTeam = try team.convertTeamToRealm()
        
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
        
        do {
            try realm.write {
                realm.delete(teamFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getTeams() throws -> [Team]? {
        let teamsRealm = realm.objects(TeamRealm.self)
        var teams = [Team]()
        
        for team in teamsRealm {
            teams.append(team.convertTeamFromRealm())
        }

        return teams.isEmpty ? nil : teams
    }

    func addCompetition(team: Team, competition: Competition) throws {
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
                teamFromDB.competitions.append(competitionFromDB)
                realm.add(teamFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func addParticipant(participant: Participant, team: Team) throws {
        let realmTeam = try team.convertTeamToRealm()
        let realmParticipant = try participant.convertParticipantToRealm()
        

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
        
        
        let participantsFromDB = realm.objects(ParticipantRealm.self)
        var participantFromDB: ParticipantRealm? = nil
        
        for participant in participantsFromDB {
            if participant._id == realmParticipant._id {
                participantFromDB = participant
                break
            }
        }
        
        guard let participantFromDB = participantFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                participantFromDB.team = teamFromDB
                realm.add(participantFromDB, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getTeamByParticipant(participant: Participant) throws -> Team? {
        let teams = try! getTeams()
        
        var resultTeam: Team? = nil
        if let teams = teams {
            for team in teams {
                if participant.team == team {
                    resultTeam = team
                    break
                }
            }
        }
        
        return resultTeam
    }
}
