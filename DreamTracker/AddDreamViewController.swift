//
//  AddDreamViewController.swift
//  DreamTracker
//
//  Created by Thing on 02/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Alamofire
import UIKit

class AddDreamViewController: UIViewController {

    @IBOutlet weak var dreamTitle: UITextField!
    
    @IBOutlet weak var dreamDesc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSaveDream(_ sender: UIBarButtonItem) {
        
        let title = dreamTitle.text ?? ""
        let desc = dreamDesc.text ?? ""
        
        if title.isEmpty || desc.isEmpty {
            let alert = UIAlertController(title: nil, message: "Invalid Input", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Please fill all fields!", style: .default, handler: { _ in
            }))
            self.present(alert, animated: true,completion: nil)
        }else{
            let headers = [
//                "Authorization" : "Bearer " + "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZlckBmZXIuY29tIiwiaWQiOiIxIiwibmFtZSI6IkZlcmljbyJ9.XvvHvQyP8YuukKtyXsohpe1-H1BY-pWb94kbtnIL5PQ",
                "Authorization" : "Bearer " + AccessToken,
                "Content-Type": "application/json"
            ]
            
            var titleAlert = "Save Dream Failed"
            var msgAlert = "Please Try Again Later!"
            Alamofire
                .request(URL(string: "http://93.188.167.250:8080/dreams")!,
                         method: .post,
                         parameters: [
                            "title":title,
                            "description":desc,
                        ],
                         encoding: JSONEncoding.default,
                         headers: headers
                )
                .responseJSON{ (response) in
                    switch response.result {
                    case .success(let value):
                        
                        struct SaveDataResp: Codable{
                            let success: Bool?
                            let error: String?
                            let data: String = ""
                        }
                        
                        if let data = response.data, let respData = NSString(data: data, encoding: String.Encoding.ascii.rawValue){
                            let jsonDecoder = JSONDecoder()
                            if let responseData = try? jsonDecoder.decode(SaveDataResp.self, from: data){
                                if responseData.success == true {
                                    titleAlert = "Success"
                                    msgAlert = "Dream saved successfully"
                                }else{
                                    break;
                                }
                            }
                        }
                        
                        break;
                    case .failure(_):
                        break;
                    }
                let alert = UIAlertController(title: nil, message: titleAlert, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: msgAlert, style: .default, handler: { _ in
                }))
                self.present(alert, animated: true,completion:{
                    let window = UIApplication.shared.keyWindow
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let secondVC = storyBoard.instantiateViewController(withIdentifier: "listIdentifier")
                    window?.rootViewController = secondVC
                })
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
