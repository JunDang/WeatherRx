//
//  CurrentWeatherView.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-06.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class CurrentWeatherView: UIView {
    private var didSetupConstraints = false
    private let currentTempLbl = UILabel()
    private let highTempLbl = UILabel()
    private let lowTempLbl = UILabel()
    private let feelsLikeTempLbl = UILabel()
    private let iconImage = UIImageView()
    private let weatherLbl = UILabel()
    private let minutelySummaryLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setStyle()
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
private extension CurrentWeatherView{
    func setupView(){
        addSubview(currentTempLbl)
        addSubview(highTempLbl)
        addSubview(lowTempLbl)
        addSubview(feelsLikeTempLbl)
        addSubview(iconImage)
        addSubview(weatherLbl)
        addSubview(minutelySummaryLbl)
    }
}

// MARK: Layout
private extension CurrentWeatherView{
    func layoutView(){
        constrain(self) {
            $0.height == 180.0
        }
        constrain(iconImage) {
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left + 10
            $0.width == 78
            $0.height == 60
        }
        constrain(weatherLbl, iconImage) {
            $0.top == $1.top
            $0.left == $1.right + 10
            $0.height == $1.height
        }
        constrain(currentTempLbl, iconImage) {
            $0.top == $1.bottom
            $0.left == $1.left
        }
        constrain(feelsLikeTempLbl, currentTempLbl) {
            $0.top == $1.bottom
            $0.left == $1.left
        }
        constrain(minutelySummaryLbl, feelsLikeTempLbl) {
            $0.top == $1.bottom
            $0.left == $1.left
            
        }
        constrain(lowTempLbl, minutelySummaryLbl) {
            $0.top == $1.bottom
            $0.left == $1.left
        }
        constrain(highTempLbl, lowTempLbl) {
            $0.top == $1.top
            $0.left == $1.right + 10
            $0.height == $1.height
        }
   }
}

// MARK: Style
private extension CurrentWeatherView{
    func setStyle(){
        self.backgroundColor = UIColor.clear
        
        weatherLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        weatherLbl.textColor = UIColor.white
        weatherLbl.sizeToFit()
        weatherLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        currentTempLbl.font = UIFont(name: "Helvetica Neue", size: 85)
        currentTempLbl.textColor = UIColor.white
        currentTempLbl.sizeToFit()
        
        feelsLikeTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        feelsLikeTempLbl.textColor = UIColor.white
        feelsLikeTempLbl.sizeToFit()
        
        minutelySummaryLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        minutelySummaryLbl.textColor = UIColor.white
        minutelySummaryLbl.sizeToFit()
        minutelySummaryLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        lowTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        lowTempLbl.textColor = UIColor.white
        lowTempLbl.sizeToFit()
        
        highTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        highTempLbl.textColor = UIColor.white
        highTempLbl.sizeToFit()
        
    }
}

// MARK: Render
extension CurrentWeatherView{
    func render(){
        weatherLbl.text = "Sunny"
        currentTempLbl.text = "15\u{00B0}"
        iconImage.image = UIImage(named: "sunny")
        feelsLikeTempLbl.text = "Feels like: 15\u{00B0}"
        minutelySummaryLbl.text = "sunny in the hour"
        lowTempLbl.text = "Low: 5\u{00B0}"
        highTempLbl.text = "High: 20\u{00B0}"
    }

}
