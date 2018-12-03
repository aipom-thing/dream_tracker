//
//  DreamDetailViewController.swift
//  DreamTracker
//
//  Created by Thing on 02/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Alamofire
import UIKit

class DreamDetailViewController: UIViewController {
    
    @IBOutlet weak var dreamImage: UIImageView!
    @IBOutlet weak var dreamDesc: UILabel!
    @IBOutlet weak var dreamTitle: UINavigationItem!
    
    let dreamDetailData = globalDreams[myIndex]
    var dreamDtlID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var sizeRect = UIScreen.main.bounds
        var width    = sizeRect.size.width
        var height   = sizeRect.size.height
        
        print(dreamDtlID)
//        if hitAPI == false{
//            print(dreamDetailData)
//            dreamTitle.title = dreamDetailData.title
//            dreamDesc.text =  dreamDetailData.description
//            let url = NSURL(string:dreamDetailData.image_uri ?? "")
//            let data = NSData(contentsOf:url! as URL)
//            if data != nil {
//                dreamImage.image = UIImage(data:data! as Data)
//            }
//
//        }else{
//            hitAPI = false
            let header = [
                "Authorization" : "Bearer " + AccessToken
            ]
            
            Alamofire.request("http://93.188.167.250:8080/dreams/" + String(dreamDtlID ?? 0), headers: header)
                .responseJSON { response in
                    
                    struct ToDoData: Codable{
                        let id: Int?
                        let title: String?
                        let is_checked: Bool?
                    }
                    
                    struct DreamDtlData: Codable{
                        let id: Int?
                        let user_id: Int?
                        var title: String?
                        var description: String?
                        let image_uri: String?
                        let todo: [ToDoData]
                    }
                    
                    struct GetDreamDtlData: Codable{
                        let success: Bool?
                        let error: String?
                        let data: DreamDtlData
                    }
                    
                    let dreamDtlData: GetDreamDtlData
                    
                    switch response.result{
                    case .success(let value):
                        if let data = response.data {
//                            print(dreamID)
//                            print(value)
                            let jsonDecoder = JSONDecoder()
                            if let responseData = try? jsonDecoder.decode(GetDreamDtlData.self, from: data){
                                if responseData.success == true {
                                    self.dreamTitle.title = responseData.data.title
                                    self.dreamDesc.text =  responseData.data.description
                                    let url = NSURL(string:responseData.data.image_uri ?? "")
                                    let data = NSData(contentsOf:url! as URL)
                                    if data != nil {
                                        self.dreamImage.image = UIImage(data:data! as Data)
                                    }
                                    
                                    var i = 0
                                    while i < responseData.data.todo.count{
                                        let position: CGFloat = 5*height/6 + CGFloat(i*40)
                                        let viewTest = UIView(frame: CGRect(x:0, y:position, width:width, height:30))

                                        let switchDemo = UISwitch()
                                        switchDemo.isOn = responseData.data.todo[i].is_checked ?? false
                                        switchDemo.tag = responseData.data.todo[i].id ?? 0
                                        viewTest.addSubview(switchDemo)
                                        
                                        let switchLbl = UILabel(frame: CGRect(x:60, y:0, width:200, height:30))
                                        switchLbl.text = responseData.data.todo[i].title
                                        viewTest.addSubview(switchLbl)
                                        
                                        self.view.addSubview(viewTest)
                                        
                                        switchDemo.addTarget(self, action: #selector(self.switchChanged), for: UIControlEvents.valueChanged)

                                        i += 1
                                    }
                                }
                            }
                        }
                        break;
                    case .failure(_):
                        break;
                    }
            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = globalDreams[myIndex].title
        navigationItem.backBarButtonItem = backItem
        
        if (segue.identifier == "todoIdentifier") {
            let vc = segue.destination as! SaveTodoViewController
            vc.dreamIDTodo = dreamDtlID
        }
    }

    @objc func switchChanged(mySwitch: UISwitch) {
        let state = mySwitch.isOn
        let tag = mySwitch.tag
        var whatToDo = "uncheck"
        
        if state == true {
                whatToDo = "check"
        }
        
        let headers = [
            "Authorization" : "Bearer " + AccessToken,
            "Content-Type": "application/json"
        ]
        
        struct checkUncheckResp: Codable{
            let success: Bool?
            let data: String? = ""
            let error: String? = ""
        }
        
        Alamofire
            .request(URL(string: "http://93.188.167.250:8080/todo/" + String(tag ?? 0) + "/" + whatToDo)!,
                     method: .post,
                     encoding: JSONEncoding.default,
                     headers: headers
            )
            .responseJSON{ (response) in
                if let data = response.data {
                    let jsonDecoder = JSONDecoder()
                    if let responseData = try? jsonDecoder.decode(checkUncheckResp.self, from: data){
                        if responseData.success == true{
                            print("Success " + whatToDo + " todo id : " + String(tag))
                        }else{
                            print("Failed " + whatToDo + " todo id : " + String(tag))
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
