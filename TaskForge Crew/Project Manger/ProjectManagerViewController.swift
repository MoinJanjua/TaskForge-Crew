//
//  ProjectManagerViewController.swift
//  TaskForge Crew
//
//  Created by Maaz on 24/12/2024.
//

import UIKit

class ProjectManagerViewController: UIViewController {
    
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!  // Add this outlet for the label
    
    var ProManager_Detail: [ProManager] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Load data from UserDefaults
        
        if let savedData = UserDefaults.standard.array(forKey: "PMDetails") as? [Data] {
            let decoder = JSONDecoder()
            ProManager_Detail = savedData.compactMap { data in
                do {
                    let medication = try decoder.decode(ProManager.self, from: data)
                    return medication
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text = "There is no project manger available, please add first" // Set the message
        if ProManager_Detail.isEmpty {
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
        UserDefaults.standard.removeObject(forKey: "PMDetails")
 }
    
    private func showResetConfirmation() {
        let confirmationAlert = UIAlertController(title: "Reset Complete", message: "The data has been reset successfully.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        confirmationAlert.addAction(okAction)
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    @IBAction func AddprojectMangerButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddPromanagerViewController") as! AddPromanagerViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func ClearProjectMangerButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Remove Project manger Data", message: "Are you sure you want to remove all the project manger data?", preferredStyle: .alert)
          
          let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
              // Step 1: Clear user-specific data from UserDefaults
              self.clearUserData()
              
              // Step 2: Clear the data source (order_Detail array)
              self.ProManager_Detail.removeAll()
              
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
extension ProjectManagerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProManager_Detail.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PMCell", for: indexPath) as! PMTableViewCell
        
        let UserData = ProManager_Detail[indexPath.row]
        cell.nameLbl?.text = "\(UserData.pname)"
        cell.addressLbl?.text = UserData.pAddress
//        cell.genderLbl?.text = UserData.gender
        cell.contactLbl?.text = UserData.pcontact
        cell.JoinDatelabel?.text = "Joining date: \(UserData.pjoiningdate)"
      
        if UserData.pgender == "Male" {
            cell.ImageView.image = UIImage(named: "male")
        } else if UserData.pgender == "Female" {
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
            ProManager_Detail.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try ProManager_Detail.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "PMDetails")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let userData = ProManager_Detail[indexPath.row]
//     //   let id = emp_Detail[sender.tag].id
//        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAllDataViewController") as! UserAllDataViewController
////        newViewController.tittleName = userData.name
////        newViewController.selectedCustomerDetail = userData
//       // newViewController.userId = id
//        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        newViewController.modalTransitionStyle = .crossDissolve
//        self.present(newViewController, animated: true, completion: nil)
            
        }
        
    }
