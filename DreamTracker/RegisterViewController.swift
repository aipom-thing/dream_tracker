//
//  RegisterViewController.swift
//  DreamTracker
//
//  Created by Nakama on 16/11/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapRegisterButton(_ sender: UIBarButtonItem) {
        Alamofire
            .request(URL(string: "http://93.188.167.250:8080/register")!,
                     method: .post,
                     parameters: [
                        "name": nameTextField.text,
                        "email": emailTextField.text,
                        "password": passwordTextField.text,
                ],
                     encoding: JSONEncoding.default)
            .responseJSON{ (response) in
                
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
