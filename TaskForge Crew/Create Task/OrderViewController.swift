//
//  OrderViewController.swift
//  POS
//
//  Created by Maaz on 09/10/2024.
//

import UIKit

class OrderViewController: UIViewController, UITextFieldDelegate {
    

    
    @IBOutlet weak var MianView: UIView!
    
    @IBOutlet weak var TitleTF: UITextField!
    @IBOutlet weak var DeveloperTF: DropDown!
    @IBOutlet weak var ProjectManagerTF: DropDown!
    @IBOutlet weak var StartdateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var NotesTF: UITextView!
    
    var pickedImage = UIImage()
    
    var Developer_Detail: [Developer] = []
    var ProManager_Detail: [ProManager] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        
        setupDatePicker(for: StartdateTF, target: self, doneAction: #selector(donePressed))
        setupDatePicker(for: endDateTF, target: self, doneAction: #selector(donePressed2))

        
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data from UserDefaults for Users_Detail
        if let savedData = UserDefaults.standard.array(forKey: "DevDetails") as? [Data] {
            let decoder = JSONDecoder()
            Developer_Detail = savedData.compactMap { data in
                do {
                    let user = try decoder.decode(Developer.self, from: data)
                    return user
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        // Set up the dropdown options for UserTF
        setUpUserDropdown()
        // Load data from UserDefaults for Users_Detail
        if let savedData = UserDefaults.standard.array(forKey: "PMDetails") as? [Data] {
            let decoder = JSONDecoder()
            ProManager_Detail = savedData.compactMap { data in
                do {
                    let user = try decoder.decode(ProManager.self, from: data)
                    return user
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        setUpProjectManagerDropdown()
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @objc func donePressed() {
        // Get the date from the picker and set it to the text field
        if let datePicker = StartdateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Same format as in convertStringToDate
            StartdateTF.text = dateFormatter.string(from: datePicker.date)
        }
        // Dismiss the keyboard
        StartdateTF.resignFirstResponder()
    }
    @objc func donePressed2() {
        // Get the date from the picker and set it to the text field
        if let datePicker = endDateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Same format as in convertStringToDate
            endDateTF.text = dateFormatter.string(from: datePicker.date)
        }
        // Dismiss the keyboard
        endDateTF.resignFirstResponder()
    }

    func makeImageViewCircular(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }

  
    
    // Set up User dropdown options from Users_Detail array
    func setUpUserDropdown() {
        // Check if Users_Detail array is empty
        if Developer_Detail.isEmpty {
            // If no users are available, set the text field to "No user available"
            DeveloperTF.text = "No developer available please first add the developer"
            DeveloperTF.isUserInteractionEnabled = false // Disable interaction if no users are available
        } else {
            // Extract names from the Users_Detail array
            let userNames = Developer_Detail.map { $0.name }
            
            // Assign names to the dropdown
            DeveloperTF.optionArray = userNames
            
            // Enable interaction if users are available
            DeveloperTF.isUserInteractionEnabled = true
            
            // Handle selection from dropdown
            DeveloperTF.didSelect { (selectedText, index, id) in
                self.DeveloperTF.text = selectedText
                print("Selected Developer: \(self.Developer_Detail[index])") // Optional: Handle selected user
            }
        }
    }
    // Set up User dropdown options from Users_Detail array
    func setUpProjectManagerDropdown() {
        // Check if Users_Detail array is empty
        if ProManager_Detail.isEmpty {
            // If no users are available, set the text field to "No user available"
            ProjectManagerTF.text = "No Projec tManager available please first add the Project Manager"
            ProjectManagerTF.isUserInteractionEnabled = false // Disable interaction if no users are available
        } else {
            // Extract names from the Users_Detail array
            let userNames = ProManager_Detail.map { $0.pname }
            
            // Assign names to the dropdown
            ProjectManagerTF.optionArray = userNames
            
            // Enable interaction if users are available
            ProjectManagerTF.isUserInteractionEnabled = true
            
            // Handle selection from dropdown
            ProjectManagerTF.didSelect { (selectedText, index, id) in
                self.ProjectManagerTF.text = selectedText
                print("Selected Project Manager: \(self.ProManager_Detail[index])") // Optional: Handle selected user
            }
        }
    }
    func clearTextFields() {
        TitleTF.text = ""
        DeveloperTF.text = ""
        ProjectManagerTF.text = ""
        StartdateTF.text = ""
        endDateTF.text = ""
        NotesTF.text = ""
    }

    func saveOrderData(_ sender: Any) {
        // Check if all mandatory fields are filled
        guard let Title = TitleTF.text, !Title.isEmpty,
              
              let DeveloperName = DeveloperTF.text, !DeveloperName.isEmpty,
              let ProjectManager = ProjectManagerTF.text, !ProjectManager.isEmpty,
              let Startdate = StartdateTF.text, !Startdate.isEmpty,
              let endDate = endDateTF.text, !endDate.isEmpty,
              let Notes = NotesTF.text
                
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Generate random character for order number
        let randomCharacter = generateOrderNumber()

        // Create new order detail safely
        let newCreateSale = Project(
            orderNo: "\(randomCharacter)",
            title: Title,
            
            developerName: DeveloperName,
            projectmanager: ProjectManager,
            startdate: Startdate,
            enddate: endDate, Description: Notes
          
        )
        
        // Save the order detail
        saveCreateSaleDetail(newCreateSale)
    }


    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Corrected year format
        return dateFormatter.date(from: dateString)
    }
    
    func saveCreateSaleDetail(_ order: Project) {
        var orders = UserDefaults.standard.object(forKey: "ProjectDetails") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(order)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "ProjectDetails")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Project Data has been Saved successfully.")
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveOrderData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
