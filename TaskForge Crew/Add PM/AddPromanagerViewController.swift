//
//  AddPromanagerViewController.swift
//  TaskForge Crew
//
//  Created by Maaz on 24/12/2024.
//

import UIKit

class AddPromanagerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var MianView: UIView!

    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var AddressTF: UITextField!
    @IBOutlet weak var GenderTF: DropDown!
    @IBOutlet weak var ContactTF: UITextField!
    @IBOutlet weak var DateodbirthTF: UITextField!
    @IBOutlet weak var JoiningdateTF: UITextField!

    @IBOutlet weak var Save_btn: UIButton!
    
    private var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        
        // Set PercentageTF delegate to self for validation
//        PercentageTF.delegate = self
        
        
        GenderTF.optionArray = ["Male", "Female"]
        GenderTF.didSelect { (selectedText, index, id) in
            self.GenderTF.text = selectedText
        }
        GenderTF.delegate = self
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        setupDatePicker(for: DateodbirthTF, target: self, doneAction: #selector(donePressed))
        setupDatePicker(for: JoiningdateTF, target: self, doneAction: #selector(donePressed2))
       
    }
    @objc func donePressed() {
           // Get the date from the picker and set it to the text field
           if let datePicker = DateodbirthTF.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .medium
               dateFormatter.timeStyle = .none
               DateodbirthTF.text = dateFormatter.string(from: datePicker.date)
           }
           // Dismiss the keyboard
        DateodbirthTF.resignFirstResponder()
       }
    @objc func donePressed2() {
           // Get the date from the picker and set it to the text field
           if let datePicker = JoiningdateTF.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .medium
               dateFormatter.timeStyle = .none
               JoiningdateTF.text = dateFormatter.string(from: datePicker.date)
           }
           // Dismiss the keyboard
        JoiningdateTF.resignFirstResponder()
       }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func makeImageViewCircular(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func clearTextFields() {
        NameTF.text = ""
        AddressTF.text = ""
        GenderTF.text = ""
        ContactTF.text = ""
        DateodbirthTF.text = ""
        JoiningdateTF.text = ""
    }

    func saveData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard let eName = NameTF.text, !eName.isEmpty,
              let Address = AddressTF.text,
              let Gender = GenderTF.text, !Gender.isEmpty,
              let Contact = ContactTF.text, !Contact.isEmpty,
              let DateoFBirth = DateodbirthTF.text,
                let Joiningdate = JoiningdateTF.text, !Joiningdate.isEmpty


        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
      
            let randomCharacter = generateRandomCharacter()
            let newDetail = ProManager(
                id: "\(randomCharacter)",
                pname: eName,
                pAddress: Address,
                pgender: Gender,
                pcontact: Contact,
                pdateofbirth: DateoFBirth,
                pjoiningdate: Joiningdate
            )
            saveUserDetail(newDetail)
        }
    

    
    func saveUserDetail(_ employee: ProManager) {
        var employees = UserDefaults.standard.object(forKey: "PMDetails") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            employees.append(data)
            UserDefaults.standard.set(employees, forKey: "PMDetails")
            clearTextFields()
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "project Manager Detail has been Saved successfully.")
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
