//
//  WeatherViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-03-07.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa


class WeatherViewController: UIViewController {
    private let gradientView = UIView()
    private let maskLayer = UIView()
    private let backgroundView = UIImageView()
    private let backScrollView = UIScrollView()
    private let frontScrollView = UIScrollView()
    private let currentWeatherView = CurrentWeatherView(frame: CGRect.zero)
    private let segmentedControl = UISegmentedControl(frame: CGRect.zero)
    private let containerView = UIView(frame: CGRect.zero)
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
      super.viewDidLoad()
      setup()
      layoutView()
      style()
      bindBackground()
      setupSegmentedView()
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
            let blurEffect = UIBlurEffect(style: .dark)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = (self?.backgroundView.bounds)!
            blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self?.backgroundView.addSubview(blurredEffectView)
        })
        .disposed(by: bag)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentWeatherView.render()
    }
    
    private lazy var tableViewController: WeatherForecastTableViewController = {
        let viewController = WeatherForecastTableViewController()
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var graphViewController: WeatherForecastGraphViewController = {
        let viewController = WeatherForecastGraphViewController()
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var summaryViewController: WeatherForecastSummaryViewController = {
        let viewController = WeatherForecastSummaryViewController()
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
 }

private extension WeatherViewController{
    func setup(){
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        maskLayer.contentMode = .scaleAspectFill
        maskLayer.clipsToBounds = true
        backgroundView.addSubview(maskLayer)
        backScrollView.addSubview(backgroundView)
        backScrollView.addSubview(gradientView)
        backScrollView.contentSize = backgroundView.bounds.size
        backScrollView.delegate = self
        frontScrollView.contentMode = .scaleAspectFill
        frontScrollView.clipsToBounds = true
        frontScrollView.delegate = self
        frontScrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height * 2)
        frontScrollView.addSubview(currentWeatherView)
        frontScrollView.addSubview(segmentedControl)
        frontScrollView.addSubview(containerView)
        /*overlayView.contentMode = .scaleAspectFill
        overlayView.clipsToBounds = true
        view.addSubview(overlayView)*/
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
        constrain(gradientView) { view in
            view.top == view.superview!.top
            //view.bottom == view.superview!.bottom
            //view.left == view.superview!.left
            //view.right == view.superview!.right
            view.width == view.superview!.width
            view.height == self.view.frame.height
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
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 10
            $0.height == 40
        }
        constrain(containerView,segmentedControl) {
            $0.width == $0.superview!.width
            $0.centerX == $0.superview!.centerX
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
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.tintColor = UIColor.white
        segmentedControl.sizeToFit()
        containerView.backgroundColor = UIColor.clear
        
    }
}
// MARK: UIScrollViewDelegate
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
//MARK: -set up segmented controll
extension WeatherViewController {
    func setupSegmentedView() {
        setupSegmentedControl()
        updateView()
    }
    
    func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Table", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Graph", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Summary", at: 2, animated: false)
        segmentedControl.addTarget(self, action: #selector(contentChange(_:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func contentChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
       switch segmentedControl.selectedSegmentIndex {
          case 0:
             remove(asChildViewController: summaryViewController)
             remove(asChildViewController: graphViewController)
             add(asChildViewController: tableViewController)
          case 1:
             remove(asChildViewController: tableViewController)
             remove(asChildViewController: summaryViewController)
             add(asChildViewController: graphViewController)
          case 2:
             remove(asChildViewController: graphViewController)
             remove(asChildViewController: tableViewController)
             add(asChildViewController: summaryViewController)
          default:
          break
        }
    }
}
