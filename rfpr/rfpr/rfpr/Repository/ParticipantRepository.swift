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
            realmParticipant = try participant.convertParticipantToRealm()
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
        
        let realmPreviousParticipant = try previousParticipant.convertParticipantToRealm()
        let realmNewParticipant = try newParticipant.convertParticipantToRealm()
        
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
        let realmParticipant = try participant.convertParticipantToRealm()
        
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
}

