//
//  UserService.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

class UserService: IUserService {
    
    let userRepository: IUserRepository?
    
    init(userRepository: IUserRepository) {
        self.userRepository = userRepository
    }
    
    func createUser(id: String?, role: Role?, authorization: Authorization?) throws -> User? {
        guard let role = role else {
            throw ParameterError.funcParameterError
        }
        
        let user = User(id: id, role: role, authorization: authorization)
        let createdUser: User?
        
        do {
            createdUser = try userRepository?.createUser(user: user)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdUser = createdUser else {
            throw DatabaseError.addError
        }
        
        return createdUser
    }
    
    func updateUser(previousUser: User?, newUser: User?) throws -> User? {
        guard let previousUser = previousUser,
              let newUser = newUser else {
            throw ParameterError.funcParameterError
        }
        
        let updatedUser: User?
        do {
            updatedUser = try userRepository?.updateUser(previousUser: previousUser, newUser: newUser)
        } catch DatabaseError.updateError {
            throw DatabaseError.updateError
        }
        
        guard let updatedUser = updatedUser else {
            throw DatabaseError.updateError
        }
        
        return updatedUser
    }
    
    func deleteUser(user: User?) throws {
        guard let user = user else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try userRepository?.deleteUser(user: user)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getUsers() throws -> [User]? {
        let users: [User]?
        do {
            try users = userRepository?.getUsers()
        } catch {
            throw DatabaseError.getError
        }
        
        return users
    }
    
    func getUserByAuthorization(authorization: Authorization?) throws -> User? {
        guard let authorization = authorization else {
            throw ParameterError.funcParameterError
        }
        
        let user: User?
        do {
            try user = userRepository?.getUserByAuthorization(authorization: authorization)
        } catch {
            throw DatabaseError.getError
        }
        
        return user
    }
}
