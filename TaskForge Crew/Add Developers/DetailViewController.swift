//
//  DetailViewController.swift
//  AssetAssign
//
//  Created by Moin Janjua on 19/08/2024.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var AddressTF: UITextField!
    @IBOutlet weak var GenderTF: DropDown!
    @IBOutlet weak var ContactTF: UITextField!
    @IBOutlet weak var DateodbirthTF: UITextField!
    @IBOutlet weak var JoiningdateTF: UITextField!

    @IBOutlet weak var Save_btn: UIButton!
    
    private var datePicker: UIDatePicker?
    var pickedImage = UIImage()
    
    @IBOutlet weak var MianView: UIView!
    
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
    
//    // UITextFieldDelegate method to validate percentage input
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == PercentageTF {
//            // Get the new text by replacing the current text in the range with the replacement string
//            let currentText = textField.text ?? ""
//            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//            
//            // Check if the input is a valid number and within the allowed range
//            if let percentageValue = Int(newText), percentageValue > 100 {
//                showAlert(title: "Error", message: "Please add percentage below 100%")
//                return false
//            }
//        }
//        return true
//    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidContact(_ contact: String) -> Bool {
        let contactRegEx = "^\\d{11}$"
        let contactPred = NSPredicate(format: "SELF MATCHES %@", contactRegEx)
        return contactPred.evaluate(with: contact)
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
            let newDetail = Developer(
                id: "\(randomCharacter)",
                name: eName,
                Address: Address,
                gender: Gender,
                contact: Contact,
                dateofbirth: DateoFBirth,
                joiningdate: Joiningdate
            )
            saveUserDetail(newDetail)
        }
    

    
    func saveUserDetail(_ employee: Developer) {
        var employees = UserDefaults.standard.object(forKey: "DevDetails") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            employees.append(data)
            UserDefaults.standard.set(employees, forKey: "DevDetails")
            clearTextFields()
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Developer Detail has been Saved successfully.")
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
