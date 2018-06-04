//
//  SideMenuBarView.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-31.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

/*class SideMenuBarView : UIView {
    private var didSetupConstraints = false
    static var temperatureUnitControl = UISegmentedControl()
    static var windSpeedUnitControl = UISegmentedControl()
    
    override init(frame: CGRect) {
        print("segmentedcontrolcalled")
        super.init(frame: frame)
        setupView()
        setStyle()
        layoutView()
        setupSegmentedView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
}


// MARK: Setup View
private extension SideMenuBarView {
     func setupView(){
        addSubview(SideMenuBarView.temperatureUnitControl)
        addSubview(SideMenuBarView.windSpeedUnitControl)
     }
}

// MARK: Layout
private extension SideMenuBarView {
    func layoutView(){
        constrain(SideMenuBarView.temperatureUnitControl) {
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left + 5
            $0.width == 120
            $0.height == 40
        }
        constrain(SideMenuBarView.windSpeedUnitControl, SideMenuBarView.temperatureUnitControl ) {
            $0.top == $1.bottom + 2
            $0.left == $1.left
            $0.right == $1.right
            $0.height == 40
         
        }
    }
}

private extension SideMenuBarView {
    func setStyle() {
        SideMenuBarView.temperatureUnitControl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        SideMenuBarView.temperatureUnitControl.layer.cornerRadius = 5.0
        SideMenuBarView.temperatureUnitControl.tintColor = UIColor.white
        SideMenuBarView.temperatureUnitControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], for: .normal)
        SideMenuBarView.temperatureUnitControl.sizeToFit()
    
        SideMenuBarView.windSpeedUnitControl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        SideMenuBarView.windSpeedUnitControl.layer.cornerRadius = 5.0
        SideMenuBarView.windSpeedUnitControl.tintColor = UIColor.white
        SideMenuBarView.windSpeedUnitControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], for: .normal)
        SideMenuBarView.windSpeedUnitControl.sizeToFit()
    }
}
    
    
    
private extension SideMenuBarView {
    func setupSegmentedView() {
       setupSegmentedControl()
    }
    func setupSegmentedControl() {
   // Configure Segmented Control
        SideMenuBarView.temperatureUnitControl.removeAllSegments()
        SideMenuBarView.windSpeedUnitControl.removeAllSegments()
        SideMenuBarView.temperatureUnitControl.insertSegment(withTitle: "°F", at: 0, animated: false)
        SideMenuBarView.temperatureUnitControl.insertSegment(withTitle: "°C", at: 1, animated: false)
        SideMenuBarView.windSpeedUnitControl.insertSegment(withTitle: "mph", at: 0, animated: false)
        SideMenuBarView.windSpeedUnitControl.insertSegment(withTitle: "km/h", at: 1, animated: false)
        
        SideMenuBarView.temperatureUnitControl.selectedSegmentIndex = 0
        SideMenuBarView.windSpeedUnitControl.selectedSegmentIndex = 0
   }
}*/
