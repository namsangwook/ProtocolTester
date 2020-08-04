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
            let offerId = purchaseRes[0]["offerId"].stringValue
            _ = purchaselisthidden(name: "purchaselisthidden", offerId: ["OF20001"])
        }
        
        if let collectionRes = collectionlist(name: "collectionlist") {
            let collectionList = collectionRes.arrayValue
//            let offerId = collectionList[0]["offerId"].stringValue
            let offerId = "1000"
            _ = collectionlisthidden(name: "collectionlisthidden", offerIdList: [offerId])
        }
        
        _ = retrieveowncouponlist(name: "retrieveowncouponlist")
        if let coupons = retrieveproductcouponlist(name: "retrieveproductcouponlist") {
            let coupons = coupons["result"].arrayValue
            coupons.forEach { (coupon) in
                addLog(">>> try to purchase coupon(\(coupon["cpnNm"]))")
                _ = paymentmethod(name: "paymentmethod(\(coupon["cpnNm"]))", contentType: "coupon", offerId: coupon["cpnTypeId"].stringValue)
                
                _ = purchasecoupon(name: "purchasecoupon", cpnTypeId: coupon["cpnTypeId"].stringValue, totalPrice: coupon["saleAmt"].stringValue, paymentMethod: "04")
            }
        }
        
        

        addLog(">>> try to coupon register(010350304144001)")
        _ = requestpromotioncouponnumberregister(name: "requestpromotioncouponnumberregister")
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
