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
  fileprivate let gradientView = UIView()
  fileprivate let overlayView = UIImageView()
  fileprivate let backgroundView = UIImageView()
  fileprivate let scrollView = UIScrollView()
    
  private let bag = DisposeBag()

    override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    layoutView()
    bindBackground()
 
  }
    //Lincoln: lat: 40.8136, lon: -96.7026
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func bindBackground() {
      let flickrViewModel: FlickrViewModel = FlickrViewModel(lat: 43.6532, lon: -79.3832, currentWeather: "sunny", apiType: FlickrService.self, imageDataCacheType: ImageDataCaching.self)
      flickrViewModel.backgroundImage.asDriver()
         .drive(onNext: { [weak self] backgroundImage in
          self?.backgroundView.image = backgroundImage
          self?.overlayView.image = backgroundImage?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
          self?.overlayView.alpha = 0
        })
       .disposed(by: bag)
    }
 }

private extension WeatherViewController{
    func setup(){
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        overlayView.contentMode = .scaleAspectFill
        overlayView.clipsToBounds = true
        view.addSubview(overlayView)
        view.addSubview(gradientView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
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
        constrain(scrollView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
    }
}
