//
//  LoginViewController.swift
//  DreamTracker
//
//  Created by Nakama on 21/11/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Alamofire
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        Alamofire
            .request(URL(string: "http://93.188.167.250:8080/login")!,
                     method: .post,
                     parameters: [
                        "email": emailTextField.text,
                        "password": passwordTextField.text,
                        ],
                     encoding: JSONEncoding.default)
            .responseJSON{ (response) in
                switch response.result {
                case .success(let value):
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(true, forKey: "isLogin")
                    let alert = UIAlertController(title: nil, message: "Success", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    }))
                    self.present(alert, animated: true,completion: {
                        let window = UIApplication.shared.keyWindow
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let secondVC = storyBoard.instantiateViewController(withIdentifier: "listIdentifier")
                        window?.rootViewController = secondVC
                    })
                    
                    
                    break;
                case .failure(let error):
                    var messageError = "FAILURE"
                    if (error._code == NSURLErrorNotConnectedToInternet) {
                        messageError = "Tidak ada koneksi internet"
                    } else if (error._code == NSURLErrorUnsupportedURL) {
                        messageError = "URL Salah"
                    }
                    let alert = UIAlertController(title: nil, message: messageError, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    }))
                    self.present(alert, animated: true,completion: nil)
                    break;
                default:
                    return
                }
                
        }
    }
    
}

