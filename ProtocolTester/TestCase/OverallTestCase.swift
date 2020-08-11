//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    
    func testOverall() {
        
        guard let overall = category(name: "category(overall)", categoryId: UserManager.shared.overallCategoryId) else {
            return
        }
        
        guard let contentList = overall.array else {
            return
        }
        
        
        contentList.forEach { (content) in
            if content["categoryName"].stringValue == "New Release" ||
               content["categoryName"].stringValue == "NEW RELEASE" {
                UserManager.shared.newReleaseCategoryId = content["categoryId"].stringValue
            }
            if content["linkType"] == "asset" {
                _ = contentlist(name: "contentlist(\(content["categoryName"].stringValue))", categoryId: content["categoryId"].stringValue)
            }
            else if content["linkType"] == "promoPosition" || content["linkType"] == "bannerPosition"
            {
                _ = bannerList(name: "bannerlist(\(content["categoryName"].stringValue))", bannerId: content["linkInfo"].stringValue)
            }
            else if content["linkType"] == "recentlyWatching" {
                _ = recentlyWatching(name: "recentwatchinglist(\(content["categoryName"].stringValue))")
            }
        }
        
    }
}
