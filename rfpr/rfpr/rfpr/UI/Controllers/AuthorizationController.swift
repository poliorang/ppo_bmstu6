//
//  AuthorizationController.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import UIKit

class AuthorizationViewController: UIViewController {
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    let authorizationManager = AuthorizationManager.shared
    
    let loginTextField = UITextField(frame: CGRect(x: 70, y: 300, width: 300, height: 40))
    let passwordTextField = UITextField(frame: CGRect(x: 70, y: 370, width: 300, height: 40))
    
    let loginWithAuthoButton = UIButton()
    let registrationButton = UIButton()
    let loginWithoutAuthoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        setupServices()
        
        setupParametersTextFields(loginTextField, passwordTextField)
        
        setupLoginWithAuthoButton(loginWithAuthoButton)
        setupRegistrationButton(registrationButton)
        setupLoginWithoutAuthoButton(loginWithoutAuthoButton)
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
        button.setTitle("Войти", for: .normal)
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
    
    func setupRegistrationButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 205),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        button.addTarget(self, action: #selector(buttonRegistrationTapped(sender:)), for: .touchUpInside)
    }
    
    func setupLoginWithoutAuthoButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти без регистрации", for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 205),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        button.addTarget(self, action: #selector(buttonLoginWithoutAuthoTapped(sender:)), for: .touchUpInside)
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
        
        let authorization = Authorization(id: nil, login: login, password: password)
        let user: User?
        do {
            user = try services.userService.getUserByAuthorization(authorization: authorization)
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Ошибка доступа к БД")
            return
        }
        
        guard let user = user else {
              alertManager.showAlert(presentTo: self, title: "Внимание",
                                     message: "Пользователь не найден")
              return
        }
        
        authorizationManager.setUser(user)
        dismiss(animated: true)
    }
    
    @objc
    func buttonLoginWithoutAuthoTapped(sender: UIButton) {
        let user: User?
        do {
            user = try services.userService.createUser(id: nil, role: .participant, authorization: nil)
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Ошибка доступа к БД")
            return
        }
        
        guard let user = user else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Не удалось создать пользователя")
            return
        }
        
        authorizationManager.setUser(user)
        dismiss(animated: true)
    }
    
    @objc
    func buttonRegistrationTapped(sender: UIButton) {
    
        let dismissCompletion: () -> Void = {
            self.dismiss(animated: true)
        }
        let registrationViewController = RegistrationViewController()
        registrationViewController.gettedCompletion = dismissCompletion
        
        present(registrationViewController, animated: true, completion: nil)
       
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {        
        return true
    }
}
