//
//  ParticipantExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import Foundation
import RealmSwift

extension Participant {
    func convertParticipantToRealm(_ realm: Realm) throws -> ParticipantRealm {
        // проверка, что уже есть в бд
        var participantFromDB: ParticipantRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            participantFromDB = realm.objects(ParticipantRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let participantFromDB = participantFromDB {
            return participantFromDB
        }
        
        do {
            return try ParticipantRealm(id: self.id, lastName: lastName, firstName: firstName, patronymic: patronymic, team: team?.convertTeamToRealm(realm), city: city, birthday: birthday, score: score)
        } catch {
            throw DatabaseError.addError
        }
    }
    
}
