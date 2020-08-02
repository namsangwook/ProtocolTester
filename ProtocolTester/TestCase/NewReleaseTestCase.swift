//
//  LoginTestCase.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/31.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

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
        
        contentList.forEach { (content) in
            if content["isSeries"] == "N" {
                if let package = vodwithpackage(name: "vodwithpackage(\(content["title"].stringValue))", contentId: content["contentGroupId"].stringValue) {
                    //                    _ = nodeip(name: "nodeip",
                    //                               contentType: "VOD",
                    //                               contentPath: package["streaminfo"]["main"]["videoUrl"].stringValue,
                    //                               movieId: package["movieAssetId"].stringValue,
                    //                               payYn: true,
                    //                               resumeYn: false)
                }
                
                
                //                "contentGroupId":"88",
                //                    "movieAssetId":"97",
                //                    "releaseDate":"14.07.2020",
                //                    "isLike":"N",
                //                    "resumeTime":0,
                //
                //
                //                "streaminfo":{
                //                "main":{
                //                   "containerType":"jpg",
                //                   "duration":null,
                //                   "freePreviewStartPosition":"00:00:01",
                //                   "skipIntroStartPosition":"00:00:01",
                //                   "videoUrl":"/3bb/movie/97/97.mpd",
                //                   "thumbnailFolder":"http://222.122.207.71:18080/movie/97/thumbnail/",
                //                   "thumbnailFileName":"http://222.122.207.71:18080/poster/125/125",
                //                   "skipIntroEndPosition":"00:00:30",
                //                   "webvttFileName":"97"
                //                },
                
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
        
    }
}
