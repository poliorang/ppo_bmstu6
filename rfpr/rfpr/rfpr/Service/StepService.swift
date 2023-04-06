//
//  StepService.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

class StepService: IStepService {

    let stepRepository: IStepRepository?
    
    init(stepRepository: IStepRepository) {
        self.stepRepository = stepRepository
    }
    
    func createStep(id: Int?, name: String?, participant: Participant?, competition: Competition?) -> Step? {
        let step = stepRepository?.createStep(id: id, name: name, participant: participant, competition: competition)
        
        return step 
    }
    
    func updateStep(id: Int?) {
        stepRepository?.updateStep(id: id)
    }
    
    func deleteStep(id: Int?) {
        stepRepository?.deleteStep(id: id)
    }
}

