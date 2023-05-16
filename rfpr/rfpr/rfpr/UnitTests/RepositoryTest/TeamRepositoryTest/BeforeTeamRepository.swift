//
//  BeforeTeamRepository.swift
//  rfpr
//
//  Created by poliorang on 22.04.2023.
//

class BeforeTeamRepositoryTest {
    var teamRepository: TeamRepository!
    var participantRepository: ParticipantRepository!
    var competitionRepository: CompetitionRepository!
    
    func setupRepository(config: String) throws {
        do {
            teamRepository = try TeamRepository(configRealm: config)
            participantRepository = try ParticipantRepository(configRealm: config)
            competitionRepository = try CompetitionRepository(configRealm: config)
            
            try teamRepository.realmDeleteAll()
            try participantRepository.realmDeleteAll()
            try competitionRepository.realmDeleteAll()
        } catch {
            print("Не удалось открыть Realm: \(config)")
            throw DatabaseError.openError
        }
    }
    
    func createData() throws {

        let teamUpdate = Team(id: "5442852b2b74d595cb4f4708", name: "Update", competitions: nil, score: 0)
        let teamDelete = Team(id: "5442852b2b74d595cb4f4720", name: "Delete", competitions: nil, score: 0)
        let teamAddCompetition = Team(id: "5442852b2b74d595cb4f4724", name: "Add Competition", competitions: nil, score: 0)
        let teamAddTeam = Team(id: "5442852b2b74d595cb4f4734", name: "AddParticipant", competitions: nil, score: 0)
        let teamBy = Team(id: "5442852b2b74d595cb4f4738", name: "Команда Гурова", competitions: nil, score: 0)
        
        let participantBy = Participant(id: "5442852b2b74d595cb4f4742", lastName: "Гуров", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let participantAdd = Participant(id: "5442852b2b74d595cb4f4730", lastName: "Абрамов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        let participantNilTeam = Participant(id: "5442852b2b74d595cb4f4755", lastName: "Артемов", firstName: "Иван", patronymic: "Иванович", team: nil, city: "Москва", birthday: bith, score: 0)
        
        let competitionAdd = Competition(id: "5442852b2b74d595cb4f4728", name: "Added", teams: nil)
        
        do {
            try [competitionAdd].forEach {
                try _ = competitionRepository.createCompetition(competition: $0)
            }
            try [teamUpdate, teamDelete, teamAddCompetition, teamAddTeam, teamBy].forEach {
                try _ = teamRepository.createTeam(team: $0)
            }
            try [participantAdd, participantBy, participantNilTeam].forEach {
                try _ = participantRepository.createParticipant(participant: $0)
            }
            
            let participantBy1 = Participant(id: "5442852b2b74d595cb4f4742", lastName: "Гуров", firstName: "Иван", patronymic: "Иванович", team: teamBy, city: "Москва", birthday: bith, score: 0)
            
            try _ = participantRepository.updateParticipant(previousParticipant: participantBy, newParticipant: participantBy1)
        
        } catch {
                throw DatabaseError.addError
        }
    }
    
}
