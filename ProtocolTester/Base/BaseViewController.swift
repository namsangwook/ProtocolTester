//
//  BaseViewController.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/27.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct TestCase {
    var name: String
    var method: HTTPMethod = .get
    var result: String = "testing..."
    var request: String = ""
    var response: String = ""
}


class Toast
{
    class private func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String)
    {

        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "", size: 15)
        label.adjustsFontSizeToFitWidth = true

        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR

        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: appDelegate.window!.frame.size.height - 50, width: appDelegate.window!.frame.size.width, height: 44)

        label.alpha = 1

        appDelegate.window!.addSubview(label)

        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;

        UIView.animate(withDuration
            :1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                label.frame = basketTopFrame
        },  completion: {
            (value: Bool) in
            UIView.animate(withDuration:1.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                label.alpha = 0
            },  completion: {
                (value: Bool) in
                label.removeFromSuperview()
            })
        })
    }

    class func showPositiveMessage(message:String)
    {
        showAlert(backgroundColor: UIColor.green, textColor: UIColor.white, message: message)
    }
    class func showNegativeMessage(message:String)
    {
        showAlert(backgroundColor: UIColor(247, 107, 107), textColor: UIColor.white, message: message)
    }
}

class BaseViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btns: [UIButton]!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    private let manager = Session()
    
    static var totalTestCase: Int = 0
    static var passTestCase: Int = 0

    
    var lists: [TestCase] = []
    var showDetail: [Bool] = []
    var testCaseIndex = 0
    
    let dispatchQueue = DispatchQueue(label: "myQueue", qos: .background)
    
    func getHeaders(method: HTTPMethod) -> HTTPHeaders {
        let uuid = UUID().uuidString
        //        let base64 = "OTA:ota_system".toBase64()
        let credential = Data("OTA:ota_system".utf8).base64EncodedString()

        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": method == .get ? "application/json" : "application/json",
            "authorization": "Basic \(credential)",
            "iptv-lang-type": UserManager.shared.languageCode,
            "iptv-tx-id": uuid,
            "iptv-login-token" : UserManager.shared.loginToken,
            "Deivce-Token": UserManager.shared.deviceToken
        ]
        return headers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btns.forEach { (btn) in
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            btn.layer.cornerRadius = btn.frame.size.height / 4
            btn.layer.masksToBounds = true
        }

        self.indicator.isHidden = true
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
        testInit()
        dispatchQueue.async {
            
            DispatchQueue.main.async {
                self.btns.forEach { (btn) in
                    btn.isEnabled = false
                }
                self.indicator.isHidden = false
                self.indicator.startAnimating()
            }
            self.test()
            DispatchQueue.main.async {
                self.btns.forEach { (btn) in
                    btn.isEnabled = true
                }
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            }
        }
    }

    @IBAction func resetBtnClicked(_ sender: Any) {
        tableView.reloadData()
    }
    
    @objc func test() {
        fatalError()
    }

    func testInit() {
        lists = []
        showDetail = []
        testCaseIndex = 0

    }
    
    func appendTestCase(name: String) {
        if name.count > 0 {
            lists.append(TestCase(name: name))
            showDetail.append(false)
        }
    }
    
    func getBasicInfo() {
        
        if UserManager.shared.categoryVersion != "0",
            UserManager.shared.overallCategoryId.count > 0,
            UserManager.shared.newReleaseCategoryId.count > 0,
            UserManager.shared.singleVodContentId.count > 0,
            UserManager.shared.seriesVodContentId.count > 0 {
            return
        }

        if let login = loginott(loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw)
        {
            let profiles = login["profile"].arrayValue
            profiles.forEach { (profile) in
                if profile["lastLoginYN"] == "Y" {
                    if profile["lockYN"] == "N" {
                        UserManager.shared.loginToken = login["loginToken"].stringValue
                        UserManager.shared.SAID = login["said"].stringValue
                        UserManager.shared.profileId = profile["profileId"].stringValue
                        return
                    } else {
                        if let profileLogin = profilelogin(profileId: profile["profileId"].stringValue) {
                            UserManager.shared.loginToken = profileLogin["loginToken"].stringValue
                            UserManager.shared.SAID = profileLogin["said"].stringValue
                            UserManager.shared.profileId = profileLogin["profileId"].stringValue
                            return
                        }
                    }
                }
            }
        }
//        guard let login = loginott(loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) else {
//            return
//        }
//        UserManager.shared.loginToken = login["loginToken"].stringValue
//        UserManager.shared.SAID = login["said"].stringValue
//        UserManager.shared.profileId = login["profile"][0]["profileId"].stringValue
        
//        _ = getprofile()
//
//        if let profileLogin = profilelogin(profileId: UserManager.shared.profileId) {
//            UserManager.shared.loginToken = profileLogin["loginToken"].stringValue
//        }
        
        guard let version = categoryversioncheck() else {
            return
        }
        let rootCategoryId = version["rootCategoryId"].stringValue
        UserManager.shared.categoryVersion = version["version"].stringValue


        guard let categoryRoot = category(categoryId: rootCategoryId) else {
            return
        }

        let homeCategoryId = categoryRoot[0]["categoryId"].stringValue
        

        guard let categoryHome = category(categoryId: homeCategoryId) else {
            return
        }

        let overallCategoryId = categoryHome[0]["categoryId"].stringValue
        UserManager.shared.overallCategoryId = overallCategoryId
        
        guard let overall = category(categoryId: overallCategoryId)
            , let overallList = overall.array else {
                return
        }
        
        overallList.forEach { (content) in
            if content["categoryName"].stringValue == "New Release" {
                UserManager.shared.newReleaseCategoryId = content["categoryId"].stringValue
            }
        }
        
        guard let new = contentlist(categoryId: UserManager.shared.newReleaseCategoryId) else {
            return
        }
        
        guard let contentList = new["contentList"].array else {
            return
        }

        contentList.forEach { (content) in
            if content["isSeries"] == "N" {
                if UserManager.shared.singleVodContentId.count == 0 {
                    UserManager.shared.singleVodContentId = content["contentGroupId"].stringValue
                }
            } else {
                if UserManager.shared.seriesVodContentId.count == 0 {
                    UserManager.shared.seriesVodContentId = content["seriesAssetId"].stringValue
                }
            }
        }
    }
}


