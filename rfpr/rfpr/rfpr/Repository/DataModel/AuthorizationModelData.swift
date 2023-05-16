//
//  AuthorizationModelData.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import RealmSwift

class AuthorizationRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var login: String
    @Persisted var password: String
    
    convenience init(id: String?, login: String, password: String) throws {
        self.init()

        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.login = login
        self.password = password
    }
}

extension AuthorizationRealm {
    func convertAuthorizationFromRealm() -> Authorization {
        return Authorization(id: "\(self._id)", login: self.login, password: self.password)
            
    }
}

