//
//  InfoViewController.swift
//  TaskForge Crew
//
//  Created by Maaz on 24/12/2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var Notestext: UITextView!
    @IBOutlet weak var PMnameLabel: UILabel!
    @IBOutlet weak var DevnameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var selectedInfoDetail: Project?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let showData = selectedInfoDetail{
            titleLabel.text = "Project Title: \(showData.title)"
            DevnameLabel.text = "Developer: \(showData.developerName)"
            PMnameLabel.text = "Project Manager: \(showData.projectmanager)"
            Notestext.text = "Project Description: \(showData.Description)"
        }
        applyCornerRadiusToBottomCorners(view: mView, cornerRadius: 35)

    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
