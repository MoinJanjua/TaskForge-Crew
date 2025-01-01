//
//  WelcomeViewController.swift
//  FotoBlend Pix
//
//  Created by Maaz on 19/11/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var StartBtn: UIButton!
    @IBOutlet weak var ViewIcon: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        roundCorneView(view:ViewIcon)
//        addDropShadowButtonOne(to : StartBtn)
//        addDropShadow(to : ViewIcon)
        
        // Add gradient to StartBtn
//               applyGradientToButton(button: StartBtn)
        
    }
    @IBAction func LetstartButtonTapped(_ sender: Any) {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    newViewController.modalTransitionStyle = .crossDissolve
                    self.present(newViewController, animated: true, completion: nil)
    }

    func applyGradientToButton(button: UIButton) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                UIColor(hex: "#6934ff").cgColor, // Purple
                UIColor(hex: "#8735fc").cgColor, // Bright Purple
                UIColor(hex: "#a535ff").cgColor  // Violet
            ]
            
            // Set the gradient direction
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
            
            // Set the gradient's frame to match the button's bounds
            gradientLayer.frame = button.bounds
            
            // Apply rounded corners to the gradient
            gradientLayer.cornerRadius = button.layer.cornerRadius
            
            // Add the gradient to the button
            button.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    


