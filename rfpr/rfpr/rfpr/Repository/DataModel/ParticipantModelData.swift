//
//  ParticipantModelData.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//
import Foundation
import RealmSwift


class ParticipantRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var lastName: String
    @Persisted var firstName: String
    @Persisted var patronymic: String?
    @Persisted var team: TeamRealm?
    @Persisted var city: String
    @Persisted var birthday: Date
    @Persisted var score: Int
    
    convenience init(id: String?, lastName: String, firstName: String, patronymic: String?, team: TeamRealm?, city: String, birthday: Date, score: Int) {
        self.init()
        
        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.lastName = lastName
        self.firstName = firstName
        self.team = team
        self.patronymic = patronymic
        self.city = city
        self.birthday = birthday
        self.score = score
    }
}

extension ParticipantRealm {
    func convertParticipantFromRealm() -> Participant {
        return Participant(id: "\(self._id)", lastName: lastName, firstName: firstName, patronymic: patronymic, team: team?.convertTeamFromRealm(), city: city, birthday: birthday, score: score)
    }
}
