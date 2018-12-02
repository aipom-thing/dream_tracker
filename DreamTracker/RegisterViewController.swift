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
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        
        if name.isEmpty || email.isEmpty || pass.isEmpty {
            let alert = UIAlertController(title: nil, message: "Invalid Input", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Please fill all fields!", style: .default, handler: { _ in
            }))
            self.present(alert, animated: true,completion: nil)
        }else{
            
            // Struct for response
            struct UserData: Codable{
                let id: Int?
                let name: String?
                let email: String?
                let Password: String?
            }
            
            struct RegisterData: Codable{
                let success: Bool?
                let error: String?
                let data: UserData?
            }
            
            Alamofire
                .request(URL(string: "http://93.188.167.250:8080/register")!,
                         method: .post,
                         parameters: [
                            "name":name,
                            "email":email,
                            "password":pass,
                    ],
                         encoding: JSONEncoding.default)
                .responseJSON{ (response) in
                    print(response)
                    let titleMsg: String?
                    let bodyMsg: String?
                    if let data = response.data, let respData = NSString(data: data, encoding: String.Encoding.ascii.rawValue){
                        let jsonDecoder = JSONDecoder()
                        if let responseData = try? jsonDecoder.decode(RegisterData.self, from: data){
                            if responseData.success == false{
                                titleMsg = "Register Failed"
                                bodyMsg = "Please check your input again!"
                            }else{
                                titleMsg = "Register Success"
                                bodyMsg = "Account created!"
                            }
                            
                            let alert = UIAlertController(title: nil, message: titleMsg, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: bodyMsg, style: .default, handler: { _ in
                            }))
                            self.present(alert, animated: true,completion: nil)
                        }
                    }
                    self.nameTextField.text = ""
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
            }
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
