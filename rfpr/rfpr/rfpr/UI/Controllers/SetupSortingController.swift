//
//  SetupSortingController.swift
//  rfpr
//
//  Created by poliorang on 14.05.2023.
//

import UIKit

protocol ToLootFromSetupDelegateProtocol {
    func sendSortParamsToLootViewController(stepName: StepsName?, sortParameter: SortParameter)
}

class SetupSortingViewController: UIViewController {
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    var lootViewController: LootViewController? = nil
    var teamViewController: TeamViewController? = nil
    var gettedCompletion: (() -> Void)? // обновление таблицы в LootController
    var toLootFromSetupDelegate: ToLootFromSetupDelegateProtocol? = LootViewController()
    
    let sortingTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    let stepTextField = UITextField(frame: CGRect(x: 20, y: 160, width: 300, height: 40))
    var selectedTextField: UITextField? = nil
    
    let picker = UIPickerView()
    let pickerToolBar = UIToolbar()
    let addSettingsButton = UIButton()
    
    var competitions: [Competition]?
    
    let stepsName = [StepsName.day1.rawValue, StepsName.day2.rawValue, StepsName.nil.rawValue]
    let sortParametersName = [SortParameter.decreasing.rawValue, SortParameter.ascending.rawValue]
    
    var stepName: StepsName? = StepsName.nil
    var sortParameterName = SortParameter.decreasing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        setupServices()
        setupParametersTextFields(sortingTextField, stepTextField, picker, pickerToolBar)
        setupPicker(picker)
        setupPickerToolBar(pickerToolBar)
        setupAddSettingsButton(addSettingsButton)
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
    
    private func setupParametersTextFields(_ sorting: UITextField, _ step: UITextField,
                                           _ picker: UIPickerView, _ toolBar: UIToolbar) {
        [sorting, step].forEach {
            view.addSubview($0)
            $0.delegate = self
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.borderStyle = UITextField.BorderStyle.roundedRect
            $0.clearButtonMode = UITextField.ViewMode.whileEditing
            
            $0.inputView = picker
            $0.inputAccessoryView = toolBar
        }
        
        sorting.placeholder = "Сортировать по"
        sorting.text = sortParameterName.rawValue
        
        step.placeholder = "Этап"
        step.text = stepName?.rawValue
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
    
    func setupAddSettingsButton(_ button: UIButton) {
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
        
        button.addTarget(self, action: #selector(buttonCreateLootTapped(sender:)), for: .touchUpInside)
    }
    
    
    @objc
    func donePicker() {
        selectedTextField?.resignFirstResponder()
    }
    
    @objc
    func buttonCreateLootTapped(sender: UIButton) {
        switch stepTextField.text {
        
        case StepsName.day1.rawValue:
            stepName = StepsName.day1
        
        case StepsName.day2.rawValue:
            stepName = StepsName.day2
        
        default:
            stepName = nil
        }
        
        switch sortingTextField.text {
        
        case  SortParameter.ascending.rawValue:
            sortParameterName = SortParameter.ascending
        
        default:
            sortParameterName = SortParameter.decreasing
        }
    
        if let lootViewController = lootViewController {
            lootViewController.sortParameter = sortParameterName
            lootViewController.stepName = stepName
        }

        if let teamViewController = teamViewController {
            teamViewController.sortParameter = sortParameterName
            teamViewController.stepName = stepName
        }
       
        dismiss(animated: true, completion: gettedCompletion)
    }
}

extension SetupSortingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {        
        return true
    }
}

extension SetupSortingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedTextField {
            
        case sortingTextField:
            return sortParametersName.count
            
        case stepTextField:
            return stepsName.count
            
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTextField {
            
        case sortingTextField:
            return sortParametersName[row]
            
        case stepTextField:
            return stepsName[row]
            
        default:
            return nil
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedTextField {
            
        case sortingTextField:
            sortingTextField.text = sortParametersName[row]
            
        case stepTextField:
            stepTextField.text = stepsName[row]
            
        default:
            return
        }
    }
}
