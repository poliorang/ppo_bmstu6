//
//  ParticipantExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import Foundation

extension Participant {
    func convertParticipantToRealm() throws -> ParticipantRealm {
        do {
            return try ParticipantRealm(id: self.id, lastName: lastName, firstName: firstName, patronymic: patronymic, team: team?.convertTeamToRealm(), city: city, birthday: birthday, role: role, score: score)
        } catch {
            throw DatabaseError.addError
        }
    }
    
}
