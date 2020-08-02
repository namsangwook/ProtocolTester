//
//  GradientView.swift
//  thaiOTT
//
//  Created by MB-0017 on 2020/05/19.
//  Copyright © 2020 MB-0017. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initGradient()
    }

    var startColor: UIColor = UIColor.gradientStart {
        didSet {
            updateColors()
        }
    }
    
    var centerColor: UIColor = UIColor.gradientCenter {
        didSet {
            updateColors()
        }
    }
    
    var endColor: UIColor = UIColor.gradientEnd {
        didSet {
            updateColors()
        }
    }
    
    var colorRatio: Float = 0.7 {
        didSet {
            assert(colorRatio >= 0 || colorRatio <= 1, "Color Ratio: Valid range is from 0.0 to 1.0")
            updateLocation()
        }
    }
    
    private func initGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        updateColors()
        updateLocation()
    }

    private func updateColors() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [startColor.cgColor, centerColor.cgColor, endColor.cgColor]
    }
    
    private func updateLocation() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: colorRatio), NSNumber(value: 1)]
    }
        
}