extension BaseViewController {
    func requestMBSSynchronous(_ requestUrl: URLConvertible,
                    method: HTTPMethod = .get,
                    parameters: Parameters,
                    index: Int) -> JSON?
    {
        let ds = DispatchSemaphore( value: 0 )
        
        let headers = self.getHeaders(method: method)
        
        
        var data: JSON?
        var resultString = "fail"
        
        self.requestData(requestUrl, method: method, parameters: parameters, headers: headers) { (result, jsonObject, response, error) in
            if index < self.lists.count {
                BaseViewController.totalTestCase += 1
            }
            var requestUrlString = requestUrl
            let headerString = headers.reduce("") { (result, header) -> String in
                result + "\n\t" +  header.description
            }

            let currentDate = Date.now
            let dateString = currentDate.toString(format: "YYYY-MM-dd HH:mm:SS")

            var request = ""
            if method == .get || method == .delete  {
                if let url = response.request?.url {
                    requestUrlString = (String(describing: url))
                }
                request = "* request time : \(dateString)\n* request url : \(requestUrlString)\n* method : \(method.rawValue)\n* headers\(headerString)"

            } else {
                
                var bodyString = String(describing: parameters)
                if let httpBody = response.request?.httpBody,
                    let bodyDesc = String(data: httpBody, encoding: .utf8) {
                    bodyString = bodyDesc
                }
                
                request = "* request time : \(dateString)\n* request url : \(requestUrlString)\n* method : \(method.rawValue)\n* body\n\t\(bodyString)\n* headers\(headerString)"

            }
            
            
            


            if let jsonObject = jsonObject {
                let json = JSON(jsonObject as Any)
                
                
                if index < self.lists.count {
                    self.lists[index].request = request
                    self.lists[index].method = method
                    self.lists[index].response = String(describing: jsonObject)
                }
                if json["returnCode"] == "S" {
                    data = json["data"]
                    resultString = "success"
                    if index < self.lists.count {
                        BaseViewController.passTestCase += 1
                    }
                }
            } else {
                if index < self.lists.count {
                    self.lists[index].request = request
                    self.lists[index].method = method
                    self.lists[index].response = String(describing: error)
                }

            }
            ds.signal()
        }
        ds.wait()
        if index < self.lists.count {
            self.lists[index].result = resultString
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            testCaseIndex += 1
        }
        

        return data
    }
    
    
    
//    typealias completionClosure = (JSON) -> Void
//
//    func requestMBS(_ requestUrl: URLConvertible,
//                    method: HTTPMethod = .get,
//                    parameters: Parameters,
//                    completion: completionClosure?,
//                    index: Int)
//    {
//
//        let headers = self.getHeaders(method: method)
//        self.requestData(requestUrl, method: method, parameters: parameters, headers: headers) { (result, jsonObject, response, error) in
//            guard let jsonObject = jsonObject else {
//                self.lists[index].result = "fail"
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                return
//            }
//            let json = JSON(jsonObject as Any)
//
//            let request = "request url: \(requestUrl)\nmethod: \(method)\nparams : \(String(describing: parameters))\nheaders: \(String(describing: headers))"
//            self.lists[index].request = request
//
//            self.lists[index].response = String(describing: jsonObject)
//            if json["returnCode"] == "S" {
//                if let completion = completion {
//                    let data = json["data"]
//                    self.lists[index].result = "success"
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                    completion(data)
//                    //                    semaphore.signal()
//                } else {
//                    self.lists[index].result = "success"
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            } else {
//                self.lists[index].result = "fail"
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
}

extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
//        let unreserved = "-._~?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}

extension BaseViewController {
    func requestData(_ convertible: URLConvertible,
                     method: HTTPMethod = .get,
                     parameters: Parameters? = nil,
                     headers: HTTPHeaders? = nil,
                     completion: @escaping (Bool, Dictionary<String, Any>?, AFDataResponse<Data>, NSError?) -> Void)
    {
//        let semaphore = DispatchSemaphore(value: 0)
        
//        var urlParams = ""
//        if let params = parameters {
//            urlParams = params.compactMap({ (key, value) -> String in
//                if var value = value as? String {
//                    value = value.stringByAddingPercentEncodingForRFC3986() ?? value
////                    value = value.replacingOccurrences(of: "/", with: "%2F")
//                    return "\(key)=\(value)"
//                } else {
//                    return "\(key)=\(value)"
//                }
//            }).joined(separator: "&")
//        }
//        let urlRequest = convertible as! String + "?" + urlParams
        
        
        let urlRequest = convertible
        
        manager.request((method == .get || method == .delete) ? urlRequest : convertible,
                        method: method,
                        parameters: (method == .get || method == .delete) ? parameters : parameters,
                        encoding: (method == .get || method == .delete) ? URLEncoding.queryString : JSONEncoding.default,
                        headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (response: AFDataResponse<Data>) in
                if let url = response.request?.url {
                    print("\n==========================================================================")
                    print("* request: \(String(describing: url))")
                }
                if method == .post || method == .put {
                    if let httpBody = response.request?.httpBody,
                        let bodyDesc = String(data: httpBody, encoding: .utf8) {
                        print("* httpBody: \(bodyDesc)")
                    }
                }
                
                print(">>> Headers : \(String(describing: headers))")
                guard let data = response.data else {
                    completion(false, nil, response, nil)
                    Logger.log("data is nil")
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
//                    semaphore.signal()
                    return
                }
                
                if let text = String(data: data, encoding: .utf8) {
                    print("* response : \(text)")
                    print("==========================================================================\n")

                }
                
                do {
                    if let jsonDic = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, Any>
                    {
                        //                        print(jsonDic) // use the json here
                        completion(true, jsonDic, response, nil)
                        //                        if let dt = jsonDic["data"] as? Dictionary<String, Any> {
                        //                            if let list = dt["list"] as? Array<Any> {
                        //                                print(list.count)
                        //
                        //                            }
                        //                        }
//                        semaphore.signal()
                    } else {
                        completion(false, nil, response, nil)
                        Logger.log("bad json")
//                        semaphore.signal()
                    }
                } catch let error as NSError {
                    completion(false, nil, response, error)
                    Logger.log(String(describing: error))
                    if let res = response.response {
                        Logger.log(String(describing: res))
                    }
//                    semaphore.signal()
                    
                }
        }
        
        // Wait until the previous API request completes
//        semaphore.wait()

    }
}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
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


