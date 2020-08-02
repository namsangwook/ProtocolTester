//
//  UserManager.swift
//  thaiOTT
//
//  Created by MB-0017 on 2020/05/07.
//  Copyright © 2020 MB-0017. All rights reserved.
//

import Foundation

class UserManager {
    
    static public let shared = UserManager()
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var languageCode: String
    var SAID: String = "INVALID"
    var profileId: String = "INVALID"
    let deviceType: String = "OTA"
    let deviceToken: String = "4808FA81-DDAF-4925-96CE-33AD912C29FF"
    var loginToken: String = ""
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
}

