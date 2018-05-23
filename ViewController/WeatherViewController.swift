//
//  WeatherViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-03-07.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography
import FXBlurView
import RxSwift
import RxCocoa


class WeatherViewController: UIViewController {
  private let gradientView = UIView()
  private let overlayView = UIImageView()
  private let maskLayer = UIView()
  private let backgroundView = UIImageView()
  private let backScrollView = UIScrollView()
  private let frontScrollView = UIScrollView()
  private let currentWeatherView = CurrentWeatherView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
  private let weatherForecastTableView = WeatherForecastTableViewController().tableView
  private let segmentedControl = UISegmentedControl(frame: CGRect.zero)
  private let containerView = UIView(frame: CGRect.zero)
    
  private let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    layoutView()
    style()
    bindBackground()

  }
    //Lincoln: lat: 40.8136, lon: -96.7026
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
    
  func bindBackground() {
      let flickrViewModel: FlickrViewModel = FlickrViewModel(lat: 43.6532, lon: -79.3832, currentWeather: "sunny", apiType: FlickrService.self, imageDataCacheType: ImageDataCaching.self)
      flickrViewModel.backgroundImage.asDriver()
         .drive(onNext: { [weak self] backgroundImage in
          let resizedImage = backgroundImage?.scaled(CGSize(width: (self?.view.frame.width)!, height: (self?.view.frame.height)! * 1.5))
          self?.backgroundView.image = resizedImage
          self?.overlayView.image = resizedImage?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
          self?.overlayView.alpha = 0
        })
       .disposed(by: bag)
    }
    
  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentWeatherView.render()
    }
 }



private extension WeatherViewController{
    func setup(){
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        maskLayer.contentMode = .scaleAspectFill
        maskLayer.clipsToBounds = true
        backgroundView.addSubview(maskLayer)
        backScrollView.addSubview(backgroundView)
        backScrollView.contentSize = backgroundView.bounds.size
        backScrollView.delegate = self
        frontScrollView.contentMode = .scaleAspectFill
        frontScrollView.clipsToBounds = true
        frontScrollView.delegate = self
        frontScrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height * 2)
        frontScrollView.addSubview(currentWeatherView)
        frontScrollView.addSubview(weatherForecastTableView)
        frontScrollView.addSubview(segmentedControl)
        frontScrollView.addSubview(containerView)
        overlayView.contentMode = .scaleAspectFill
        overlayView.clipsToBounds = true
        view.addSubview(overlayView)
        view.addSubview(gradientView)
        backScrollView.showsVerticalScrollIndicator = false
        backScrollView.isDirectionalLockEnabled = true
        frontScrollView.showsVerticalScrollIndicator = false
        view.addSubview(backScrollView)
        view.addSubview(frontScrollView)
    }
}

// MARK: Layout
extension WeatherViewController{
    func layoutView() {
        constrain(backgroundView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(overlayView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(gradientView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(maskLayer) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(backScrollView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(frontScrollView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(currentWeatherView) { view in
            view.width == view.superview!.width
            view.centerX == view.superview!.centerX
            //view.centerY == view.superview!.centerY + self.view.frame.height/2
            view.bottom == view.superview!.top + self.view.frame.height - 120
        }
       /* constrain(weatherForecastTableView,currentWeatherView) {
            $0.width == $0.superview!.width
            $0.centerY == $0.superview!.centerY
            $0.top == $1.bottom + 5
        }*/
        constrain(segmentedControl,currentWeatherView) {
            $0.width == $0.superview!.width
            $0.centerY == $0.superview!.centerY
            $0.top == $1.bottom
            $0.height == 30
        }
        constrain(containerView,segmentedControl) {
            $0.width == $0.superview!.width
            $0.centerY == $0.superview!.centerY
            $0.top == $1.bottom
            $0.height == self.view.frame.height
       }
    }
}

// MARK: Style
private extension WeatherViewController{
    func style(){
        gradientView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        
        let blackColor = UIColor(white: 0, alpha: 0.0)
        let clearColor = UIColor(white: 0, alpha: 1.0)
        
        gradientLayer.colors = [blackColor.cgColor, clearColor.cgColor]
        
        gradientLayer.startPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:1.0)
        gradientView.layer.mask = gradientLayer
        
        maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        segmentedControl.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        containerView.backgroundColor = UIColor.clear
        
    }
}
// MARK: UIScrollViewDelegate
/*extension WeatherViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let treshold: CGFloat = CGFloat(view.frame.height)/2
        overlayView.alpha = min (1.0, offset/treshold)
        // MARK: ScrollView only scroll vertically
        if(scrollView.contentOffset.x != 0){
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: false)
        }
        
    }
}*/

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.delegate = self
        if(scrollView.contentOffset.x != 0){
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: false)
        }
        /*let height = scrollView.bounds.size.height
        let position =  max(scrollView.contentOffset.y, 0.0)
        let percent = min(position / height, 0.8)*/
        let foregroundHeight = frontScrollView.contentSize.height - frontScrollView.bounds.height
        let percentageScroll = frontScrollView.contentOffset.y / foregroundHeight
        let backgroundHeight = backScrollView.contentSize.height - backScrollView.bounds.height
        
        backScrollView.contentOffset = CGPoint(x: 0, y: backgroundHeight * percentageScroll * 0.1)
   
    }
}
