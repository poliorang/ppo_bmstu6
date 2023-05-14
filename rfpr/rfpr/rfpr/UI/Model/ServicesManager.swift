//
//  ServicesManager.swift
//  rfpr
//
//  Created by poliorang on 03.05.2023.
//

final class ServicesManager {
    
    let appConfig = config()
    var competitionService: CompetitionService! = nil
    
    var getDataService: GetDataService! = nil
    var participantService: ParticipantService! = nil
    var teamService: TeamService! = nil
    var stepService: StepService! = nil
    var lootService: LootService! = nil
    
    init() throws {
        do {
            try competitionService = CompetitionService(competitionRepository: CompetitionRepository(configRealm: appConfig.config),                                                     teamToCompetitionRepository: CompetitionRepository(configRealm: appConfig.config),                                               stepToCompetitionRepository: CompetitionRepository(configRealm: appConfig.config))
            try getDataService = GetDataService(getDataRepository: GetDataRepository(configRealm: appConfig.config))
            try participantService = ParticipantService(participantRepository: ParticipantRepository(configRealm: appConfig.config),
                                                        getDataService: getDataService,
                                                        participantByTeamRepository: ParticipantRepository(configRealm: appConfig.config))
            try teamService = TeamService(teamRepository: TeamRepository(configRealm: appConfig.config),
                                          participantRepository: ParticipantRepository(configRealm: appConfig.config),
                                          getDataService: getDataService,
                                          participantToTeamRepository: TeamRepository(configRealm: appConfig.config),
                                          competitionToTeamRepository: TeamRepository(configRealm: appConfig.config))
            try stepService = StepService(stepRepository: StepRepository(configRealm: appConfig.config),
                                          stepByParticipantRepository: StepRepository(configRealm: appConfig.config),
                                          lootToStepRepository: StepRepository(configRealm: appConfig.config))
            try lootService = LootService(lootRepository: LootRepository(configRealm: appConfig.config),
                                          lootByStepRepository: LootRepository(configRealm: appConfig.config))
            
        } catch {
            throw DatabaseError.openError
        }
    }
    
}
