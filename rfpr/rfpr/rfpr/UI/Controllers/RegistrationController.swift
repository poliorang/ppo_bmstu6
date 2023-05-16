//
//  RegistrationController.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    let authorizationManager = AuthorizationManager.shared
    
    var gettedCompletion: (() -> Void)? // обновление таблицы в AuthorizationController
    
    let loginTextField = UITextField(frame: CGRect(x: 70, y: 300, width: 300, height: 40))
    let passwordTextField = UITextField(frame: CGRect(x: 70, y: 370, width: 300, height: 40))
    
    let loginWithAuthoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        setupServices()
        
        setupParametersTextFields(loginTextField, passwordTextField)
        setupLoginWithAuthoButton(loginWithAuthoButton)
    }
    
    func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }

    private func setupParametersTextFields(_ login: UITextField, _ password: UITextField) {
        [login, password].forEach {
            view.addSubview($0)
            $0.delegate = self
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
        }
        login.placeholder = "Логин"
        password.placeholder = "Пароль"
    }
    
    func setupLoginWithAuthoButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -310),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 160),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        button.addTarget(self, action: #selector(buttonLoginWithAuthoTapped(sender:)), for: .touchUpInside)
    }
    
    @objc
    func buttonLoginWithAuthoTapped(sender: UIButton) {
        let login = loginTextField.text?.removingFinalSpaces().removingLeadingSpaces()
        let password = passwordTextField.text?.removingFinalSpaces().removingLeadingSpaces()
        
        guard let login = login,
              let password = password else {
                  alertManager.showAlert(presentTo: self, title: "Внимание",
                                         message: "Логин и пароль не распознаны")
                  return
        }
        
        if login == "" || password == "" {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Введите логин и пароль для входа")
            return
        }
        
        let authorization: Authorization?
        let user: User?
    
        do {
            authorization = try services.authorizationService.createAuthorization(id: nil, login: login, password:  password)
            user = try services.userService.createUser(id: nil, role: Role.referee, authorization: authorization)
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Ошибка доступа к БД")
            return
        }
        
        guard let user = user else {
              alertManager.showAlert(presentTo: self, title: "Внимание",
                                     message: "Пользователь не создан")
              return
        }

        authorizationManager.setUser(user)
        dismiss(animated: true, completion: gettedCompletion)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
