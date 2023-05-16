//
//  StepExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import RealmSwift

extension Step {
    
    func convertStepToRealm(_ realm: Realm) throws -> StepRealm {
        
        // проверка, что уже есть в бд
        var stepFromDB: StepRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            stepFromDB = realm.objects(StepRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let stepFromDB = stepFromDB {
            return stepFromDB
        }
        
        var participantRealm: ParticipantRealm? = nil
        var competitionRealm: CompetitionRealm? = nil
        
        if let participant = self.participant {
            do {
                try participantRealm = ParticipantRealm(id: participant.id, lastName: participant.lastName, firstName: participant.firstName, patronymic: participant.patronymic, team: participant.team?.convertTeamToRealm(realm), city: participant.city, birthday: participant.birthday, score: participant.score)
            } catch {
                throw DatabaseError.addError
            }
            
        }
        
        if let competition = self.competition {
            let teamsRealm = List<TeamRealm>()
            if let teams = competition.teams {
                for team in teams {
                    do {
                        try teamsRealm.append(team.convertTeamToRealm(realm))
                    } catch {
                        throw DatabaseError.addError
                    }
                }
            }
            
            competitionRealm = CompetitionRealm(id: competition.id, name: competition.name, teams: teamsRealm)
        }
            
        return StepRealm(id: self.id, name: self.name, participant: participantRealm, competition: competitionRealm, score: self.score)
    }
}
