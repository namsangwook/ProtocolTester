//
//  OverallTestViewController.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/27.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import SwiftyJSON

enum TestType {
    case Login
    case Home
    case Overall
    case NewRelease
    case Channel
    case My
    case Search
    case Player
    case Setting
    case Purchase
}

class TestMainViewController: BaseViewController {
    
    let imageSample: String = "iVBORw0KGgoAAAANSUhEUgAAAIAAAABICAYAAAA+hf0SAAAAAXNSR0IArs4c6QAAQABJREFUeAF9ndmzZdd50L8zD39TYQ0f/cKQrhAcqDcxJGNKip6uFboyZM4f6eeHQQjOeqmeauMYS8f8D5iYUpqCRalwAAAAASUVORK5CYII="

    static var instance: TestMainViewController {
        UIStoryboard.init(name: "Tester", bundle: nil).instantiateViewController(withIdentifier: "TestMainViewController") as! TestMainViewController
    }
    
    var type: TestType = .Login
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func test() {

        switch type {
        case .Login:
            testLogin()
        case .Home:
            getBasicInfo()
            testHome()
        case .Overall:
            getBasicInfo()
            testOverall()
        case .NewRelease:
            getBasicInfo()
            testNewRelease()
        case .Channel:
            getBasicInfo()
            testChannel()
        case .My:
            getBasicInfo()
            testMy()
        case .Search:
            getBasicInfo()
            testSearch()
        case .Player:
            getBasicInfo()
            testPlayer()
        case .Setting:
            getBasicInfo()
            testSetting()
        case .Purchase:
            getBasicInfo()
            testPurchase()
        }
        
    }
    
    
}
