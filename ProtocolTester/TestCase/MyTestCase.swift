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
            if purchaseRes["list"].arrayValue.count > 0 {
                let offerId = purchaseRes["list"][0]["offerId"].stringValue
                //            _ = purchaselisthidden(name: "purchaselisthidden", offerId: [offerId])
            }
        }
        
        if let collectionRes = collectionlist(name: "collectionlist") {
            let collectionList = collectionRes.arrayValue
            if collectionList.count > 0 {
                let offerId = collectionList[0]["offerId"].stringValue
                //            let offerId = "1000"
                //            _ = collectionlisthidden(name: "collectionlisthidden", offerIdList: [offerId])
            }
        }
        
        _ = retrieveowncouponlist(name: "retrieveowncouponlist")
        
        if let coupons = retrieveproductcouponlist(name: "retrieveproductcouponlist") {
            let coupons = coupons["result"].arrayValue
            coupons.enumerated().forEach { (index, coupon) in
                if index == 0 {
                    addLog(">>> try to purchase coupon(\(coupon["cpnNm"]))")
                    _ = paymentmethod(name: "\tpaymentmethod(\(coupon["cpnNm"]))", contentType: "coupon", offerId: coupon["cpnTypeId"].stringValue)
                    
                    _ = purchasecoupon(name: "\tpurchasecoupon", cpnTypeId: coupon["cpnTypeId"].stringValue, totalPrice: coupon["saleAmt"].stringValue, paymentMethod: "04")
                }
            }
        }
        
        

        addLog(">>> try to coupon register(01035-341-5051-001)")
        _ = requestpromotioncouponnumberregister(name: "\trequestpromotioncouponnumberregister", couponNumber: "01035-203-0639-001")
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
