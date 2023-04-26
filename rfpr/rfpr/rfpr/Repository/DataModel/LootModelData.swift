//
//  LootModelData.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//

import RealmSwift

class LootRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var fish: String
    @Persisted var weight: Int
    @Persisted var step: StepRealm?
    @Persisted var score: Int
    
    convenience init(id: String?, fish: String, weight: Int, step: StepRealm?, score: Int) throws {
        self.init()

        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.fish = fish
        self.weight = weight
        self.step = step
        self.score = score
    }
}

extension LootRealm {
    func convertLootFromRealm() -> Loot {
        return Loot(id: "\(self._id)", fish: self.fish, weight: self.weight, step: self.step?.convertStepFromRealm(), score: self.score)
    }
}



