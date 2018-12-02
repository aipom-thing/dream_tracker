//
//  LoginViewController.swift
//  DreamTracker
//
//  Created by Nakama on 21/11/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Alamofire
import UIKit

var AccessToken: String = ""

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
                    // Struct for response
                    struct TokenData: Codable{
                        let token: String?
                    }
                    
                    struct LoginData: Codable{
                        let success: Bool?
                        let error: String?
                        let data: TokenData?
                    }
                    
                    // Check user valid or no
                    if let data = response.data, let respData = NSString(data: data, encoding: String.Encoding.ascii.rawValue){
//                        print(respData)
                        let jsonDecoder = JSONDecoder()
                        if let responseData = try? jsonDecoder.decode(LoginData.self, from: data){
//                            print(responseData.data?.token)
//                            print(responseData.error)
//                            print(responseData.success)
//                            print(responseData.data?.token == nil)
//                            print(responseData.success == false)

//                            let listDream = ListDreamTableViewController()
//                            listDream.accessToken = responseData.data?.token ?? ""
//
//                            print(listDream.accessToken)

                            AccessToken = responseData.data?.token ?? ""
                            
                            if responseData.data?.token == nil || responseData.success == false{
                                let alert = UIAlertController(title: nil, message: "Login Failed", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Invalid Username/Password", style: .default, handler: { _ in
                                }))
                                self.present(alert, animated: true,completion: nil)
                                
                                break;
                            }
                        }
                    }

                    // Login success, set isLogin
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(true, forKey: "isLogin")
                    
                    let alert = UIAlertController(title: nil, message: "Login Success", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Here we go!", style: .default, handler: { _ in
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
//        if segue.identifier == "listDreamIdentifier"{
//            if let navController = segue.destination as? UINavigationController{
//                if let childVC = navController.topViewController as? ListDreamTableViewController{
//                    childVC.accessToken = "HEHE"
//                }
//            }
//        }
//        let navVC = segue.destination as? UINavigationController
//        let tableVC = navVC?.viewControllers.first as! ListDreamTableViewController
//        tableVC.accessToken = "HEHE"
//    }
    
}

