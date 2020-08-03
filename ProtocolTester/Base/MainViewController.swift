//
//  MainViewController.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/27.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainTabs: UIView!
    
    @IBOutlet weak var testAllBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "myQueue", qos: .background)
    
    var vcs: [BaseViewController] = []

    
    @IBAction func testAllBtnClicked(_ sender: Any) {
        BaseViewController.totalTestCase = 0
        BaseViewController.passTestCase = 0

        dispatchQueue.async {
            DispatchQueue.main.async {
                self.testAllBtn.isEnabled = false
                self.indicator.isHidden = false
                self.indicator.startAnimating()
            }

            self.vcs.forEach { (vc) in
                vc.testInit()
                DispatchQueue.main.async {
                    self.resultLabel.text = "Total: \(BaseViewController.totalTestCase), Pass: \(BaseViewController.passTestCase), Fail: \(BaseViewController.totalTestCase - BaseViewController.passTestCase)"
                }
                vc.test()
                DispatchQueue.main.async {
                    self.resultLabel.text = "Total: \(BaseViewController.totalTestCase), Pass: \(BaseViewController.passTestCase), Fail: \(BaseViewController.totalTestCase - BaseViewController.passTestCase)"
                }
                return
            }
            
            DispatchQueue.main.async {
                self.testAllBtn.isEnabled = true
                self.indicator.stopAnimating()
                self.indicator.isHidden = true

            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultLabel.text = ""
        self.indicator.isHidden = true
        testAllBtn.layer.borderWidth = 1
        testAllBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        testAllBtn.layer.cornerRadius = testAllBtn.frame.size.height / 4
        testAllBtn.layer.masksToBounds = true

        self.title = "Protocol Test"
        self.navigationController?.navigationBar.isHidden = true

        var vc: TestMainViewController = TestMainViewController.instance
        vc.title = "Login"
        vc.type = .Login
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Home"
        vc.type = .Home
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Overall"
        vc.type = .Overall
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "New Release"
        vc.type = .NewRelease
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Channel"
        vc.type = .Channel
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Search"
        vc.type = .Search
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Player"
        vc.type = .Player
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "My"
        vc.type = .My
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Setting"
        vc.type = .Setting
        vcs.append(vc)

        vc = TestMainViewController.instance
        vc.title = "Purchase"
        vc.type = .Purchase
        vcs.append(vc)

        // Do any additional setup after loading the view.
        let tabs = SlidingTabsViewController.instance
        tabs.pages = vcs
        mainTabs.addSubview(tabs.view)
        self.addChild(tabs)
        tabs.didMove(toParent: self)
        tabs.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
