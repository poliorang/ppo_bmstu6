//
//  ParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 15.04.2023.
//

import Foundation
import RealmSwift

class ParticipantRepository: IParticipantRepository, IParticipantByTeamRepository {
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
    
    func getParticipant(id: String) throws -> Participant? {
        let id = try ObjectId.init(string: id)
    
        let findedParticipant = realm.objects(ParticipantRealm.self).where {
            $0._id == id
        }.first

        if let findedParticipant = findedParticipant {
            return findedParticipant.convertParticipantFromRealm()
        }
        
        return nil
    }
    
    func createParticipant(participant: Participant) throws -> Participant? {
        let realmParticipant: ParticipantRealm
        
        do {
            realmParticipant = try participant.convertParticipantToRealm(realm)
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmParticipant)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdParticipant = try getParticipant(id: "\(realmParticipant._id)")
        
        return createdParticipant
    }
    
    func updateParticipant(previousParticipant: Participant, newParticipant: Participant) throws -> Participant? {
        var newParticipant = newParticipant
        newParticipant.id = previousParticipant.id
        
        let realmPreviousParticipant = try previousParticipant.convertParticipantToRealm(realm)
        let realmNewParticipant = try newParticipant.convertParticipantToRealm(realm)
        
        let participantFromDB = realm.objects(ParticipantRealm.self).where {
            $0._id == realmPreviousParticipant._id
        }.first
        
        guard participantFromDB != nil else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewParticipant, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedParticipant = try getParticipant(id: "\(realmNewParticipant._id)")
        
        return updatedParticipant
    }
    
    func deleteParticipant(participant: Participant) throws {
        let realmParticipant = try participant.convertParticipantToRealm(realm)
        
        let participantFromDB = realm.objects(ParticipantRealm.self).where {
            $0._id == realmParticipant._id
        }.first
        
        guard let participantFromDB = participantFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.delete(participantFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getParticipants() throws -> [Participant]? {
        let participantsRealm = realm.objects(ParticipantRealm.self)
        var participants = [Participant]()
        
        for participant in participantsRealm {
            participants.append(participant.convertParticipantFromRealm())
        }

        return participants.isEmpty ? nil : participants
    }
    
    func getParticipantByTeam(team: Team) throws -> [Participant]? {
        let participants = try! getParticipants()
//        print("AAAAAA ", participants)
        
        var resultParticipant = [Participant]()
        if let participants = participants {
            for participant in participants {
                
                if participant.team == team {
                    resultParticipant.append(participant)
                }
            }
        }
        
        return resultParticipant.isEmpty ? nil : resultParticipant
    }
    
    func getParticipantScoreByCompetition(participant: Participant, competition: Competition, stepName: StepsName?) throws -> Participant? {
        guard let participant = try getParticipant(id: participant.id!) else {
            throw ParameterError.funcParameterError
        }
        
        let participantRealm = try participant.convertParticipantToRealm(realm)
        let competitionRealm = try competition.convertCompetitionToRealm(realm)
        let stepsRealm = realm.objects(StepRealm.self)
        
        var newScore = 0
        for step in stepsRealm {
            if step.participant == participantRealm {
                if let stepName = stepName {
                    if step.name == stepName.rawValue && step.competition == competitionRealm { newScore += step.score }
                } else {
                    newScore += step.score
                }
            }
        }
        
        do {
            try realm.write {
                participantRealm.score = newScore
                realm.add(participantRealm, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let resultParticipant = participantRealm.convertParticipantFromRealm()
        
        return resultParticipant
    }
}

