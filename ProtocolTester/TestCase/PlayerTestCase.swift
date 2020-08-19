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
        
        if UserManager.shared.singleVodContentId.count > 0 {
            
//            _ = createResumeTime(name: "createResumeTime", contentId: UserManager.shared.singleVodContentId, resumeTime: "10")
            
            let startTime = Int(NSDate().timeIntervalSince1970)
            let resumeTime = 20 * 1000
            let endTime = startTime + 5 * 60 * 1000
            _ = updateResumeTime(name: "updateResumeTime",
                                 contentId: UserManager.shared.singleVodContentId,
                                 resumeTime: String(resumeTime), startTime: String(startTime), endTime: String(endTime))
            
            _ = resumetime(name: "resumeTime", contentId: UserManager.shared.singleVodContentId)
            
        }

    }
}
