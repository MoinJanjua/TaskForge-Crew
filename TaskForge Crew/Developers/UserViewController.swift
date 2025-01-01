//
//  UserViewController.swift
//  POS
//
//  Created by Maaz on 09/10/2024.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var addSaleMenBtn: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!  // Add this outlet for the label

    
    var Developer_Detail: [Developer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)

    }
    override func viewWillAppear(_ animated: Bool) {
        // Load data from UserDefaults
        noDataLabel.text = "There is no user available, please add user first" // Set the message
        
        if let savedData = UserDefaults.standard.array(forKey: "DevDetails") as? [Data] {
            let decoder = JSONDecoder()
            Developer_Detail = savedData.compactMap { data in
                do {
                    let medication = try decoder.decode(Developer.self, from: data)
                    return medication
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text = "There is no Developer available, please add Developer first" // Set the message
        if Developer_Detail.isEmpty {
            TableView.isHidden = true
            noDataLabel.isHidden = false  // Show the label when there's no data
        } else {
            TableView.isHidden = false
            noDataLabel.isHidden = true   // Hide the label when data is available
        }
     TableView.reloadData()
    }
    private func clearUserData() {
        // Remove keys related to user data but not login information
        UserDefaults.standard.removeObject(forKey: "DevDetails")
 }

    private func showResetConfirmation() {
        let confirmationAlert = UIAlertController(title: "Reset Complete", message: "The data has been reset successfully.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        confirmationAlert.addAction(okAction)
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    @IBAction func AddUserDetailButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func ClearEmployeesButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Remove Employee Data", message: "Are you sure you want to remove all the employees data?", preferredStyle: .alert)
          
          let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
              // Step 1: Clear user-specific data from UserDefaults
              self.clearUserData()
              
              // Step 2: Clear the data source (order_Detail array)
              self.Developer_Detail.removeAll()
              
              // Step 3: Reload the table view to reflect the change
              self.TableView.reloadData()
              
              // Step 4: Optionally, show a confirmation to the user
              self.showResetConfirmation()
          }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          
          alert.addAction(confirmAction)
          alert.addAction(cancelAction)
          
          self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
extension UserViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Developer_Detail.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        let UserData = Developer_Detail[indexPath.row]
        cell.nameLbl?.text = "\(UserData.name)"
        cell.addressLbl?.text = UserData.Address
        cell.genderLbl?.text = UserData.gender
        cell.contactLbl?.text = UserData.contact
        cell.JoinDatelabel?.text = "Joining date: \(UserData.joiningdate)"
      
        if UserData.gender == "Male" {
            cell.ImageView.image = UIImage(named: "male")
        } else if UserData.gender == "Female" {
            cell.ImageView.image = UIImage(named: "female")
        } else {
            cell.ImageView.image = nil // Clear the image for unexpected cases
        }
        
//        cell.SaleButton.tag = indexPath.row // Set tag to identify the row
//        cell.SaleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
        
    }
//    @objc func buttonTapped(_ sender: UIButton) {
//        let rowIndex = sender.tag
//        print("Button tapped in row \(rowIndex)")
//        let userData = Developer_Detail[sender.tag]
//     //   let id = emp_Detail[sender.tag].id
//        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAllDataViewController") as! UserAllDataViewController
//        newViewController.tittleName = userData.name
//
//        newViewController.selectedCustomerDetail = userData
//       // newViewController.userId = id
//        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        newViewController.modalTransitionStyle = .crossDissolve
//        self.present(newViewController, animated: true, completion: nil)
//    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Developer_Detail.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try Developer_Detail.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "DevDetails")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userData = Developer_Detail[indexPath.row]
     //   let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAllDataViewController") as! UserAllDataViewController
        newViewController.tittleName = userData.name
        newViewController.selectedCustomerDetail = userData
       // newViewController.userId = id
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
            
        }
        
    }

