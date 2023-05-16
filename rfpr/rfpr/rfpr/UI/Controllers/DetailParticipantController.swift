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
    let authorizationManager = AuthorizationManager.shared
    
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
    let teamTextFIeld = UITextField(frame: CGRect(x: 20, y: 400, width: 300, height: 40))
    
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
        setupParametersTextFields(teamTextFIeld, picker, pickerToolBar)
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
    
    private func setupNameTextFields(_ lastname: UITextField, _ firstname: UITextField, _ patronymic: UITextField, _ city: UITextField) {
        [lastname, firstname, patronymic, city].forEach {
            view.addSubview($0)
            
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.autocorrectionType = UITextAutocorrectionType.no
            $0.keyboardType = UIKeyboardType.default
            $0.returnKeyType = UIReturnKeyType.done
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
            
            $0.delegate = self
        }
        
        lastname.placeholder = "Фамилия участникв"
        firstname.placeholder = "Имя участника"
        patronymic.placeholder = "Отчество участника"
        city.placeholder = "Город"
    }
    
    private func setupParametersTextFields(_ team: UITextField, _ picker: UIPickerView, _ toolBar: UIToolbar) {
        [team].forEach {
            view.addSubview($0)
            $0.delegate = self
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
            $0.inputView = picker
            $0.inputAccessoryView = toolBar
        }
    
        team.placeholder = "Команда"
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
        if !authorizationManager.getRight() {
            alertManager.showAlert(presentTo: self, title: "Доступ запрещен",
                                   message: "Изменять профиль участника может только судья")
            return
        }
        
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
        
        lastname = lastname.removingLeadingSpaces().removingFinalSpaces()
        firstname = firstname.removingLeadingSpaces().removingFinalSpaces()
        let patronymic = partonymicTextField.text?.removingLeadingSpaces().removingFinalSpaces()
        let city = cityTextField.text?.removingLeadingSpaces().removingFinalSpaces()
        let teamName = teamTextFIeld.text?.removingLeadingSpaces().removingFinalSpaces()
        
        var team: Team? = nil
        
        if teamName != "" {
            do {
                team = try services.teamService.getTeam(name: teamName)?.first
                
                let participantsByTeam = try services.participantService.getParticipantByTeam(team: team)
                if participantsByTeam?.count == 3 {
                    alertManager.showAlert(presentTo: self, title: "Внимание", message: "В команде уже есть 3 участника")
                    return
                }
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание", message: "Команда не найдена")
            }
        }
        
        
        if let updateParticipant = updateParticipant {
            do {
                let participant = Participant(id: nil, lastName: lastname, firstName: firstname, patronymic: patronymic, team: team, city: city ?? "", birthday: birthday, score: 0)
                _ = try services.participantService.updateParticipant(previousParticipant: updateParticipant, newParticipant: participant)
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание", message: "Участник не был создан")
            }
            
        } else {
            do {
                _ = try services.participantService.createParticipant(id: nil, lastName: lastname, firstName: firstname, patronymic: patronymic, team: team, city: city, birthday: birthday, score: 0)
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание", message: "Участник не был создан")
            }
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
        
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTextField {
       
        case teamTextFIeld:
            return teams?[row].name
        
        default:
            return nil
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTextField == teamTextFIeld {  teamTextFIeld.text = teams?[row].name }
        
        switch selectedTextField {
        
        case teamTextFIeld:
            teamTextFIeld.text = teams?[row].name
        
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


