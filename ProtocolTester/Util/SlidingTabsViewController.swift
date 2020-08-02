//
//  SlidingTabsViewController.swift
//  SlidingTabs
//
//  Created by swnam on 2020/06/19.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit
import SnapKit

class SlidingTabsViewController: UIViewController{
    
    @IBOutlet weak var gradientViewLeadingConstraint: NSLayoutConstraint!
    var selectedTabs:Int = 0
    
    @IBOutlet weak var gradientViewWidthConstraint: NSLayoutConstraint!
    var pages: [UIViewController] = []
    lazy var titles: [String] = {
        pages.map {
            $0.title ?? ""
        }
    }()
    
    lazy var tabWidth: CGFloat = {
        getMaxTitleWidth()
    }()
    
    var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageController)
        view.addSubview(pageController.view)
        
        pageController.view.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(collectionView.snp.bottom)
        }
        pageController.view.backgroundColor = .cyan
//        pageController.view.frame = CGRect(x: 0, y: tapMenuHeight, width: view.frame.width, height: view.frame.height-tapMenuHeight)
        pageController.didMove(toParent: self)
        pageController.delegate = self
        pageController.dataSource = self

        pages.forEach { (vc) in
            pageController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }
        pageController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)

        if let scrollView = pageController.view.subviews.compactMap({ $0 as? UIScrollView }).first {
            scrollView.delegate = self
        }
        
        
        
        
        func getTitleWidth(index: Int) -> CGFloat {
            let rect = labelSizeWithString(text: titles[index], fontSize: 17, maxWidth: 1024, numberOfLines: 1)
            return rect.width + 50
        }
        
        
        gradientViewWidthConstraint.constant = tabWidth
  
        
    }
    
    
    
    func getMaxTitleWidth() -> CGFloat {
        let divideWidth: CGFloat = view.frame.size.width / CGFloat(titles.count)
        var maxTitleWidth:CGFloat = 0
        titles.forEach {
            let rect = labelSizeWithString(text: $0, fontSize: 17, maxWidth: 1024, numberOfLines: 1)
            if rect.width > maxTitleWidth {
                maxTitleWidth = rect.width
            }
            
        }
        if divideWidth > maxTitleWidth {
            return divideWidth
        } else {
            return maxTitleWidth + 15
        }
    }
    
    static var instance: SlidingTabsViewController {
        UIStoryboard(name: "SlidingTabs", bundle: nil).instantiateViewController(withIdentifier: "SlidingTabsViewController") as! SlidingTabsViewController
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

extension SlidingTabsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevTabs = selectedTabs
        selectedTabs = indexPath.row
        collectionView.visibleCells.forEach {
            if let cell = $0 as? SlidingTabsCell {
                if cell == collectionView.cellForItem(at: IndexPath(row: selectedTabs, section: 0)) {
                    cell.label.textColor = .white
                } else {
                    cell.label.textColor = .lightGray
                }
            }
        }

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        pageController.setViewControllers([pages[selectedTabs]],
                                          direction: selectedTabs > prevTabs ? .forward : .reverse,
                                          animated: true,
                                          completion: nil)
        
        let totalOffset:CGFloat = CGFloat(selectedTabs) * tabWidth
        gradientViewLeadingConstraint.constant = totalOffset - collectionView.contentOffset.x
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidingTabsCell", for: indexPath) as! SlidingTabsCell
        cell.label.text = titles[indexPath.row]
        if indexPath.row == selectedTabs {
            cell.label.textColor = .white
        } else {
            cell.label.textColor = .lightGray
        }
        
//        print("selected: \(cell.isSelected)")
        return cell
    }
}

extension SlidingTabsViewController {
    func labelSizeWithString(text: String,fontSize: CGFloat, maxWidth : CGFloat,numberOfLines: Int) -> CGSize{
        
        let font = UIFont.systemFont(ofSize: fontSize)//(name: "HelveticaNeue", size: fontSize)!
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numberOfLines
        label.font = font
        label.text = text
        
        return label.intrinsicContentSize
        //    label.sizeToFit()
        //
        //    return label.frame
    }
    
