//
//  ServicesManager.swift
//  rfpr
//
//  Created by poliorang on 03.05.2023.
//

final class ServicesManager {
    let appConfig = config()
    var competitionService: ICompetitionService! = nil
    var participantService: IParticipantService! = nil
    var teamService: ITeamService! = nil
    var stepService: IStepService! = nil
    var lootService: ILootService! = nil
    
    var userService: UserService! = nil
    var authorizationService: AuthorizationService! = nil
    
    init() throws {
        do {
            try competitionService = CompetitionService(competitionRepository: CompetitionRepository(configRealm: appConfig.config), stepToCompetitionRepository: CompetitionRepository(configRealm: appConfig.config))
            try participantService = ParticipantService(participantRepository: ParticipantRepository(configRealm: appConfig.config),
                                                        participantByTeamRepository: ParticipantRepository(configRealm: appConfig.config))
            try teamService = TeamService(teamRepository: TeamRepository(configRealm: appConfig.config),
                                          participantRepository: ParticipantRepository(configRealm: appConfig.config),
                                          participantToTeamRepository: TeamRepository(configRealm: appConfig.config),
                                          competitionToTeamRepository: TeamRepository(configRealm: appConfig.config))
            try stepService = StepService(stepRepository: StepRepository(configRealm: appConfig.config),
                                          stepByParticipantRepository: StepRepository(configRealm: appConfig.config),
                                          lootToStepRepository: StepRepository(configRealm: appConfig.config))
            try lootService = LootService(lootRepository: LootRepository(configRealm: appConfig.config),
                                          lootByStepRepository: LootRepository(configRealm: appConfig.config))
            try authorizationService = AuthorizationService(authorizationRepository: AuthorizationRepository(configRealm: appConfig.config))
            try userService = UserService(userRepository: UserRepository(configRealm: appConfig.config))
            
        } catch {
            throw DatabaseError.openError
        }
    }
    
}
