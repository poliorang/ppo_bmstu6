//
//  ParticipantService.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

import Foundation

class ParticipantService: IParticipantService {
    
    let participantRepository: IParticipantRepository?
    let getDataService: IGetDataService?
    
    let participantByTeamRepository: IParticipantByTeamRepository?
    
    init(participantRepository: IParticipantRepository,
         getDataService: IGetDataService,
         participantByTeamRepository: IParticipantByTeamRepository) {
        self.participantRepository = participantRepository
        self.getDataService = getDataService
        
        self.participantByTeamRepository = participantByTeamRepository
    }
    
    
    func createParticipant(id: String?, lastName: String?, firstName: String?, patronymic: String?, team: Team?, city: String?, birthday: Date?, role: String?, score: Int) throws -> Participant {
        
        guard let lastName = lastName,
              let firstName = firstName,
              let city = city,
              let birthday = birthday,
              let role = role else {
                  throw ParameterError.funcParameterError
        }
        
        let participant = Participant(id: id, lastName: lastName, firstName: firstName, patronymic: patronymic, team: team, city: city, birthday: birthday, role: role, score: score)
        let createdParticipant: Participant?
        
        do {
            createdParticipant = try participantRepository?.createParticipant(participant: participant)
        } catch {
            throw DatabaseError.addError
        }
        
        guard let createdParticipant = createdParticipant else {
            throw DatabaseError.addError
        }
        
        return createdParticipant
    }
    
    func updateParticipant(previousParticipant: Participant?, newParticipant: Participant?) throws -> Participant {
        guard let previousParticipant = previousParticipant,
              let newParticipant = newParticipant else {
                  throw ParameterError.funcParameterError
        }
        
        let updatedParticipant: Participant?
        do {
            updatedParticipant = try participantRepository?.updateParticipant(previousParticipant: previousParticipant, newParticipant: newParticipant)
            
        } catch DatabaseError.updateError {
            throw DatabaseError.updateError
        }
        
        guard let updatedParticipant = updatedParticipant else {
            throw DatabaseError.updateError
        }
        
        return updatedParticipant
    }
    
    func deleteParticipant(participant: Participant?) throws {
        guard let participant = participant else {
            throw ParameterError.funcParameterError
            print("ParameterError")
        }
        
        do {
            try participantRepository?.deleteParticipant(participant: participant)
        } catch DatabaseError.deleteError {
            throw DatabaseError.deleteError
        }
    }
    
    func getParticipant(fullname: String?) throws -> [Participant]? {
        guard let fullname = fullname else {
            throw ParameterError.funcParameterError
        }
        
        let participants: [Participant]?
        do {
            try participants = participantRepository?.getParticipants()
        } catch DatabaseError.getError {
            throw DatabaseError.getError
        }
        
        guard let participants = participants else {
            return nil
        }
        
        var resultParticipants = [Participant]()
        
        for participant in participants {
            if findMatches(participant: participant, targetFullname: fullname) {
                resultParticipants.append(participant)
            }
        }
        
        if resultParticipants.isEmpty { return nil }
        
        return resultParticipants
    }
    
    func findMatches(participant: Participant, targetFullname: String) -> Bool {
        let fullname1 = participant.lastName + " " + participant.firstName + " " + (participant.patronymic ?? "")
        let fullname2 = participant.firstName + " " + participant.lastName + " " + (participant.patronymic ?? "")
        let fullname3 = participant.patronymic ?? "" + " " + participant.lastName + " " + participant.firstName
        let fullname4 = participant.patronymic  ?? "" + " " + participant.firstName + " " + participant.lastName
        let fullname5 = participant.firstName + " " + (participant.patronymic ?? "") + " " + participant.lastName
        let fullname6 = participant.lastName + " " + (participant.patronymic ?? "") + " " + participant.firstName
        
        var result = false
        [fullname1, fullname2, fullname3, fullname4, fullname5, fullname6].forEach {
            if $0.contains(targetFullname) {
                result = true
            }
        }
        
        return result
    }
    
    
    func getParticipants(parameter: SortParameter?, stepName: String?) throws -> [Participant]? {
        
        let participants: [Participant]?
        do {
            try participants = participantRepository?.getParticipants()
        } catch DatabaseError.deleteError {
            throw DatabaseError.getError
        }
        
        guard var participants = participants else {
            return nil
        }
        
        for i in 0..<participants.count {
            
            let steps = getDataService?.getStepsByParticipant(participant: participants[i], stepName: stepName)
            
            var score = 0
            if let steps = steps {
                for step in steps {
                    
                    let loots = getDataService?.getLootsByStep(step: step)
                    if let loots = loots {
                        for loot in loots { score += loot.score }
                    }
                }
            }
            
            participants[i].score = score
        }
        
        if parameter == .ascending {
            participants = participants.sorted(by: { $0.score < $1.score })
        }
        
        if parameter == .decreasing {
            participants = participants.sorted(by: { $0.score > $1.score })
        }
        
        return participants
    }
    
    func getParticipantByTeam(team: Team?) throws -> [Participant]? {
        guard let team = team else {
            throw ParameterError.funcParameterError
        }
        
        let participants = try participantByTeamRepository?.getParticipantByTeam(team: team)
        
        return participants
    }
}

