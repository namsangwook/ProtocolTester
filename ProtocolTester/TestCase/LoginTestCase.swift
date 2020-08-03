//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    

    func testLogin() {
        
        if let login = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) {
            
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
            
            addLog(">> try login token login with token", extra1: "login token : \(UserManager.shared.loginToken)")

            _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken)

            
            _ = getprofile(name: "getprofile")
            
//            if let profileLogin = profilelogin(name: "profilelogin", profileId: UserManager.shared.profileId) {
//                UserManager.shared.loginToken = profileLogin["loginToken"].stringValue
//
//
//                _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken)
//
//                //                _ = profilelogin(name: "profilelogin", profileId: UserManager.shared.profileId)
//
//                //                _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: "Tssdf/sdlkfsdlsdf/")
//
//            }
            
            //            Range(1...10).forEach { (index) in
            //                _ = profileDelete(name: "profileDelete", profileId: "TV8000803000\(index)")
            //            }
            
            //            if let profile = profileCreate(name: "profileCreate", profileName: "profile1", profilePic: imageSample) {
            //                let profileId = profile["profileId"].stringValue
            //                _ = profileDelete(name: "profileDelete", profileId: profileId)
            //            }
            
            
            //            _ = profilelogin(name: "profilelogin", lo)
            
            _ = accountresetpassword(name: "accountresetpassword", loginPw: "4321")
            
            _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "4321", loginToken: "")
            
            _ = accountresetpassword(name: "accountresetpassword", loginPw: "1234")
            
            if let otp = otp(name: "otp") {
                let otpNum = otp["otp"].stringValue
                _ = checkotp(name: "checkotp", otp: otpNum)
            }
            
            _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "1234", loginToken: "")
            
            _ = checkpincode(name: "checkpincode")
            
            _ = changeinfo(name: "changeinfo", profileName: "swnam", profilePic: imageSample)
        }
    }
}
