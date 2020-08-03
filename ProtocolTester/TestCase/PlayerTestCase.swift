//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    func testPlayer() {
        if let package = vodwithpackage(name: "vodwithpackage", contentId: UserManager.shared.singleVodContentId) {
            let videoUrl = package["streaminfo"]["main"]["videoUrl"].stringValue
            _ = nodeip(name: "nodeip",
                       contentType: "VOD",
                       contentPath: videoUrl,
                       movieId: package["movieAssetId"].stringValue,
                       payYn: true,
                       resumeYn: false)
            
        }
    }
}
