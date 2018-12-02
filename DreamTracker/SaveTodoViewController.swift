//
//  SaveTodoViewController.swift
//  DreamTracker
//
//  Created by Thing on 02/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Alamofire
import UIKit

class SaveTodoViewController: UIViewController {

    var dreamIDTodo: Int?
    @IBOutlet weak var todoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSaveTodo(_ sender: UIBarButtonItem) {
        let todo = todoTextField.text ?? ""
        if todo.isEmpty {
            let alert = UIAlertController(title: nil, message: "Invalid Input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Please input the field!", style: .default, handler: { _ in
            }))
            self.present(alert, animated: true,completion: nil)
        }else{
            
            struct saveTodoResp: Codable {
                let success: Bool?
                let error: String?
                let data: String = ""
            }
            
            let headers = [
                "Authorization" : "Bearer " + AccessToken,
                "Content-Type": "application/json"
            ]
            
            Alamofire
                .request(URL(string: "http://93.188.167.250:8080/dreams/" + String(dreamIDTodo ?? 0) + "/todo")!,
                         method: .post,
                         parameters: [
                            "title": title,
                            ],
                         encoding: JSONEncoding.default,
                         headers: headers
                         )
                .responseJSON{ (response) in
//                    print(response)
                    if let data = response.data, let respData = NSString(data: data, encoding: String.Encoding.ascii.rawValue){
                        let jsonDecoder = JSONDecoder()
                        var titleMsg: String? = "Success"
                        var bodyMsg: String?  = "Todo saved!"
                        if let responseData = try? jsonDecoder.decode(saveTodoResp.self, from: data){
                            if responseData.success == false{
                                titleMsg = "Failed"
                                bodyMsg = "Save Todo Failed!"
                                
                                let alert = UIAlertController(title: nil, message: titleMsg, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: bodyMsg, style: .default, handler: { _ in
                                }))
                                self.present(alert, animated: true,completion: nil)
                            }else{
                                let alert = UIAlertController(title: nil, message: titleMsg, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: bodyMsg, style: .default, handler: { _ in
                                }))
                                hitAPI = true
                                self.present(alert, animated: true,completion:{
                                    let window = UIApplication.shared.keyWindow
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let secondVC = storyBoard.instantiateViewController(withIdentifier: "listIdentifier")
                                    window?.rootViewController = secondVC
                                })
                                
//                                self.present(alert, animated: true, completion:nil)
//                                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "dreamDetailIdentifier") as? DreamDetailViewController
//                                self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
                            }
                        }
                    }
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
