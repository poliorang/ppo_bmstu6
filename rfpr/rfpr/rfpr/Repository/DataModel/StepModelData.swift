//
//  StepModelData.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//

import RealmSwift

class StepRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var participant: ParticipantRealm?
    @Persisted var competition: CompetitionRealm?
    @Persisted var score: Int
    
    convenience init(id: String?, name: String, participant: ParticipantRealm?, competition: CompetitionRealm?, score: Int) {
        self.init()
        
        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.name = name
        self.participant = participant
        self.competition = competition
        self.score = score
    }
}

extension StepRealm {
    func convertStepFromRealm() -> Step {
        return Step(id: "\(self._id)", name: self.name, participant: self.participant?.convertParticipantFromRealm(), competition: self.competition?.convertCompetitionFromRealm(), score: self.score)
    }
}
