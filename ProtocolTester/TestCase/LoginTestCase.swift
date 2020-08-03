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
    
    private func processAutoLogin(login: JSON) {
        let profiles = login["profile"].arrayValue
        profiles.forEach { (profile) in
            if profile["lastLoginYN"] == "Y" {
                if profile["lockYN"] == "N" {
                    UserManager.shared.loginToken = login["loginToken"].stringValue
                    UserManager.shared.SAID = login["said"].stringValue
                    UserManager.shared.profileId = profile["profileId"].stringValue
                    
                    addLog(">> result : \(profile["profileName"].stringValue) is not locked", extra1: "prifle Id : \(profile["profileId"].stringValue)", extra2: "token : \(login["loginToken"].stringValue)")
                    return
                } else {
                    addLog(">> result : \(profile["profileName"].stringValue) is locked, so profile login")
                    
                    if let profileLogin = profilelogin(name: "profilelogin", profileId: profile["profileId"].stringValue) {
                        UserManager.shared.loginToken = profileLogin["loginToken"].stringValue
                        UserManager.shared.SAID = profileLogin["said"].stringValue
                        UserManager.shared.profileId = profileLogin["profileId"].stringValue
                        return
                    }
                }
            }
        }
    }
    
    func testLogin() {
        
        if UserManager.shared.loginToken.count > 0 {
            addLog(">> try token login with token", extra1: "login token : \(UserManager.shared.loginToken)")

            if let login = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken) {
                processAutoLogin(login: login)
                addLog(">> save token", extra1: "login token : \(UserManager.shared.loginToken)")
            } else {
                addLog(">> token login failed with token", extra1: "login token : \(UserManager.shared.loginToken)")
                addLog(">> try id, password login")

                if let login = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) {
                    processAutoLogin(login: login)
                    addLog(">> save token", extra1: "login token : \(UserManager.shared.loginToken)")

//
//                    addLog(">> try login token login with token", extra1: "login token : \(UserManager.shared.loginToken)")
                } else {
                    addLog(">> id, password login failed!!!")

                }
            }
        } else {
            addLog(">> try token login with token", extra1: "login token : \(UserManager.shared.loginToken)")

            if let login = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) {
                processAutoLogin(login: login)
                
//                addLog(">> try login token login with token", extra1: "login token : \(UserManager.shared.loginToken)")
                
//                _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken)
                
                

            }
        }
        
        _ = getprofile(name: "getprofile")
        
        
        if let profile =
            profileCreate(name: "profileCreate", profileName: "swnam2", profilePic: imageSample)
        {
            let profileId = profile["profileId"].stringValue
            _ = profileDelete(name: "profileDelete", profileId: profileId)
        }
        
        _ = accountresetpassword(name: "accountresetpassword", loginPw: "4321")
        
//        _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "4321", loginToken: "")
        
        _ = accountresetpassword(name: "accountresetpassword", loginPw: "1234")
        
        if let otp = otp(name: "otp") {
            let otpNum = otp["otp"].stringValue
            _ = checkotp(name: "checkotp", otp: otpNum)
        }
        
//        _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "1234", loginToken: "")
        
        _ = checkpincode(name: "checkpincode")
        
        _ = changeinfo(name: "changeinfo", profileName: "swnam", profilePic: imageSample)
        
        
    }
}
