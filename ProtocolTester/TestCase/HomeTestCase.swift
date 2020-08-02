//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    
    func testHome() {
        
        guard let data = categoryversioncheck(name: "categoryversioncheck") else {
            return
        }
        
        let rootCategoryId = data["rootCategoryId"].stringValue
        UserManager.shared.categoryVersion = data["version"].stringValue
        
        guard let categoryRoot = category(name: "category(root)", categoryId: rootCategoryId) else {
            return
        }
        
        let homeCategoryId = categoryRoot[0]["categoryId"].stringValue
        
        
        guard let categoryHome = category(name: "category(home)", categoryId: homeCategoryId) else {
            return
        }
        
        
        let overallCategoryId = categoryHome[0]["categoryId"].stringValue
        UserManager.shared.overallCategoryId = overallCategoryId
        
        
        if let topList = categoryHome.array {
            topList.forEach { (top) in
                _ = category(name: "category(\(top["categoryName"].stringValue))", categoryId: top["categoryId"].stringValue)
            }
        }
    }
}
