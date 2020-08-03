//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit
import SwiftyJSON

extension TestMainViewController {
    
    func testNewRelease() {
        
        guard let new = contentlist(name: "contentlist(new release)", categoryId: UserManager.shared.newReleaseCategoryId) else {
            return
        }
        
        guard let contentList = new["contentList"].array else {
            return
        }
        
        _ = vodlikePost(name: "vodlike(\( contentList[0]["contentGroupId"]))", contentId: contentList[0]["contentGroupId"].stringValue)
        
        _ = vodlikeDelete(name: "vodlike(\( contentList[0]["contentGroupId"]))", contentId: contentList[0]["contentGroupId"].stringValue)
        
        var packageProduct: JSON?
        
        contentList.forEach { (content) in
            if content["isSeries"] == "N" {
                if let package = vodwithpackage(name: "vodwithpackage(\(content["title"].stringValue))", contentId: content["contentGroupId"].stringValue) {
                    let products = package["productList"].arrayValue
                    if packageProduct == nil {
                        products.forEach { (product) in
                            if product["productType"].stringValue == "package" {
                                packageProduct = product
                                _ = packagedetail(name: ">>> packagedetail(\(product["productName"]))", offerId: product["offerId"].stringValue)
                            }
                        }
                    }
                }
            } else {
                let series = serieslist(name: "serieslist(\(content["title"].stringValue))", seriesId: content["seriesAssetId"].stringValue)
                if let seriesList = series?["list"].array {
                    seriesList.forEach { (content) in
                        _ = vodwithpackage(name: "  series-vodwithpackage(\(content["seriesName"].stringValue)(\(content["episodeId"].stringValue))",
                            contentId: content["contentGroupId"].stringValue)
                    }
                }
            }
        }
        

        
        _ = seasonlist(name: "seasonlist", seriesId: UserManager.shared.seriesVodContentId)
        
    }
}
