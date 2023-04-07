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
    
    func getStepsByParticipant(id: Int?, stepName: String?) -> [Step]? {
        guard let id = id else {
            return nil
        }

        let steps: [Step]?
        if let stepName = stepName {
            steps = getDataRepository?.stepsWithParticipantIdWithStepName(id: id, stepName: stepName)
        } else {
            steps = getDataRepository?.stepsWithParticipantId(id: id)
        }
        
        return steps
    }
    
    
    func getLootsByStep(id: Int?) -> [Loot]? {
        guard let id = id else {
            return nil
        }

        let loots = getDataRepository?.lootsWithSteptId(id: id)
        
        return loots
    }
}
