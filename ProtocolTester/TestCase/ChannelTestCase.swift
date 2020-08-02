//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

extension TestMainViewController {
    
    func testChannel() {
        
        
        guard let channel = channellist(name: "channellist") else {
            return
        }
        guard let channelList = channel["channelList"].array else {
            return
        }
        let channelId = channelList[0]["serviceId"].stringValue
        _ = epg(name: "epg", channelId: channelId)
        channelList.forEach { (channel) in
            if channel["serviceId"].stringValue == "265" {
                _ = nodeip(name: "nodeip(\(channel["serviceName"].stringValue))",
                    contentType: "channel",
                    contentPath: channel["unicastUrl"].stringValue,
                    movieId: channel["serviceId"].stringValue,
                    payYn: true,
                    resumeYn: false)
            }
        }
        
        
        _ = popularchannel(name: "popularchannel")
        
        if let favorite = favoritechannel(name: "favoritechannel") {
            if let favoriteList = favorite["channelId"].array {
                if favoriteList.count > 0 {
                    let channelId = favoriteList[0].stringValue
                    _ = channelproductinfo(name: "channelproductinfo", channelId: channelId)
                }
            }
        }
        
    }
}
