//
//  ViewSalesViewController.swift
//  ShareWise Ease
//
//  Created by Maaz on 17/10/2024.
//
import UIKit
import PDFKit

class ViewSalesViewController: UIViewController {

    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var FromDatePicker: UIDatePicker!
    @IBOutlet weak var ToDatePicker: UIDatePicker!
    
    var order_Detail: [Project] = []  // Original order data
    var filteredOrderDetails: [Project] = []  // Filtered data to display in the table view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        
        // Add targets for the date pickers
        FromDatePicker.addTarget(self, action: #selector(fromDatePickerChanged(_:)), for: .valueChanged)
        ToDatePicker.addTarget(self, action: #selector(toDatePickerChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load data from UserDefaults
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
        }
        // Initially, show all data
        filteredOrderDetails = order_Detail
        TableView.reloadData()
    }
    
    @objc func fromDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }

    @objc func toDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }

    func filterTransactions() {
        let fromDate = FromDatePicker.date
        let toDate = ToDatePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Adjust this format to match the format of your `startdate`
        
        filteredOrderDetails = order_Detail.filter { order in
            // Convert the `startdate` string to a `Date` object
            if let orderDate = dateFormatter.date(from: order.startdate) {
                // Perform the date comparison
                return orderDate >= fromDate && orderDate <= toDate
            } else {
                // Skip the order if the date format is invalid
                print("Invalid date format for startdate: \(order.startdate)")
                return false
            }
        }
        
        // Reload the table view with the filtered data
        TableView.reloadData()
    }

    
    @IBAction func PdfGenerateButton(_ sender: Any) {
        generatePDF()
    }
    
    func generatePDF() {
        // Create a PDF document
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        let pdfData = pdfRenderer.pdfData { (context) in
            context.beginPage()

            var yOffset: CGFloat = 20.0
            let dataToExport = filteredOrderDetails.isEmpty ? order_Detail : filteredOrderDetails  // Use filtered data if available

            for order in dataToExport {
                let productName = "title: \(order.title)"
                let saleType = "Developer Name: \(order.developerName)"
                let userName = "Project Manger: \(order.projectmanager)"
                
              
                let orderDate = "Date: \(order.startdate)-\(order.enddate)"
                
                // Draw the text into the PDF
                let productRect = CGRect(x: 20, y: yOffset, width: 300, height: 20)
                productName.draw(in: productRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let saleTypeRect = CGRect(x: 20, y: yOffset + 20, width: 300, height: 20)
                saleType.draw(in: saleTypeRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let userRect = CGRect(x: 20, y: yOffset + 40, width: 300, height: 20)
                userName.draw(in: userRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let dateRect = CGRect(x: 20, y: yOffset + 60, width: 300, height: 20)
                orderDate.draw(in: dateRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                // Update yOffset for the next entry
                yOffset += 100.0
                
                // Start a new page if necessary
                if yOffset > 740 {
                    context.beginPage()
                    yOffset = 20.0
                }
            }
        }
        
        // Save the PDF file
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("SalesReport.pdf")
        
        do {
            try pdfData.write(to: outputFileURL)
            print("PDF successfully created at \(outputFileURL)")
            
            // Present the PDF for sharing
            sharePDF(outputFileURL)
            
        } catch {
            print("Could not save PDF: \(error.localizedDescription)")
        }
    }

    func sharePDF(_ fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // For iPad compatibility (avoids crashes)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension ViewSalesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrderDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewSalesCell", for: indexPath) as! ViewSalesTableViewCell
        
        let orderData = filteredOrderDetails[indexPath.row]
        cell.productNameLbl?.text = "Project.Manager: \(orderData.projectmanager)"
        cell.saleType?.text = "Project.T: \(orderData.title)"
        cell.DevnameLabel?.text = "Dev Name: \(orderData.developerName)"
   
        cell.dateLbl.text = "S.D: \(orderData.startdate) - E.D: \(orderData.enddate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
