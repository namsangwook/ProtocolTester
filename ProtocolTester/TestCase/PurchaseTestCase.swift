//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    func testPurchase() {
        guard let new = contentlist(name: "contentlist(new release)", categoryId: UserManager.shared.newReleaseCategoryId) else {
            return
        }
        
        let contentList = new["contentList"].arrayValue
        
        if let singleContent = contentList.first(where: {$0["isSeries"].stringValue == "N"}) {
            if let vodInfo = vodwithpackage(name: "vodwithpackage", contentId: singleContent["contentGroupId"].stringValue) {
                let productList = vodInfo["productList"].arrayValue
                if let product = productList.first(where: {$0["isPurchased"].stringValue == "N"}) {
                    _ = paymentmethod(name: "paymentmethod(\(product["productName"]))", contentType: "vod", offerId: product["offerId"].stringValue)
                    
                }
            }
            
        }
    }
}
