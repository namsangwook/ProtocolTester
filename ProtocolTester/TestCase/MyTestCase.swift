//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    
    func testMy() {
        
        
        _ = retrieveowncouponhomeinfo(name: "retrieveowncouponhomeinfo", includeCoupons: true)
        if let data = vodlikeGet(name: "vodlike") {
            if let vodList = data["contentList"].array {
                if vodList.count > 0 {
                    _ = vodlikeDelete(name: "vodlike(\(vodList[0]["contentGroupId"]))", contentId: vodList[0]["contentGroupId"].stringValue)
                }
            }
        }
        
        if let purchaseRes = purchaselist(name: "purchaselist") {
            _ = purchaselisthidden(name: "purchaselisthidden", offerId: ["OF20001"])
        }
        
        if let collectionRes = collectionlist(name: "collectionlist") {
            if let collectionList = collectionRes.array {
                if collectionList.count > 0 {
                    _ = collectionlisthidden(name: "collectionlisthidden", offerId: "OF20001")
                }
            }
        }
        
        _ = retrieveowncouponlist(name: "retrieveowncouponlist")
        _ = retrieveproductcouponlist(name: "retrieveproductcouponlist")
//        _ = requestpromotioncouponnumberregister(name: "requestpromotioncouponnumberregister")
//        _ = purchasecoupon(name: "purchasecoupon")
        
        if let subscriptionRes = subscriptionlist(name: "subscriptionlist") {
            if let subscriptionList = subscriptionRes["list"].array {
                _ = stopsubscription(name: "stopsubscription")
            }
        }
        
        
        _ = messagelist(name: "messagelist")
        
        _ = smartdownload(name: "smartdownload")
        
    }
}
