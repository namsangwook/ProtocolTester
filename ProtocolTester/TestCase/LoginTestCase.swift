//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit
import SwiftyJSON

extension TestMainViewController {
    

    func testLogin() {
        
        if Defines.serverInfo == .tb {
            addLog(">>> Connecting to TB")
        } else if Defines.serverInfo == .staging {
            addLog(">>> Connecting to Staging")
        }
        
//        UserManager.shared.loginToken = ""
        
        if UserManager.shared.loginToken.count > 0 {
            addLog(">> try token login with token", extra1: "login token : \(UserManager.shared.loginToken)")

            if let login = loginott(name: "\tloginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken) {
                processAutoLogin(login: login)
                addLog(">> save token", extra1: "login token : \(UserManager.shared.loginToken)")
            } else {
                addLog(">> token login failed with token", extra1: "login token : \(UserManager.shared.loginToken)")
                addLog(">> try id, password login")

                if let login = loginott(name: "\tloginott", loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) {
                    processAutoLogin(login: login)
                    addLog(">> save token", extra1: "login token : \(UserManager.shared.loginToken)")

//
//                    addLog(">> try login token login with token", extra1: "login token : \(UserManager.shared.loginToken)")
                } else {
                    addLog(">> id, password login failed!!!")

                }
            }
        } else {
            addLog(">> try login with id, password")

            if let login = loginott(name: "\tloginott", loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) {
                processAutoLogin(login: login)
                
//                addLog(">> try login token login with token", extra1: "login token : \(UserManager.shared.loginToken)")
                
//                _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken)
                
                

            }
        }
        
        _ = getprofile(name: "getprofile")
        
        
        if let profile =
            profileCreate(name: "profileCreate(swnam2)", profileName: "swnam2", profilePic: imageSample)
        {
            _ = getprofile(name: "getprofile")
            let profileId = profile["profileId"].stringValue
            _ = profileDelete(name: "profileDelete", profileId: profileId)
        }
        
        _ = accountresetpassword(name: "accountresetpassword(4321)", loginPw: "4321")
        
//        _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "4321", loginToken: "")
    
        _ = accountresetpassword(name: "accountresetpassword(1234)", loginPw: "1234")
        
        if let otp = otp(name: "otp") {
            let otpNum = otp["otp"].stringValue
            _ = checkotp(name: "checkotp", otp: otpNum)
        }
        
//        _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "1234", loginToken: "")
        
        _ = checkpincode(name: "checkpincode")
        
        _ = changeinfo(name: "changeinfo", profileName: "swnam", profilePic: imageSample)
        
        
    }
}