// MARK: - MBS
extension BaseViewController {
    func loginott(name: String = "", loginId: String, loginPw: String, loginToken: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/loginott"
        var params = [
            "deviceToken": UserManager.shared.deviceToken,
            "loginId": loginId,
            "loginPw": loginPw.sha256()
        ]
        if loginToken.count > 0 {
            params = [
                "deviceToken": UserManager.shared.deviceToken,
                "loginToken": loginToken,
                "loginId": "",
                "loginPw": ""
            ]
        }
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func getprofile(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/getprofile"
        let params = [
            "said": UserManager.shared.SAID
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func profilelogin(name: String = "", profileId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/profilelogin"
        let params = [
            "deviceToken": UserManager.shared.deviceToken,
            "loginId": UserManager.shared.loginId,
            "said": UserManager.shared.SAID,
            "profileId": profileId,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func profileCreate(name: String = "", profileName: String, profilePic: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/profile"
        let params = [
            "said": UserManager.shared.SAID,
            "profileName": profileName,
            "profilePic": profilePic
        ]
        return requestMBSSynchronous(requestUrl, method: .post, parameters: params, index: self.testCaseIndex)
    }

    func profileDelete(name: String = "", profileId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/profile"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": profileId
        ]
        return requestMBSSynchronous(requestUrl, method: .delete, parameters: params, index: self.testCaseIndex)
    }

    
    func checkpincode(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/checkpincode"
        let params = [
            "type": "accountPin", // accountPin or profilePin
            "loginId": UserManager.shared.loginId,
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "pinCode": "0000",
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func changeinfo(name: String = "", profileName: String = "", profilePic: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/profile/changeinfo"
        
        var params: Parameters = Parameters()
        params["said"] = UserManager.shared.SAID
        params["profileId"] = UserManager.shared.profileId
        params["profilePic"] = profilePic
        if profileName.count > 0 {
            params["profileName"] = profileName
        }

        return requestMBSSynchronous(requestUrl, method: .put,  parameters: params, index: self.testCaseIndex)
    }
    
    func accountresetpassword(name: String = "", loginPw: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/accountresetpassword"
        let params = [
            "loginId": UserManager.shared.loginId,
            "loginPw": loginPw.sha256(),
        ]
        return requestMBSSynchronous(requestUrl, method: .put,  parameters: params, index: self.testCaseIndex)
    }
    
    func categoryversioncheck(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/categoryversioncheck"
        let params = [
            "deviceType": UserManager.shared.deviceType,
            "version": UserManager.shared.categoryVersion
            
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func category(name: String = "", categoryId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/category"
        let params = [
            "version": UserManager.shared.categoryVersion,
            "said": UserManager.shared.SAID,
            "language": UserManager.shared.languageCode,
            "deviceType": UserManager.shared.deviceType,
            "categoryId": categoryId
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
        
    }
    
    func contentlist(name: String = "", categoryId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/contentlist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "categoryId": categoryId,
            "startNo": "0",
            "contentCnt": "20",
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func bannerList(name: String = "", bannerId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/bannerlist"
        let params = [
            "said": UserManager.shared.SAID,
            "bannerPositionId": bannerId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func recentlyWatching(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/recentwatchinglist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func vodwithpackage(name: String = "", contentId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/vodwithpackage"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "contentId": contentId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func packagedetail(name: String = "", offerId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/packagedetail"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "offerId": offerId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func serieslist(name:String = "", seriesId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/serieslist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "seriesAssetId": seriesId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func seasonlist(name:String = "", seriesId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/seasonlist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "seriesAssetId": seriesId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func nodeip(name:String = "", contentType: String = "VOD", contentPath: String, movieId: String, payYn: Bool, resumeYn: Bool) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/nodeip"
        
        var params = Parameters()
        params["said"] = UserManager.shared.SAID
        params["profileId"] = UserManager.shared.profileId
        params["contentType"] = contentType
        params["contentPath"] = contentPath
        params["movieId"] = movieId
        params["payYn"] = payYn ? "Y" : "N"
        params["resumeYn"] = resumeYn ? "Y" : "N"
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func channellist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/channellist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
//            "said": "",
//            "profileId": "",
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func popularchannel(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/popularchannel"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func favoritechannel(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/favoritechannel"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func channelproductinfo(name: String = "", channelId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/channelproductinfo"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
            "channelId": channelId
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func watchinginfo(name: String = "", channelId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/watchinginfo"
        var params = Parameters()
        params["said"] = UserManager.shared.SAID
        params["profileId"] = UserManager.shared.profileId
        params["deviceType"] = UserManager.shared.deviceType
        params["uuid"] = UserManager.shared.deviceToken
        let currentDate = Date.now
        let dateString = currentDate.toString(format: "YYYY-MM-dd HH:mm:SS")

        params["list"] = [["channelId": channelId, "entDt": dateString]]
        return requestMBSSynchronous(requestUrl, method: .post, parameters: params, index: self.testCaseIndex)
    }
    
    func epg(name: String = "", channelId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/epg"
        let params = [
            "said": UserManager.shared.SAID,
            "channelId": channelId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func retrieveowncouponhomeinfo(name: String = "", includeCoupons: Bool) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/retrieveowncouponhomeinfo"
        let params = [
            "said": UserManager.shared.SAID,
            "includeCoupons": includeCoupons ? "Y" : "N",
            "profileId": UserManager.shared.profileId,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func vodlikeGet(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/vodlike"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, method: .get, parameters: params, index: self.testCaseIndex)
    }
    
    func vodlikePost(name: String = "", contentId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/vodlike"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "type": "VOD",
            "contentId": contentId
        ]
        return requestMBSSynchronous(requestUrl, method: .post, parameters: params, index: self.testCaseIndex)
    }
    
    func vodlikeDelete(name: String = "", contentId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/vodlike"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "contentId": contentId
        ]
        return requestMBSSynchronous(requestUrl, method: .delete, parameters: params, index: self.testCaseIndex)
    }
    
    func purchaselist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/purchaselist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func collectionlist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/collectionlist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func retrieveowncouponlist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/retrieveowncouponlist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "searchTarget": "ALL", // searchTarget [ALL(전체), THB(Cash), RATE(Discount), EXPIRING(만료1달전)]
            "includehistory": "Y", // 조회기간 포함 여부(1년) [true(조회 기간 포함), false]
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func subscriptionlist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/subscriptionlist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    func stopsubscription(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/stopsubscription"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "productId" : "B1001",
            "offerId" : "OF20001"
        ]
        return requestMBSSynchronous(requestUrl, method: .put, parameters: params, index: self.testCaseIndex)
    }
    
    
    func messagelist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/messagelist"
        let params = [
            "said": UserManager.shared.SAID,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func faqlist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/faqlist"
        let params = [
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    
    
    func smartdownload(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/smartdownload"
        var params: Parameters = Parameters()
        params["language"] = UserManager.shared.languageCode
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }

    func retrieveproductcouponlist(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/retrieveproductcouponlist"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    func requestpromotioncouponnumberregister(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/requestpromotioncouponnumberregister"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "couponNumber": "010350304144001",
        ]
        return requestMBSSynchronous(requestUrl, method: .post, parameters: params, index: self.testCaseIndex)
    }
    
    func purchasecoupon(name: String = "") -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/purchasecoupon"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "offerId" : "1005",
            "totalPrice" : "100",
            "paymentMethod" : "06"
        ]
        return requestMBSSynchronous(requestUrl, method: .post, parameters: params, index: self.testCaseIndex)
    }
    
    func purchaselisthidden(name: String = "", offerId: [String]) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/purchaselisthidden"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "offerId" : offerId,
            ] as [String : Any]
        return requestMBSSynchronous(requestUrl, method: .put, parameters: params, index: self.testCaseIndex)
    }
    
    func collectionlisthidden(name: String = "", offerId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/collectionlisthidden"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "offerId" : offerId,
            ] as [String : Any]
        return requestMBSSynchronous(requestUrl, method: .put, parameters: params, index: self.testCaseIndex)
    }
    
    func paymentmethod(name: String = "", contentType: String, offerId: String) -> JSON? {
        appendTestCase(name: name)
        let requestUrl = Defines.baseUrl + "/paymentmethod"
        let params = [
            "said": UserManager.shared.SAID,
            "profileId": UserManager.shared.profileId,
            "language": UserManager.shared.languageCode,
            "contentType": contentType,
            "offerId": offerId
        ]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
    
}


extension BaseViewController {
    func totalSearch(name: String = "",
                     contentsType: String, // 컨텐츠유형 0xFF, 0x00: 통합검색, 0x01: VOD 검색, 0x02: 실시간채널 검색
        sortType: String?, // 1: 오름차순, 0: 내림차순
        searchPosition: String = "0", // 시작위치(0부터)
        searchCount: String = "20", // 페이지당 반환개수
        searchWord: String, // 검색어
        sortFields: String? = nil, // 정렬필드정보, pro_name 제목순, broad_time 입수일자
        cate: String? = nil, // 장르에 해당하는 카테고리 값(특정 카테고리 필터링) Ex) 4200(null 일 경우 전체 vod 검색)
        product_id: String, // 가입자 상품종류코드 – 서비스가능채널 + 부가채널 Ex) 2P02 상폼코드별 필터링정보로 활용
        adult_yn: String? = nil, // 성인 여부 Ex) true : 성인 false: 성인 아님 null 일 경우 default=true
        exposure_time: String = "24", // 노출시간 Ex) 24 (채널 검색에서만 사용)
        won_yn: String? = nil // 유무료 핕터링 조건, Y : 유료만 필터링, N : 무료만 필터링,없음 : 전체 검색
    ) -> JSON?
    {
        appendTestCase(name: name)
        let requestUrl = Defines.searchUrl + "/totalSearch"
        
        var params: Parameters = Parameters()
        params["contents_type"] = contentsType
        params["sortType"] = sortType
        params["searchPosition"] = searchPosition
        params["searchCount"] = searchCount
        params["searchWord"] = searchWord
        params["sortFields"] = sortFields
        params["cate"] = cate
        params["product_id"] = product_id
        params["adult_yn"] = adult_yn
        params["sa_id"] = UserManager.shared.SAID
        params["device_Type"] = UserManager.shared.deviceType
        params["exposure_time"] = exposure_time
        params["STB_VER"] = UserManager.shared.appVersion
        params["won_yn"] = won_yn
        params["TRANSACTION_ID"] = UserManager.shared.deviceToken
        params["langType"] = UserManager.shared.languageCode
//        let params = [
//            "said": UserManager.shared.SAID,
//            "profileId": UserManager.shared.profileId,
//            "offerId" : offerId,
//            ] as [String : Any]
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    

    func trendWord(name: String = "", productId: String = "") -> JSON? {
        
        appendTestCase(name: name)
        let requestUrl = Defines.searchUrl + "/trendWord"

        var params: Parameters = Parameters()
        params["sa_id"] = UserManager.shared.SAID
        params["product_id"] = productId
        params["appID"] = UserManager.shared.deviceType
        params["STB_VER"] = UserManager.shared.appVersion
        
        return requestMBSSynchronous(requestUrl, parameters: params, index: self.testCaseIndex)
    }
    
}

extension BaseViewController {
    
    // 연관추천(컨텐츠 연관추천)
    func recomm(name: String = "",
                CONTENT: String, // 추천 Content Type, VOD : Video
        REC_TYPE: String, // 추천 요청 유형, ITEM_VOD : 아이템 기반 VOD추천
        REC_GB_CODE: String?, // 상세보기/종료시 추천 구분, M : 상세보기 추천, ※ 미설정 시 Default : M
        PRODUCT_LIST: String, // 가입상품ID, 가입자의 가입 상품 ID. 가입 상품이 여러 개 있을때는 “,”로 구분 합니다.
        REQ_DATE: String, // 요청 시각, 형식: YYYYMMDDHHmmSS, HH 시간은 24시간 형식. 예) 20120910010133 /  20120910130133
        CONS_ID: String?, // 컨텐츠 ID, 현재 이용중인 콘텐츠 ID.
        CAT_ID: String?, // 차상위카테고리, 차상위 카테고리. 응용추천 시 카테고리 선택의 기준이 된다. 모든 서비스에서는 해당 값을 설정 해야 한다.
        CAT_TYPE: String,   // 차상위카테고리의 타입 추천 시 성인카테고리(19+) 추천 내역 포함 여부 설정. 19+ 컨텐츠 추천을 원하지 않을 경우,
        // 해당값에 “Adult” 이외의 값을 설정 하면 19+컨텐츠가 제외되고 추천 됩니다.
        // 19+ 컨텐츠 추천이 포함된 결과를 원하시면 “Adult”로 설정 하면, 추천 내역에 성인 리스트가 있더라도 필터링 하지 않고 결과를 전송 합니다.
        // 단, MGP는  menu_rating=19,20 일 경우 Adult로 전송
        // * (주의) CAT_TYPE 보다 CONS_RATE값이 우선하므로, “Adult”로 설정하면 CONS_RATE는 항상 N으로 설정해야 함.
        ITEM_CNT: String, // 테마당 리턴받을 항목 개수, 테마 별로 최대 해당 개수만큼을 리턴, (내부 처리 최대 가능 : 30 개 )
        CONS_RATE: String?  // 19세 이상 컨텐츠 필터링 플래그
        // Y : 19세 이상 컨텐츠 필터링하여 제거함. (19세 이상 콘텐츠를 미노출함.)
        // N : 19세 이상 컨텐츠 필터링하지 않음. (19세 이상 콘텐츠를 노출함.)
        // ※ 미전송시 Default 값 : App Code가 I(OTM) : Filtering 함. 그외 : Filtering 하지 않음.
    ) -> JSON? {
        
        appendTestCase(name: name)
        let requestUrl = Defines.recommendUrl + "/recomm"
        
        var param: Parameters = Parameters()
        param["CONTENT"] = CONTENT
        param["REC_TYPE"] = REC_TYPE
        param["REC_GB_CODE"] = REC_GB_CODE
        param["SA_ID"] = UserManager.shared.SAID
        param["PRODUCT_LIST"] = PRODUCT_LIST
        param["REQ_DATE"] = REQ_DATE
        param["SVC_CODE"] = UserManager.shared.deviceType
        param["CONS_ID"] = CONS_ID
        param["CAT_ID"] = CAT_ID
        param["CAT_TYPE"] = CAT_TYPE
        param["ITEM_CNT"] = ITEM_CNT
        param["CONS_RATE"] = CONS_RATE
        param["STB_VER"] = UserManager.shared.appVersion
        param["PROFILE_ID"] = UserManager.shared.profileId
        param["LANGTYPE"] = UserManager.shared.languageCode
        
        return requestMBSSynchronous(requestUrl, parameters: param, index: self.testCaseIndex)
    }
    
    // 큐레이션(사용자기반 개인화추천)
    func curation(name: String = "",
                  CONTENT: String, // 추천 Content Type, VOD : Video
                     REC_TYPE: String, // 추천 요청 유형, CURATION : 큐레이션 추천 정보
                     PRODUCT_LIST: String, // 가입상품ID, 가입자의 가입 상품 ID. 가입 상품이 여러 개 있을때는 “,”로 구분 합니다.
                     REQ_DATE: String, // 요청 시각, 형식: YYYYMMDDHHmmSS, HH 시간은 24시간 형식. 예) 20120910010133 /  20120910130133
                     CONS_ID: String,
                     MENU_MAX_CNT: Int, // 리턴받을 메뉴 최대개수
                     MENU_MIN_CNT: Int, // 리턴받을 메뉴 최소개수
                     ITEM_MAX_CNT: Int, // 리턴받을 메뉴당 최대 아이템 개수
                     ITEM_MIN_CNT: Int, // 리턴받을 메뉴당 최소 아이템 개수
                     CONS_RATE: String?    // 19세 이상 컨텐츠 필터링 플래그
                                            // Y : 19세 이상 컨텐츠 필터링하여 제거함. (19세 이상 콘텐츠를 미노출함.)
                                            // N : 19세 이상 컨텐츠 필터링하지 않음. (19세 이상 콘텐츠를 노출함.)
                                            // ※ 미전송시 Default 값 : App Code가 I(OTM) : Filtering 함. 그외 : Filtering 하지 않음.
                     ) -> JSON? {
        
        appendTestCase(name: name)
        let requestUrl = Defines.recommendUrl + "/curation"

        var param: Parameters = Parameters()
        param["CONTENT"] = CONTENT
        param["REC_TYPE"] = REC_TYPE
        param["SA_ID"] = UserManager.shared.SAID
        param["PRODUCT_LIST"] = PRODUCT_LIST
        param["REQ_DATE"] = REQ_DATE
        param["CONS_ID"] = CONS_ID
        param["SVC_CODE"] = UserManager.shared.deviceType
        param["MENU_MAX_CNT"] = MENU_MAX_CNT
        param["MENU_MIN_CNT"] = MENU_MIN_CNT
        param["ITEM_MAX_CNT"] = ITEM_MAX_CNT
        param["ITEM_MIN_CNT"] = ITEM_MIN_CNT
        param["STB_VER"] = UserManager.shared.appVersion
        param["PROFILE_ID"] = UserManager.shared.profileId
        param["LANGTYPE"] = UserManager.shared.languageCode
        
        return requestMBSSynchronous(requestUrl, parameters: param, index: self.testCaseIndex)
    }
    
    // 인기기반 추천 컨텐츠
    func topcontent(name: String = "",
                    CONTENT: String, // 추천 Content Type, VOD : Video
        REC_TYPE: String, // 추천 요청 유형, ITEM_VOD : 아이템 기반 VOD추천
        PRODUCT_LIST: String, // 가입상품ID, 가입자의 가입 상품 ID. 가입 상품이 여러 개 있을때는 “,”로 구분 합니다.
        REQ_DATE: String, // 요청 시각, 형식: YYYYMMDDHHmmSS, HH 시간은 24시간 형식. 예) 20120910010133 /  20120910130133
        REQ_CODE: String, // 추천 요청 어플 구분, App Code * Appendix A 각 서비스별 Code Table 참조
        CONS_RATE: String?  // 19세 이상 컨텐츠 필터링 플래그
        // Y : 19세 이상 컨텐츠 필터링하여 제거함. (19세 이상 콘텐츠를 미노출함.)
        // N : 19세 이상 컨텐츠 필터링하지 않음. (19세 이상 콘텐츠를 노출함.)
        // ※ 미전송시 Default 값 : App Code가 I(OTM) : Filtering 함. 그외 : Filtering 하지 않음.
    ) -> JSON? {
        
        appendTestCase(name: name)
        let requestUrl = Defines.recommendUrl + "/topcontent"
        
        var param: Parameters = Parameters()
        param["CONTENT"] = CONTENT
        param["REC_TYPE"] = REC_TYPE
        param["SA_ID"] = UserManager.shared.SAID
        param["PRODUCT_LIST"] = PRODUCT_LIST
        param["REQ_DATE"] = REQ_DATE
        param["REQ_CODE"] = REQ_CODE
        param["SVC_CODE"] = UserManager.shared.deviceType
        param["CONS_RATE"] = CONS_RATE
        param["STB_VER"] = UserManager.shared.appVersion
        param["PROFILE_ID"] = UserManager.shared.profileId
        param["LANGTYPE"] = UserManager.shared.languageCode
        
        return requestMBSSynchronous(requestUrl, parameters: param, index: self.testCaseIndex)
        
    }
    
}


extension BaseViewController {
    func addLog(_ log: String, extra1: String = "LOG", extra2: String = "LOG") {
        lists.append(TestCase(name: log, method: .get, result: "Log", request: extra1, response: extra2))
        showDetail.append(false)
        testCaseIndex += 1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
