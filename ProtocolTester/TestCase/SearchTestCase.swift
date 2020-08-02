//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    
    func testSearch() {
        
        _ = totalSearch(name: "totalSearch", contentsType: "0x01", sortType: "0", searchPosition: "0", searchCount: "20", searchWord: "sport", sortFields: "broad_time", cate: nil, product_id: "2T01", adult_yn: "true", exposure_time: "24", won_yn: nil)
        
        _ = trendWord(name: "trendWord", productId: "2T01")
        
        let currentDate = Date.now
        let dateString = currentDate.toString(format: "YYYYMMDDHHmmSS")
        //        let rateFlag = Int(UserManager.shared.viewRestriction)! < 19 ? "N" : "Y"
        let rateFlag = "Y"
        
        _ = recomm(name: "recomm", CONTENT: "VOD", REC_TYPE: "ITEM_VOD", REC_GB_CODE: "M", PRODUCT_LIST: "2T01", REQ_DATE: dateString, CONS_ID: UserManager.shared.singleVodContentId, CAT_ID: "", CAT_TYPE: "", ITEM_CNT: "6", CONS_RATE: rateFlag)
        
        _ = curation(name: "curation",
                     CONTENT: "VOD",
                     REC_TYPE: "CURATION",
                     PRODUCT_LIST: "2T01",
                     REQ_DATE: "",
                     CONS_ID: "10000000000000015422",
                     MENU_MAX_CNT: 20,
                     MENU_MIN_CNT: 3,
                     ITEM_MAX_CNT: 20,
                     ITEM_MIN_CNT: 3,
                     CONS_RATE: "")
        
        _ = topcontent(name: "topcontent",
                       CONTENT: "VOD", REC_TYPE: "TOP_MOVIE", PRODUCT_LIST: "2T01", REQ_DATE: dateString, REQ_CODE: UserManager.shared.deviceType, CONS_RATE: rateFlag)
        
    }
}
