//
//  DetailLootController.swift
//  rfpr
//
//  Created by poliorang on 10.05.2023.
//

import UIKit

class DetailLootViewController: UIViewController, ToLootDelegateProtocol, ToDetailLootDelegateProtocol {
    
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    var participant: Participant?       // получить из ParticipantLootController
    var gettedCompletion: (() -> Void)? // обновление таблицы в PariticipantLootController
    var updateLoot: Loot?               // получить из DetailLootController
    
    let fishes = ["Щука", "Окунь", "Линь", "Лещ", "Карась",
                  "Карп", "Сазан", "Белый амур", "Судак",
                  "Сом", "Жерех", "Плотва", "Язь", "Голавль",
                  "Налим", "Ёрш"]
    
    let stepsName = [StepsName.day1.rawValue, StepsName.day2.rawValue]
    let weights = Array(500...7500).map { String($0) }
    
    let competitionTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    let stepTextField = UITextField(frame: CGRect(x: 20, y: 160, width: 300, height: 40))
    let fishNameTextField = UITextField(frame: CGRect(x: 20, y: 240, width: 300, height: 40))
    let weightTextField = UITextField(frame: CGRect(x: 20, y: 300, width: 100, height: 40))
    let scoreTextField = UITextField(frame: CGRect(x: 220, y: 300, width: 100, height: 40))
    
    var selectedTextField: UITextField? = nil
    
    var competitions: [Competition]?
    var competition: Competition?       // получить из PartLootController
    
    let picker = UIPickerView()
    let pickerToolBar = UIToolbar()
    
    let createLootButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupServices()
        getCompetitions()
        
        setupParametersTextFields(stepTextField, fishNameTextField, weightTextField, scoreTextField,
                                  picker, pickerToolBar)
        setupPicker(picker)
        setupPickerToolBar(pickerToolBar)
        setupCreateLootButton(createLootButton)
        
        setupUpdate()
        print("UOD ", updateLoot)
    }
    
    // delegate
    func sendPartToLootViewController(participant: Participant?) {
        guard let participant = participant else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Участник не распознан")
            return
        }

        self.participant = participant
    }
    
    // delegate
    func sendCompetitionDetailToLootViewController(competition: Competition?) {
        guard let competition = competition else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Сореванование не распознано")
            return
        }

        self.competition = competition
    }
    
    // delegate
    func sendUpdatedLootDetailToLootViewController(loot: Loot?) {
        guard let loot = loot else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Улов не распознан")
            return
        }

        self.updateLoot = loot
    }
    
    private func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }
    
    private func getCompetitions() {
        do {
            try competitions = services.competitionService.getCompetitions()
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "В базе данных нет ни одного соревнования")
        }
    }
    
    private func setupParametersTextFields(_ step: UITextField,
                                           _ fish: UITextField, _ weight: UITextField, _ score: UITextField,
                                           _ picker: UIPickerView, _ toolBar: UIToolbar) {
        [step, fish, weight, score].forEach {
            view.addSubview($0)
            $0.delegate = self
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
            if $0 != score {
                $0.inputView = picker
                $0.inputAccessoryView = toolBar
            }
        }
//
//        competition.placeholder = "Соревнование"
        step.placeholder = "Этап"
        fish.placeholder = "Рыба"
        weight.placeholder = "Вес"
        score.placeholder = "Очки"
    }
    
    private func setupPicker(_ picker: UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
        
    }
    
    private func setupPickerToolBar(_ toolBar: UIToolbar) {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
    }
    
    func setupCreateLootButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 110),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        createLootButton.addTarget(self, action: #selector(buttonCreateLootTapped(sender:)), for: .touchUpInside)
    }
    
    private func setupUpdate() {
        if let updateLoot = updateLoot {
            fishNameTextField.text = updateLoot.fish
            stepTextField.text = updateLoot.step?.name
            weightTextField.text = "\(updateLoot.weight)"
            scoreTextField.text = "\(updateLoot.score)"
        }
    }
    
    @objc
    func donePicker() {
        selectedTextField?.resignFirstResponder()
    }
    
    @objc
    func buttonCreateLootTapped(sender: UIButton) {
        guard let competitionName = competitionTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите соревнование")
            return
        }
        
        guard let stepName = stepTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите этап")
            return
        }
        
        guard let fish = fishNameTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите название рыбы")
            return
        }
        
        guard let weight = weightTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите вес")
            return
        }
        
        let weightInt = Int(weight)
        
        if participant != nil {
            do {
                let stepsByName = try services.stepService.getStepByName(stepName: stepName)
                let stepsByParticipant = try services.stepService.getStepByParticipant(participant: participant)
                let stepsByCompetition = try services.stepService.getStepByCompetition(competition: competition)
                
                var currentStep = Set(stepsByName ?? []).intersection(Set(stepsByParticipant ?? [])).intersection(Set(stepsByCompetition ?? [])).first
                
                if currentStep == nil {
                    currentStep = try services.stepService.createStep(id: nil, name: stepName, participant: nil, competition: nil)
                    try services.stepService.addParticipant(participant: participant, step: currentStep)
                    try services.competitionService.addStep(step: currentStep, competition: competition)
                }
                
                guard let weightInt = weightInt else {
                    alertManager.showAlert(presentTo: self, title: "Внимание", message: "Вес и очки не определены")
                    return
                }
                
                if let updateLoot = updateLoot {
                    print("updateLoot ", updateLoot)
                    let newLoot = Loot(id: updateLoot.id, fish: fish, weight: weightInt, step: currentStep, score: weightInt + 500)
                    _ = try services.lootService.updateLoot(previousLoot: updateLoot, newLoot: newLoot)
                    
                } else {
                    _ = try services.lootService.createLoot(id: nil, fish: fish, step: currentStep, weight: weightInt)
    //                try services.stepService.addLoot(loot: loot, step: currentStep)
                }
                
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание", message: "Улов не был засчитан")
            }
            
        } else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Участник не найден")
        }
        
        dismiss(animated: true, completion: gettedCompletion)
    }
}

extension DetailLootViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == scoreTextField {
            return false
        }
        
        return true
    }
}

extension DetailLootViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedTextField {
            
        case competitionTextField:
            return competitions?.count ?? 0
            
        case stepTextField:
            return stepsName.count
            
        case fishNameTextField:
            return fishes.count
            
        case weightTextField:
            return weights.count
            
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTextField {
            
        case competitionTextField:
            return competitions?[row].name ?? ""
            
        case stepTextField:
            return stepsName[row]
            
        case fishNameTextField:
            return fishes[row]
            
        case weightTextField:
            return weights[row]
            
        default:
            return nil
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedTextField {
            
        case competitionTextField:
            competitionTextField.text = competitions?[row].name
            
        case stepTextField:
            stepTextField.text = stepsName[row]
            
        case fishNameTextField:
            fishNameTextField.text = fishes[row]
            
        case weightTextField:
            weightTextField.text = weights[row]
            if let weightForScore = Int(weights[row]) {
                scoreTextField.text = "\(weightForScore + 500)"
            }
            
        default:
            return 
        }
    }
}
