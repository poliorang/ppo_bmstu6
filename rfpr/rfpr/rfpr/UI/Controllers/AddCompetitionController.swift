//
//  AddCompetitionController.swift
//  rfpr
//
//  Created by poliorang on 03.05.2023.
//

import UIKit


class AddCompetitionController: UIViewController{
    
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    let nameLabel = UILabel(frame: CGRect(x: 20, y: 70, width: 320, height: 40))
    let nameTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    let addCompetitionButton = UIButton()
    
    var gettedCompletion: (() -> Void)? // обновление таблицы в competitionController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupServices()
        
        setupNameLabel(nameLabel)
        setupNameTextField(nameTextField)
        setupAddCompetitionButton(addCompetitionButton)
        
        addCompetitionButton.addTarget(self, action: #selector(buttonAddCompetitionTapped(sender:)), for: .touchUpInside)
    }

    func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }
    
    func setupNameLabel(_ label: UILabel) {
        self.view.addSubview(label)
        label.textAlignment = .left
        label.text = "Название соревнования"
    }
    
    func setupNameTextField(_ textField: UITextField) {
        view.addSubview(nameTextField)
        
        textField.placeholder = "Ведите название соревнования"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.enablesReturnKeyAutomatically = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        textField.delegate = self
    }
    
    func setupAddCompetitionButton(_ button: UIButton) {
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
    
    @objc
    func buttonAddCompetitionTapped(sender: UIButton) {
        guard var competitionName = nameTextField.text else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Введите название соревнования")
            return
        }
        
        competitionName = competitionName.removingLeadingSpaces().removingFinalSpaces()
        
        if competitionName == "" || competitionName == " " {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Введите название соревнования")
            return
        }
        
        do {
            _ = try services.competitionService.createCompetition(id: nil, name: competitionName, teams: nil)
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Соревнование не было создано")
            
        }
        
        dismiss(animated: true, completion: gettedCompletion)
    }
}

extension AddCompetitionController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

