//
//  LoginViewController.swift
//  Twitter
//
//  Created by linda shu on 2/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func logIn(_ sender: Any) {
        let url="https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: url, success: {
            
            UserDefaults.standard.set(true, forKey: "login")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("login failed")
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "login")==true{
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
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
