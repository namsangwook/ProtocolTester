//
//  UserManager.swift
//  thaiOTT
//
//  Created by MB-0017 on 2020/05/07.
//  Copyright © 2020 MB-0017. All rights reserved.
//

import Foundation

class UserManager {
    
    enum Key: String {
        case smartDownload = "KeySmartDownload"
        case searchKeywords = "RecentlySearchKeywords"
        case lang = "appLang"
        case loginToken = "loginToken"
        case lastCategoryVersion = "LastCategoryVersion"
        case selectedCellularDataUsage = "KeySelectedCellularDataUsage"
        case closedCaptionState = "KeyClosedCaptionState"
        case subTitleState = "KeySubTitleState"
        case seriesAutoplayState = "KeySeriesAutoplayState"
        case selectedBroadcastingLanguage = "KeySelectedBroadcastingLanguage"
        case selectedFontSize = "KeySelectedFontSize"
        case downloadWifiOnly = "KeyDownloadWifiOnly"
        case downloadSmartDownload = "KeyDownloadSmartDownload"
        case downloadVideoQuality = "KeyDownloadVideoQuality"
        case languageSelectedIndex = "KeyLanguageSelectedIndex"
    }
    
    static public let shared = UserManager()
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var languageCode: String
    var SAID: String = "INVALID"
    var profileId: String = "INVALID"
    let deviceType: String = "OTA"
    let deviceToken: String = "3808FA81-DDAF-4925-96CE-33AD912C29EE"
    var loginToken: String {
        get {
            string(forkey: Key.loginToken) ?? ""
        }
        set {
//            let newValue = newValue.replacingOccurrences(of: "/", with: "%2F")
            set(value: newValue, forkey: Key.loginToken)
            
        }
    }
    var loginId: String = "test830"
    var loginPw: String = "1234"

    var categoryVersion: String = "0"
    var overallCategoryId: String = ""
    var newReleaseCategoryId: String = ""
    var singleVodContentId: String = ""
    var seriesVodContentId: String = ""
    var viewRestriction: String = ""

    private init() {
        if let localeID = Locale.preferredLanguages.first, let deviceLocale = (Locale(identifier: localeID).languageCode),
            deviceLocale == "th" {
            languageCode = "TH"
        } else {
            languageCode = "EN"
        }
    }
    
    public func set(value: String?, forkey: Key) {
        UserDefaults.standard.set(value, forKey: forkey.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    public func string(forkey: Key) -> String? {
        return UserDefaults.standard.string(forKey: forkey.rawValue)
    }
    
}

