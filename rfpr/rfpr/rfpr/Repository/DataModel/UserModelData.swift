//
//  UserModelData.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import RealmSwift

class UserRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var role: String
    @Persisted var authorization: AuthorizationRealm?
    
    convenience init(id: String?, role: String, authorization: AuthorizationRealm?) throws {
        self.init()

        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.role = role
        self.authorization = authorization
    }
}

extension UserRealm {
    func convertUserFromRealm() -> User {
        let role = Role(rawValue: self.role)!
        
        return User(id: "\(self._id)", role: role, authorization: self.authorization?.convertAuthorizationFromRealm())
    }
}

