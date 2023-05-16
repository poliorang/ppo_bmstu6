//
//  TeamRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

class MockTeamRepository: ITeamRepository, ICompetitionToTeamRepository,
                        IParticipantToTeamRepository {
    
    private let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
    private let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
    private var team3 = Team(id: "1", name: "Пелагик", competitions: nil, score: 0)
    
    private var dbTeam = [Team]()
    
    private let competition = Competition(id: "1", name: "Байкал", teams: nil)
    private var dbCompetition = [Competition]()
    
    private var participant1 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 6600)
    private var participant2 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 9800)
    private var participant3 = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 2650)
    
    
    private var dbParticipant = [Participant]()
    
    
    func createTeam(team: Team) throws -> Team? {
        dbTeam.append(team)
        if dbTeam.contains(team) == false {
            throw DatabaseError.addError
        }
        
        return team
    }
    
    func updateTeam(previousTeam: Team, newTeam: Team) throws -> Team? {
        dbTeam.append(team1)
        
        if let index = dbTeam.firstIndex(where: { $0 == previousTeam }) {
            dbTeam.remove(at: index)
            dbTeam.append(newTeam)
        } else {
            throw DatabaseError.updateError
        }
        
        return newTeam
    }
    
    func deleteTeam(team removeTeam: Team) throws {
        dbTeam.append(team1)
        
        if let index = dbTeam.firstIndex(where: { $0 == removeTeam }) {
            print("SDJNCSKJDNCJKSDNKS \(removeTeam) \(index)")
            dbTeam.remove(at: index)
        } else {
            print("SDJNCSKJDNCJKSDNKS \(removeTeam)")
            throw DatabaseError.deleteError
        }
    }
    
    func getTeams() throws -> [Team]? {
        team3.competitions = [competition]
        [team3, team1, team2].forEach {
            dbTeam.append($0)
        }
        
        let teams = dbTeam
        if teams.isEmpty == false {
            return teams
        } else {
            throw DatabaseError.deleteError
        }
    }
    
    func addCompetition(team newTeam: Team, competition newCompetition: Competition) throws {
        dbTeam.append(team1)
        dbCompetition.append(competition)
        
        if let indexStep = dbTeam.firstIndex(where: { $0 == newTeam }) {
            if let indexCompetition = dbCompetition.firstIndex(where: { $0 == newCompetition }) {
                
                if let _ = dbTeam[indexStep].competitions {
                    dbTeam[indexStep].competitions!.append(dbCompetition[indexCompetition])
                } else {
                    dbTeam[indexStep].competitions = [dbCompetition[indexCompetition]]
                }
                
                if let _ = dbCompetition[indexStep].teams {
                    dbCompetition[indexCompetition].teams!.append(dbTeam[indexStep])
                } else {
                    dbCompetition[indexCompetition].teams = [dbTeam[indexStep]]
                }
            } else {
                throw DatabaseError.addError
            }
        } else {
            throw DatabaseError.addError
        }
    }
    
    func getTeamByParticipant(participant: Participant) throws -> Team? {
        return participant.team
    }
    
    func addParticipant(participant newPaticipant: Participant, team newTeam: Team) throws {
        dbParticipant.append(participant1)
        dbTeam.append(team1)
        
        if let indexTeam = dbTeam.firstIndex(where: { $0 == newTeam }) {
            if let indexParticipant = dbParticipant.firstIndex(where: { $0 == newPaticipant }) {
                dbParticipant[indexParticipant].team = newTeam
            } else {
                var newPaticipant = newPaticipant
                newPaticipant.team = dbTeam[indexTeam]
                dbParticipant.append(newPaticipant)
            }
        } else {
            throw DatabaseError.addError
        }
    }
    
    func getTeamScoreByCompetition(team: Team, competition: Competition, stepName: StepsName?) throws -> Team? {
        return nil
    }
}