    func getTitleWidth(index: Int) -> CGFloat {
        let rect = labelSizeWithString(text: titles[index], fontSize: 17, maxWidth: 1024, numberOfLines: 1)
        return rect.width + 50
    }
}

extension SlidingTabsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        
        
//        guard let cell =   collectionView.cellForItem(at: indexPath) as? SlidingTabsCell else {
//            return CGSize(width:100, height: collectionView.frame.size.height)
//
//        }
//        cell.label.sizeToFit()
        
        return CGSize(width:tabWidth, height: collectionView.frame.size.height)
        
    }
    
  
    

}

extension SlidingTabsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // Swiping left
    public func pageViewController(_: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Get current view controller index
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        // Making sure the index doesn't get bigger than the array of view controllers
        guard previousIndex >= 0, pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    // Swiping right
    public func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Get current view controller index
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        // Making sure the index doesn't get bigger than the array of view controllers
        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("compeleted: \(completed)")
        guard completed else {
            return
        }
        if let currentVC = pageViewController.viewControllers?.first {
            pages.enumerated().forEach {
                if $1 == currentVC {
                    selectedTabs = $0
//                    print("selected tabs: \(selectedTabs)")
                    return
                }
            }
            
            collectionView.selectItem(at: IndexPath(row: selectedTabs, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//            collectionView.visibleCells.forEach {
//                if $0 == collectionView.cellForItem(at: IndexPath(row: selectedTabs, section: 0)) {
//                    $0.backgroundColor = .red
//                } else {
//                    $0.backgroundColor = .clear
//                }
//            }
//            var totalOffset:CGFloat = 0.0
//            for ii in 0..<selectedTabs {
//                totalOffset += getTitleWidth(index: ii)
//            }
            let totalOffset:CGFloat = CGFloat(selectedTabs) * tabWidth
            
//            let tabsOffset = CGFloat(selectedTabs) * 100
//            collectionView.setContentOffset(CGPoint(x: tabsOffset, y: 0), animated: false)
            gradientViewLeadingConstraint.constant = totalOffset - collectionView.contentOffset.x
//            gradientViewWidthConstraint.constant = getTitleWidth(index: selectedTabs)

        }
        
        
        
    }
}

extension SlidingTabsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalOffset:CGFloat = CGFloat(selectedTabs) * tabWidth
        
        
        if scrollView == collectionView {
            let tabsOffset = totalOffset - scrollView.contentOffset.x
            //            collectionView.setContentOffset(CGPoint(x: tabsOffset, y: 0), animated: false)
            gradientViewLeadingConstraint.constant = tabsOffset

            return
        }
        
        if !scrollView.isDragging {
            return
        }
        let offset = scrollView.contentOffset.x - view.frame.width
//        print(offset)
//        if offset == 0 {
//            return
//        }
        var candidateTabs = selectedTabs
        if offset > scrollView.frame.size.width / 2 {
            candidateTabs = selectedTabs + 1
        }
        if offset < -scrollView.frame.size.width / 2 {
            candidateTabs = selectedTabs - 1
        }
        collectionView.visibleCells.forEach {
            if let cell = $0 as? SlidingTabsCell {
                if cell == collectionView.cellForItem(at: IndexPath(row: candidateTabs, section: 0)) {
                    cell.label.textColor = .white
                } else {
                    cell.label.textColor = .lightGray
                }
            }
        }
        
        
        let tabsOffset = totalOffset + offset * tabWidth / scrollView.frame.size.width
//        if offset == scrollView.frame.size.width {
//            selectedTabs += 1
//        } else if offset == -scrollView.frame.size.width {
//            selectedTabs -= 1
//        }

        gradientViewLeadingConstraint.constant = tabsOffset - collectionView.contentOffset.x
//        collectionView.setContentOffset(CGPoint(x: tabsOffset, y: 0), animated: false)
    }
}
