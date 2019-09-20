//
//  buttonPageViewController.swift
//  NanoChallenge2
//
//  Created by Michael Louis on 18/09/19.
//  Copyright © 2019 Michael Louis. All rights reserved.
//

import UIKit

class buttonPageViewController: UIViewController {

    @IBAction func button1DidTapped(_ sender: Any) {
        if let appURL = URL(string: "airtable://")
        {
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpen)")
            
            let appName = "Airtable"
            let appScheme = "\(appName)://"
            let appSchemeURL = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL)
                {
                    UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
                }
            else
                {
                    let alert = UIAlertController(title: "\(appName) Error", message: "the app named \(appName) was not found, please install via AppStore.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert,animated: true,completion: nil)
                    
                }
            
            
        }
    }
    @IBAction func button2DidTapped(_ sender: Any) {
        if let appURL = URL(string: "ryver://")
        {
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpen)")
            
            let appName = "Ryver"
            let appScheme = "\(appName)://"
            let appSchemeURL = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL)
            {
                UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
            }
            else
            {
                let alert = UIAlertController(title: "\(appName) Error", message: "the app named \(appName) was not found, please install via AppStore.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)
                
            }
            
            
        }
    }
    @IBAction func button3DidTapped(_ sender: Any) {
       UIApplication.shared.openURL(NSURL(string: "https://industry.socs.binus.ac.id/learning-plan/auth/login")! as URL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
