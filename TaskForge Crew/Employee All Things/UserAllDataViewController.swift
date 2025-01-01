//
//  UserAllDataViewController.swift
//  AssetAssign
//
//  Created by Moin Janjua on 20/08/2024.
//

import UIKit

class UserAllDataViewController: UIViewController {

    @IBOutlet weak var TittleName: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var YourBounce: UILabel!
    @IBOutlet weak var TotalSalesAmount: UILabel!
    @IBOutlet weak var commessionView: UIView!
    
    var tittleName = String()
    
    var Users_Detail: [Developer] = []
    var selectedCustomerDetail: Developer?
    
    var selectedOrderDetail: Project?
    var order_Detail: [Project] = []
    
    var currency: String = "$"
    
    var percentageSet = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        TittleName.text = tittleName

        TableView.delegate = self
        TableView.dataSource = self
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"

        if let savedData = UserDefaults.standard.array(forKey: "ProjectDetails") as? [Data] {
            let decoder = JSONDecoder()
            order_Detail = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(Project.self, from: data)
                    return order
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }

            if let selectedCustomer = selectedCustomerDetail {
                let filteredOrders = order_Detail.filter { $0.developerName == selectedCustomer.name }
                order_Detail = filteredOrders // Update the order_Detail array with filtered results

            TableView.reloadData()

            }
            TableView.reloadData()
        }

        TableView.reloadData()
    }


    func makeImageViewCircular(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }

    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension UserAllDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order_Detail.count
    }
    
    // Configure the cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as! TableViewCell
     
        let order = order_Detail[indexPath.row]
        
        // Set the product information to the cell labels
        cell.TitleLabel.text = "Project.T: \(order.title)"
        cell.nameLabel.text = "Project Manager: \(order.projectmanager)"
        cell.productLabel.text = "Dev Name: \(order.developerName)"
        cell.dateLabe.text = "S.D: \(order.startdate) - E.D: \(order.enddate)"
        // Calculate remaining days
             let remainingDays = calculateRemainingDays(startdate: order.startdate, enddate: order.enddate)
             
             if remainingDays > 0 {
                 cell.remainingTimeLabel.text = "\(remainingDays) days remaining"
             } else if remainingDays == 0 {
                 cell.remainingTimeLabel.text = "Due today!"
             } else {
                 cell.remainingTimeLabel.text = "Past due by \(abs(remainingDays)) days"
             }
        
        return cell
    }
    
    func calculateRemainingDays(startdate: String, enddate: String) -> Int {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy" // Adjust this format as per your date string format
           
           guard let startDate = dateFormatter.date(from: startdate),
                 let endDate = dateFormatter.date(from: enddate) else {
               print("Error parsing dates")
               return 0
           }
           
           let currentDate = Date()
           
           // If the current date is before the start date, calculate days from start date
           if currentDate < startDate {
               let difference = Calendar.current.dateComponents([.day], from: currentDate, to: startDate)
               return difference.day ?? 0
           } else {
               // Otherwise, calculate days remaining until the end date
               let difference = Calendar.current.dateComponents([.day], from: currentDate, to: endDate)
               return difference.day ?? 0
           }
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

