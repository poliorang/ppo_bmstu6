//
//  DetailParticipantController.swift
//  rfpr
//
//  Created by poliorang on 08.05.2023.
//

import UIKit

class DetailParticipantViewController: UIViewController, ToDetailParticipantDelegateProtocol,
                                        ToDetailParticipantUpdateDelegateProtocol {
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    var competition: Competition?       // получить из TeamController
    var updateParticipant: Participant? // получить из TeamController
    var teams: [Team]?
    let roles = ["Судья", "Участник"]
    var birthday: Date?
    
    var selectedTextField: UITextField? = nil
    
    let lastnameTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    let firstnameTextField = UITextField(frame: CGRect(x: 20, y: 160, width: 300, height: 40))
    let partonymicTextField = UITextField(frame: CGRect(x: 20, y: 220, width: 300, height: 40))
    let cityTextField = UITextField(frame: CGRect(x: 20, y: 280, width: 300, height: 40))
    
    let birthdayTextField = UITextField(frame: CGRect(x: 20, y: 340, width: 300, height: 40))
    let roleTextField = UITextField(frame: CGRect(x: 20, y: 400, width: 300, height: 40))
    let teamTextFIeld = UITextField(frame: CGRect(x: 20, y: 460, width: 300, height: 40))
    
    let picker = UIPickerView()
    let pickerToolBar = UIToolbar()
    
    let datePicker = UIDatePicker()
    let datePickerToolBar = UIToolbar()
    
    let createParticipantButton = UIButton()
    
    
    var gettedCompletion: (() -> Void)? // обновление таблицы в TeamController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        guard let _ = competition else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Соревнование не распознано")
            return
        }
        
        setupServices()
        getTeamsByCompetition()
        
        setupNameTextFields(lastnameTextField, firstnameTextField, partonymicTextField, cityTextField)
        setupParametersTextFields(roleTextField, teamTextFIeld, picker, pickerToolBar)
        setupBirthdayField(birthdayTextField, datePicker, datePickerToolBar)
        setupCreateParticipantButton(createParticipantButton)
        
        setupPicker(picker)
        setupPickerToolBar(pickerToolBar)
        
        setupDatePicker(datePicker)
        setupDatePickerToolBar(datePickerToolBar)
        
        
        setupUpdate()
        
        createParticipantButton.addTarget(self, action: #selector(buttonCreateParticipantTapped(sender:)), for: .touchUpInside)
    }
    
    // делегат
    func sendCompetitionToParticipantViewController(competition: Competition?) {
        guard let competition = competition else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Соревнование не распознано")
            return
        }

        self.competition = competition
    }
    
    // делегат
    func sendParticipantToParticipantViewController(participant: Participant?) {
        guard let participant = participant else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Участник не распознан")
            return
        }

        self.updateParticipant = participant
    }
    
    func setupUpdate() {
        
        if let updateParticipant = updateParticipant {
            lastnameTextField.text = updateParticipant.lastName
            firstnameTextField.text = updateParticipant.firstName
            partonymicTextField.text = updateParticipant.patronymic
            cityTextField.text = updateParticipant.city
            roleTextField.text = updateParticipant.role
            teamTextFIeld.text = updateParticipant.team?.name ?? ""
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            birthdayTextField.text = formatter.string(from: updateParticipant.birthday)
            birthday = updateParticipant.birthday
        }
    }
    
    func getTeamsByCompetition() {
        do {
            teams = try services.teamService.getTeamsByCompetition(competitionName: competition?.name)
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Ошибка базы данных")
        }
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
    
    private func setupNameTextFields(_ first: UITextField, _ second: UITextField, _ third: UITextField, _ fourth: UITextField) {
        [first, second, third, fourth].forEach {
            view.addSubview($0)
            
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.autocorrectionType = UITextAutocorrectionType.no
            $0.keyboardType = UIKeyboardType.default
            $0.returnKeyType = UIReturnKeyType.done
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
            
            $0.delegate = self
        }
        
        first.placeholder = "Фамилия участникв"
        second.placeholder = "Имя участника"
        third.placeholder = "Отчество участника"
        fourth.placeholder = "Город"
    }
    
    private func setupParametersTextFields(_ first: UITextField, _ second: UITextField, _ picker: UIPickerView, _ toolBar: UIToolbar) {
        [first, second].forEach {
            view.addSubview($0)
            $0.delegate = self
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
            $0.inputView = picker
            $0.inputAccessoryView = toolBar
        }
        
        first.placeholder = "Роль"
        second.placeholder = "Команда"
    }
    
    private func setupBirthdayField(_ textField: UITextField, _ picker: UIDatePicker, _ toolBar: UIToolbar) {
        view.addSubview(textField)
        
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.inputView = picker
        textField.inputAccessoryView = toolBar
        
        textField.placeholder = "Дата рождения"
    }
    
    private func setupCreateParticipantButton(_ button: UIButton) {
        view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus")!, for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 110),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPicker(_ picker: UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
        
    }
    
    private func setupDatePicker(_ picker: UIDatePicker) {
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
    }
    
    private func setupPickerToolBar(_ toolBar: UIToolbar) {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
    }
    
    private func setupDatePickerToolBar(_ toolBar: UIToolbar) {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneDatePicker))
        toolBar.setItems([doneButton], animated: false)
    }
    
    @objc
    func donePicker() {
        selectedTextField?.resignFirstResponder()
    }
    
    @objc
    func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        birthdayTextField.resignFirstResponder()
        birthday = datePicker.date
        
        self.view.endEditing(true)
    }
    
    @objc
    func buttonCreateParticipantTapped(sender: UIButton) {
        guard var lastname = lastnameTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите фамилию")
            return
        }
        
        guard var firstname = firstnameTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите имя")
            return
        }
        
        guard let birthday = birthday else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите дату рождения")
            return
        }
        
        guard let role = roleTextField.text else {
            alertManager.showAlert(presentTo: self, title: "Внимание", message: "Введите роль")
            return
        }
        
        lastname = lastname.removingLeadingSpaces().removingFinalSpaces()
        firstname = firstname.removingLeadingSpaces().removingFinalSpaces()
        let patronymic = partonymicTextField.text?.removingLeadingSpaces().removingFinalSpaces()
        let city = cityTextField.text?.removingLeadingSpaces().removingFinalSpaces()
        let teamName = teamTextFIeld.text?.removingLeadingSpaces().removingFinalSpaces()
        
        if let updateParticipant = updateParticipant {
            do {
                let team = try services.teamService.getTeam(name: teamName)?.first
                
                let participant = Participant(id: nil, lastName: lastname, firstName: firstname, patronymic: patronymic, team: team, city: city ?? "", birthday: birthday, role: role, score: 0)
                _ = try services.participantService.updateParticipant(previousParticipant: updateParticipant, newParticipant: participant)
                print("\(participant.lastName) WAS UPDATED")
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание", message: "Учатсник не был создан")
            }
            
        } else {
            var participant: Participant? = nil
            do {
                let team = try services.teamService.getTeam(name: teamName)?.first
                try participant = services.participantService.createParticipant(id: nil, lastName: lastname, firstName: firstname, patronymic: patronymic, team: nil, city: city, birthday: birthday, role: role, score: 0)
                try services.teamService.addParticipant(participant: participant, team: team)
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание", message: "Учатсник не был создан")
            }
            print("\(participant?.lastName ?? "") WAS CREATED")
        }
        
        dismiss(animated: true, completion: gettedCompletion)
    }
}

extension DetailParticipantViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedTextField {
        case teamTextFIeld:
            return teams?.count ?? 0
        case roleTextField:
            return roles.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTextField {
        case teamTextFIeld:
            return teams?[row].name
        case roleTextField:
            return roles[row]
        default:
            return nil
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTextField == teamTextFIeld {  teamTextFIeld.text = teams?[row].name }
        switch selectedTextField {
        case teamTextFIeld:
            teamTextFIeld.text = teams?[row].name
        case roleTextField:
            roleTextField.text = roles[row]
        default:
            return
        }
    }
}

extension DetailParticipantViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


