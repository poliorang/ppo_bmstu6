//
//  GetDataService.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//


class GetDataService: IGetDataService {
    
    let getDataRepository: IGetDataRepository?
    
    init(getDataRepository: IGetDataRepository) {
        self.getDataRepository = getDataRepository
    }
    
    func getStepsByParticipant(participant: Participant?, stepName: String?) -> [Step]? {
        let participant = participant!
        
        let steps: [Step]?
        if let stepName = stepName {
            steps = getDataRepository?.stepsWithParticipantIdWithStepName(participant: participant, stepName: stepName)
        } else {
            steps = getDataRepository?.stepsWithParticipantId(participant: participant)
        }
        
        return steps
    }
    
    
    func getLootsByStep(step: Step?) -> [Loot]? {
        let step = step!

        let loots = getDataRepository?.lootsWithSteptId(step: step)
        
        return loots
    }
}
