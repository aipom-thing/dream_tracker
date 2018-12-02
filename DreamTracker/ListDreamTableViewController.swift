//
//  ListDreamTableViewController.swift
//  DreamTracker
//
//  Created by Thing on 01/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//
import Alamofire
import UIKit

var hitAPI = false
var myIndex = 0
var dreamID = 0
var globalDreams: [DreamData] = []

struct ToDoData: Codable{
    let id: Int?
    let title: String?
    let is_checked: Bool?
}

struct DreamData: Codable{
    let id: Int?
    let user_id: Int?
    var title: String?
    var description: String?
    let image_uri: String?
    let todo: [ToDoData]
}

struct GetDreamData: Codable{
    let success: Bool?
    let error: String?
    let data: [DreamData]
}

class ListDreamTableViewController:
    UITableViewController {

    var dreams: [DreamData] = []
    
    @IBOutlet var listDreamTableView: UITableView!
    
    weak var delegate: LoginViewController!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DispatchQueue.main.async(execute: {
            let header = [
                "Authorization" : "Bearer " + AccessToken
            ]

            Alamofire.request("http://93.188.167.250:8080/me/dreams", headers: header)
                .responseJSON { response in
                    switch response.result{
                    case .success(let value):
                        print("LIST")
                        print(value)
                        if let data = response.data {
                            let jsonDecoder = JSONDecoder()
                            if let responseData = try? jsonDecoder.decode(GetDreamData.self, from:data){

                                var i = 0
                                while(i<(responseData.data).count){
                                    self.dreams.append(responseData.data[i])
                                    i+=1
                                }

                            }
                        }
                        break;
                    case .failure(_):
                        break;
                    }
                    
                    globalDreams = self.dreams
                    self.listDreamTableView.reloadData()
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dreams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DreamCell", for: indexPath) as! CustomTableViewCell
        
        let allTodo = dreams[indexPath.row].todo.count
        var checkedTodo = 0
        
        var i=0
        while(i < dreams[indexPath.row].todo.count){
            if dreams[indexPath.row].todo[i].is_checked == true {
                checkedTodo += 1
            }
            i+=1
        }
        
        cell.titleLabel.text = dreams[indexPath.row].title
        cell.descLabel.text = dreams[indexPath.row].description
        cell.todoLabel.text = "Progress " + String(checkedTodo) + "/" + String(allTodo)
        let url = NSURL(string:dreams[indexPath.row].image_uri ?? "")
        let data = NSData(contentsOf:url! as URL)
        if data != nil {
            cell.thumbnailImageView.image = UIImage(data:data! as Data)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        dreamID = dreams[myIndex].id ?? 0
        performSegue(withIdentifier: "DreamDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DreamDetail") {
            let vc = segue.destination as! DreamDetailViewController
            vc.dreamDtlID = dreams[myIndex].id ?? 0
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
