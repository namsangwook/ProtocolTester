//
//  VodViewController.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/27.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import SwiftyJSON

class HomeTestViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btns: [UIButton]!

    static var instance: HomeTestViewController {
        UIStoryboard.init(name: "Tester", bundle: nil).instantiateViewController(withIdentifier: "VodViewController") as! HomeTestViewController
    }
    
    
    
    var lists = [
        ["name": "categoryversioncheck", "method": "get", "result": "not tested", "request": "", "response": ""],
        ["name": "category(root)", "method": "get", "result": "not tested", "request": "", "response": ""],
        ["name": "category(home)", "method": "get", "result": "not tested", "request": "", "response": ""],
        ["name": "category(oeverall)", "method": "get", "result": "not tested", "request": "", "response": ""],

    ]
    
    var showDetail: [Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lists.forEach { (list) in
            showDetail.append(false)
        }
        
        btns.forEach { (btn) in
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            btn.layer.cornerRadius = btn.frame.size.height / 4
            btn.layer.masksToBounds = true
        }


        // Do any additional setup after loading the view.
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
        test()
    }
    
    @IBAction func resetBtnClicked(_ sender: Any) {
        tableView.reloadData()
    }


}

extension HomeTestViewController {
    func test() {
        
        
        let dispatchQueue = DispatchQueue(label: "myQueue", qos: .background)
        dispatchQueue.async {
            
            var index = 0
            var requestUrl = Defines.baseUrl + "/categoryversioncheck"
            var params = [
                "deviceType": UserManager.shared.deviceType,
                "version": UserManager.shared.categoryVersion
                
            ]
            var method: HTTPMethod = .get
            var headers = self.getHeaders(method: method)
            
            
            var rootCategoryId = ""
            
            self.requestData(requestUrl, method: method, parameters: params, headers: headers) { (result, jsonObject) in
                guard let jsonObject = jsonObject else {
                    return
                }
                let json = JSON(jsonObject as Any)
                
                let request = "request url: \(requestUrl)\nmethod: \(method)\nparams : \(String(describing: params))\nheaders: \(String(describing: headers))"
                self.lists[index]["request"] = request
                
                self.lists[index]["response"] = String(describing: jsonObject)
                if json["returnCode"] == "S" {
                    self.lists[index]["result"] = "success"
                    let data = json["data"]
                    rootCategoryId = data["rootCategoryId"].stringValue
                    UserManager.shared.categoryVersion = data["version"].stringValue
                } else {
                    self.lists[index]["result"] = "fail"
                }
                
                self.tableView.reloadData()
            }
            
            print(">>>>>> root : \(rootCategoryId)")
            
            index += 1
            var homeCategoryId = ""
            
            requestUrl = Defines.baseUrl + "/category"
            params = [
                "version": UserManager.shared.categoryVersion,
                "said": UserManager.shared.SAID,
                "language": UserManager.shared.languageCode,
                "deviceType": UserManager.shared.deviceType,
                "categoryId": rootCategoryId
            ]
            method = .get
            headers = self.getHeaders(method: method)
            
            
            self.requestData(requestUrl, method: method, parameters: params, headers: headers) { (result, jsonObject) in
                guard let jsonObject = jsonObject else {
                    return
                }
                let json = JSON(jsonObject as Any)
                
                let request = "request url: \(requestUrl)\nmethod: \(method)\nparams : \(String(describing: params))\nheaders: \(String(describing: headers))"
                self.lists[index]["request"] = request
                
                self.lists[index]["response"] = String(describing: jsonObject)
                if json["returnCode"] == "S" {
                    self.lists[index]["result"] = "success"
                    let data = json["data"]
                    homeCategoryId = data[0]["categoryId"].stringValue
                } else {
                    self.lists[index]["result"] = "fail"
                }
                
                self.tableView.reloadData()
            }
            
            print(">>>>>> home : \(homeCategoryId)")
            
            index += 1
            
            var overallCategoryId = ""
            
            requestUrl = Defines.baseUrl + "/category"
            params = [
                "version": UserManager.shared.categoryVersion,
                "said": UserManager.shared.SAID,
                "language": UserManager.shared.languageCode,
                "deviceType": UserManager.shared.deviceType,
                "categoryId": homeCategoryId
            ]
            method = .get
            headers = self.getHeaders(method: method)
            
            
            self.requestData(requestUrl, method: method, parameters: params, headers: headers) { (result, jsonObject) in
                guard let jsonObject = jsonObject else {
                    return
                }
                let json = JSON(jsonObject as Any)
                
                let request = "request url: \(requestUrl)\nmethod: \(method)\nparams : \(String(describing: params))\nheaders: \(String(describing: headers))"
                self.lists[index]["request"] = request
                
                self.lists[index]["response"] = String(describing: jsonObject)
                if json["returnCode"] == "S" {
                    self.lists[index]["result"] = "success"
                    let data = json["data"]
                    overallCategoryId = data[0]["categoryId"].stringValue
                } else {
                    self.lists[index]["result"] = "fail"
                }
                
                self.tableView.reloadData()
            }

            print(">>>>>> overall : \(overallCategoryId)")
            
            index += 1
            
            
            var newReleaseCategoryId = ""
            
            requestUrl = Defines.baseUrl + "/category"
            params = [
                "version": UserManager.shared.categoryVersion,
                "said": UserManager.shared.SAID,
                "language": UserManager.shared.languageCode,
                "deviceType": UserManager.shared.deviceType,
                "categoryId": overallCategoryId
            ]
            method = .get
            headers = self.getHeaders(method: method)
            
            
            self.requestData(requestUrl, method: method, parameters: params, headers: headers) { (result, jsonObject) in
                guard let jsonObject = jsonObject else {
                    return
                }
                let json = JSON(jsonObject as Any)
                
                let request = "request url: \(requestUrl)\nmethod: \(method)\nparams : \(String(describing: params))\nheaders: \(String(describing: headers))"
                self.lists[index]["request"] = request
                
                self.lists[index]["response"] = String(describing: jsonObject)
                if json["returnCode"] == "S" {
                    self.lists[index]["result"] = "success"
                    if let contentList = json["data"].array {
                        contentList.forEach { (content) in
                            if content["categoryName"].stringValue == "New Release" {
                                newReleaseCategoryId = content["categoryId"].stringValue
                                return
                            }
                        }
                    }
                } else {
                    self.lists[index]["result"] = "fail"
                }
                
                self.tableView.reloadData()
            }
            
            UserManager.shared.newReleaseCategoryId = newReleaseCategoryId

            print(">>>>>> New Release : \(UserManager.shared.newReleaseCategoryId)")

        }
        
    }
}

extension HomeTestViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetail[indexPath.row] = !showDetail[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        let proto = lists[indexPath.row]
        cell.data = proto
        cell.showDetail = showDetail[indexPath.row]
        return cell
    }
}
