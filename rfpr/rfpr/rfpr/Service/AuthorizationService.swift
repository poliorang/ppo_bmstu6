//
//  AuthorizationService.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

class AuthorizationService: IAuthorizationService {
    
    let authorizationRepository: IAuthorizationRepository?
    
    init(authorizationRepository: IAuthorizationRepository) {
        self.authorizationRepository = authorizationRepository
    }
    
    func createAuthorization(id: String?, login: String?, password: String?) throws -> Authorization? {
        guard let login = login,
              let password = password else {
            throw ParameterError.funcParameterError
        }
        
        let authorization = Authorization(id: id, login: login, password: password)
        let createdAuthorization: Authorization?
        
        do {
            createdAuthorization = try authorizationRepository?.createAuthorization(authorization: authorization)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdAuthorization = createdAuthorization else {
            throw DatabaseError.addError
        }
        
        return createdAuthorization
    }
    
    func updateAuthorization(previousAuthorization: Authorization?, newAuthorization: Authorization?) throws -> Authorization? {
        guard let previousAuthorization = previousAuthorization,
              let newAuthorization = newAuthorization else {
            throw ParameterError.funcParameterError
        }
        
        let updatedAuthorization: Authorization?
        do {
            updatedAuthorization = try authorizationRepository?.updateAuthorization(previousAuthorization: previousAuthorization, newAuthorization: newAuthorization)
        } catch DatabaseError.updateError {
            throw DatabaseError.updateError
        }
        
        guard let updatedAuthorization = updatedAuthorization else {
            throw DatabaseError.updateError
        }
        
        return updatedAuthorization
    }
    
    func deleteAuthorization(authorization: Authorization?) throws {
        guard let authorization = authorization else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try authorizationRepository?.deleteAuthorization(authorization: authorization)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getAuthorizationByLoginPassword(authorization: Authorization?) throws -> Authorization? {
        guard let authorization = authorization else {
            throw ParameterError.funcParameterError
        }
        
        let gettedAuthorization: Authorization?
        do {
            gettedAuthorization = try authorizationRepository?.getAuthorizationByLoginPassword(authorization: authorization)
        } catch {
            throw DatabaseError.getError
        }
        
        guard let gettedAuthorization = gettedAuthorization else {
            throw DatabaseError.getError
        }
        
        return gettedAuthorization
    }
    
    func getAuthorizations() throws -> [Authorization]? {
        let authorizations: [Authorization]?
        do {
            try authorizations = authorizationRepository?.getAuthorizations()
        } catch {
            throw DatabaseError.getError
        }
        
        return authorizations
    }
}
