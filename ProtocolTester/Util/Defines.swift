//
//  Defines.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/27.
//  Copyright © 2020 dki. All rights reserved.
//

import Foundation

class Defines {
    enum ServerInfo {
        case tb
        case staging
        case live
    }
    static let serverInfo: ServerInfo = .staging
    
    static var baseUrl: String {
        switch serverInfo {
        case .tb:
            return "http://222.122.207.37/service"
        case .staging:
            return "http://mbs-ex.3bbtv.com/service"
        case .live:
            return "http://mbs-ex.3bbtv.com/service"
        }
    }
    
    static var recommendUrl: String {
        switch serverInfo {
        case .tb:
            return "http://222.122.207.46:8080/rec"
        case .staging:
            return "http://iptv.recommendrec.3bbtv.com:8080/rec"
        case .live:
            return "http://iptv.recommendrec.3bbtv.com:8080/rec"
        }

    }
    
    static var searchUrl: String {
        switch serverInfo {
        case .tb:
            return "http://222.122.207.44:8080/ser"
        case .staging:
            return "http://iptv.totalser.3bbtv.com:8080/ser"
        case .live:
            return "http://iptv.totalser.3bbtv.com:8080/ser"
        }

    }
    
    static var loginId: String {
        switch serverInfo {
        case .tb:
            return "test830"
        case .staging:
            return "dki02@gmail.com"
        case .live:
            return "dki02@gmail.com"
        }
    }
    
    static var loginPw: String  {
        switch serverInfo {
        case .tb:
            return "1234"
        case .staging:
            return "1234"
        case .live:
            return "1234"
        }
    }
    
    static var credential: String {
        switch serverInfo {
        case .tb:
            return "OTA:ota_system"
        case .staging:
            return "OTA:64c1aaa37a" // "OTI:25d7f0af67"
        case .live:
            return "OTA:c8ec3dcfbf"
        }
    }

    
//    static let baseUrl = "http://222.122.207.37/service" // TB
////    static let baseUrl = "http://59.15.95.42:4090/service" // INNERWAVE
//    static let recommendUrl = "http://222.122.207.46:8080/rec"    // TB
//    static let searchUrl = "http://222.122.207.44:8080/ser"       // TB
//    static let loginId = "test830"
//    static let loginPw = "1234"
//    static let credential = "OTA:ota_system"

    
////    static let baseUrl = "http://10.4.1.70:8888/service"                  // Staging
//    static let baseUrl = "http://mbs-ex.3bbtv.com/service"                  // Live
//    static let recommendUrl = "http://iptv.recommendrec.3bbtv.com:8080/rec" // Staging
//    static let searchUrl = "http://iptv.totalser.3bbtv.com:8080/ser"        // Staging
//    static let loginId = "dki01@gmail.com"
//    static let loginPw = "1234"
//    static let credential = "OTA:64c1aaa37a"
////    static let credential = "OTI:25d7f0af67"
    
    
    
//    static let baseUrl = "http://mbs-ex.3bbtv.com/service"                  // Live
//    static let recommendUrl = "http://iptv.recommendrec.3bbtv.com:8080/rec" // Live
//    static let searchUrl = "http://iptv.totalser.3bbtv.com:8080/ser"        // Live
//    static let loginId = "dki01@gmail.com"
//    static let loginPw = "1234"
//    static let credential = "OTA:c8ec3dcfbf"

    
//    http://222.122.207.35:8110/LIC_REQ_CC // TB
    static let laUrl = " https://iptv.license.3bbtv.com/LIC_REQ_CC?ContentID=265&ServiceType=1&LoginToken=DPw0DEJsdzeECCJav44D1o2zzpCeo5ps3PZLUFYqeEdo6uoVCVZ95TOSnKnA5&ProfileID=TV80008035000&OTU=3231&DownloadYN=N&deviceType=OTA"
    
    
    
     
//    02
//    ID : dki02@gmail.com
//    PW : 1234
//
//    03
//    ID : dki03@gmail.com
//    PW : 1234
//
//    04
//    ID : dki04@gmail.com
//    PW : 1234
//
//    05
//    ID : dki05@gmail.com
//    PW : 1234
}
