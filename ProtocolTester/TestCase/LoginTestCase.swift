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
        
        if let data = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: UserManager.shared.loginPw) {
            UserManager.shared.loginToken = data["loginToken"].stringValue
            UserManager.shared.SAID = data["said"].stringValue
            UserManager.shared.profileId = data["profile"][0]["profileId"].stringValue
            _ = getprofile(name: "getprofile")
            
            if let profileLogin = profilelogin(name: "profilelogin", profileId: UserManager.shared.profileId) {
                UserManager.shared.loginToken = profileLogin["loginToken"].stringValue
                
                
                _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: UserManager.shared.loginToken)
                
                //                _ = profilelogin(name: "profilelogin", profileId: UserManager.shared.profileId)
                
                //                _ = loginott(name: "loginott(token)", loginId: "", loginPw: "", loginToken: "Tssdf/sdlkfsdlsdf/")
                
            }
            
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
            
            _ = loginott(name: "loginott", loginId: UserManager.shared.loginId, loginPw: "1234", loginToken: "")
            
            _ = checkpincode(name: "checkpincode")
            
            _ = changeinfo(name: "changeinfo", profileName: "swnam", profilePic: imageSample)
        }
    }
}
