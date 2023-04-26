//
//  TeamModelData.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//

import RealmSwift

class TeamRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var competitions: List<CompetitionRealm>
    @Persisted var score: Int
    
    convenience init(id: String?, name: String, competitions: List<CompetitionRealm>, score: Int) {
        self.init()
        
        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.name = name
        self.competitions = competitions 
        self.score = score
    }
}


extension TeamRealm {
    func convertTeamFromRealm() -> Team {
        if competitions.isEmpty { return Team(id: "\(self._id)", name: name, competitions: nil, score: score) }
        
        var competitions = [Competition]()
        
        for competition in self.competitions {
            competitions.append(competition.convertCompetitionFromRealm())
        }
    
        return Team(id: "\(self._id)", name: name, competitions: competitions, score: score)
    }
}

extension TeamRealm {
    static func compareTeamsRealm(listRealm1: List<TeamRealm>, listRealm2: List<TeamRealm>) -> Bool {
        if listRealm1.count != listRealm2.count { return false }
        
        var set1 = Set<Team>()
        var set2 = Set<Team>()
        
        for i in 0..<listRealm1.count {
            set1.insert(listRealm1[i].convertTeamFromRealm())
            set2.insert(listRealm2[i].convertTeamFromRealm())
        }
        
        return set1 == set2 ? true : false
    }
}
