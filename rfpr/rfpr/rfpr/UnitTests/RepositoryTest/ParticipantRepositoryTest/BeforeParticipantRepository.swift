//
//  BeforeParticipantRepository.swift
//  rfpr
//
//  Created by poliorang on 22.04.2023.
//

class BeforeParticipantRepositoryTest {
    var participantRepository: ParticipantRepository!
    var teamRepository: TeamRepository!
    
    func setupRepository(config: String) throws {
        do {
            participantRepository = try ParticipantRepository(configRealm: config)
            teamRepository = try TeamRepository(configRealm: config)
            
            try participantRepository.realmDeleteAll()
            try teamRepository.realmDeleteAll()
        } catch {
            print("Не удалось открыть Realm: \(config)")
            throw DatabaseError.openError
        }
    }
    
    
    func createData() throws {
        let participantUpdate = Participant(id: "4442852b2b74d595cb4f4700", lastName: "Иванов", firstName: "Иван", patronymic: "Иванович", city: "Москва", birthday: bith, score: 0)
        let participantDelete = Participant(id: "4442852b2b74d595cb4f4704", lastName: "Алексеев", firstName: "Алексей", city: "Москва", birthday: bith, score: 0)
    
        let team = Team(id: "4442852b2b74d595cb4f4732", name: "Козлов и Захаров", competitions: nil, score: 0)
        let participant1 = Participant(id: "4442852b2b74d595cb4f4720", lastName: "Козлов", firstName: "Иван", team: nil, city: "Москва", birthday: bith, score: 0)
        let participant2 = Participant(id: "4442852b2b74d595cb4f4724", lastName: "Звягин", firstName: "Иван", team: nil, city: "Москва", birthday: bith, score: 0)
        let participant3 = Participant(id: "4442852b2b74d595cb4f4728", lastName: "Захаров", firstName: "Иван", team: nil, city: "Москва", birthday: bith, score: 0)
        
        do {
            try [team].forEach {
                try _ = teamRepository.createTeam(team: $0)
            }
            
            try [participantUpdate, participantDelete, participant1, participant2, participant3].forEach {
                try _ =  participantRepository.createParticipant(participant: $0)
            }
            
            let participant11 = Participant(id: "4442852b2b74d595cb4f4720", lastName: "Козлов", firstName: "Иван", team: team, city: "Москва", birthday: bith, score: 0)
            let participant33 = Participant(id: "4442852b2b74d595cb4f4728", lastName: "Захаров", firstName: "Иван", team: team, city: "Москва", birthday: bith, score: 0)
            
            
            try _ = participantRepository.updateParticipant(previousParticipant: participant1, newParticipant: participant11)
            try _ = participantRepository.updateParticipant(previousParticipant: participant3, newParticipant: participant33)
            
        } catch {
                throw DatabaseError.addError
        }
    }
    
}

