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
import RxRealm
import RealmSwift
import DynamicBlurView
import CoreLocation
import RxSwiftUtilities
import Reachability



class WeatherViewController: UIViewController {
    private let gradientView = UIView()
    private let maskLayer = UIView()
    private let backgroundView = UIImageView()
    private let backScrollView = UIScrollView()
    private let frontScrollView = UIScrollView()
    private let currentWeatherView = CurrentWeatherView(frame: CGRect.zero)
    private let segmentedControl = UISegmentedControl(frame: CGRect.zero)
    private let containerView = UIView(frame: CGRect.zero)
    private var blurredImageView = DynamicBlurView(frame: CGRect.zero)
    private var menuButton:UIButton = UIButton()
    private var sideMenuBarContainerView = UIView(frame: CGRect.zero)
    private var isMenuButtonPressed: Bool = true
    private let bag = DisposeBag()
    private let temperatureUnitControl = UISegmentedControl()
    private let windSpeedUnitControl = UISegmentedControl()
    var weatherForecastData: Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)>?
    var flickrImage = BehaviorRelay<UIImage?>(value: UIImage(named: "banff")!)
    var viewModel: ViewModel?
    var weatherForecastModelObservable: Observable<WeatherForecastModel>?
    var geoLocation: Observable<Result<CLLocationCoordinate2D, Error>>?
    let locationManager = CLLocationManager()
    var searchTextField: UITextField?
    var lat: Double?
    var lon: Double?
    var searchController: UISearchController?
    //let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let progressHUD = ProgressHUD(text: "Loading")
    var reachability: Reachability?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       setup()
       layoutView()
       style()
       setupSegmentedView()
       setupNavigationbar()
       self.frontScrollView.addSubview(self.progressHUD)
       reachability = Reachability()
       try? reachability?.startNotifier()
        Reachability.rx.reachabilityChanged
            .subscribe(onNext:{ element in
                print("Reachability changed: \(element)")
            })
            .disposed(by:bag)
        
        Reachability.rx.status
            .subscribe(onNext:{ status in
                print("Reachability status changed: \(status)")
            })
            .disposed(by:bag)
        Reachability.rx.isReachable
            .subscribe(onNext:{ isReachable in
                print("isReachable: \(isReachable)")
            })
            .disposed(by:bag)
        
        Reachability.rx.isConnected
            .subscribe(onNext:{ isConnected in
                print("isConnected: \(isConnected)")
            })
            .disposed(by:bag)
        
        Reachability.rx.isDisconnected
            .subscribe(onNext:{ isDisconnected in
                print("isDisconnected: \(isDisconnected)")
            })
            .disposed(by:bag)
        print("frontScrollViewFrame: " + "\(frontScrollView.frame)")
        //self.activityIndicatorView.startAnimating()
        let locationObservable = Reachability.rx.isConnected
            .flatMap(){return
                  GeoLocationService.instance.getLocation()
          }
       weatherForecastData =
                              locationObservable
                             .flatMap(){[unowned self] location -> Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)> in
                                 let lat = location.latitude
                                 let lon = location.longitude
                                 self.viewModel = ViewModel(lat: lat, lon: lon, apiType: InternetService.self)
                                 self.weatherForecastData = self.viewModel?.weatherForecastData
                                 self.flickrImage = (self.viewModel?.flickrImage)!
                                 self.bindBackground(flickrImage: self.flickrImage)
                                 return self.weatherForecastData!
                              }
        
     }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func bindBackground(flickrImage: BehaviorRelay<UIImage?>) {
        
        flickrImage.asDriver()
            .drive(onNext: { [weak self] flickrImage in
                let resizedImage = flickrImage?.scaled(CGSize(width: (self?.view.frame.width)!, height: (self?.view.frame.height)! * 1.5))
                self?.backgroundView.image = resizedImage
                self?.blurredImageView = DynamicBlurView(frame: (self?.view.bounds)!)
                self?.blurredImageView.blurRadius = 10
                self?.blurredImageView.alpha = 0
                self?.backgroundView.addSubview((self?.blurredImageView)!)
            })
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
        Reachability.rx.isDisconnected
            .subscribe(onNext:{
                self.displayErrorMessage(userMessage: "Not connected to Network", handler: nil)
            })
            .disposed(by:bag)
     
        
        weatherForecastData?
            .subscribe(onNext: { (weatherForecastData) in
                //print("weatherForecastData: " + "\(weatherForecastData)")
                let weatherForecastModel = weatherForecastData.0.first
                if weatherForecastModel != nil {
                    self.currentWeatherView.update(with: weatherForecastModel!)
                    self.tableViewController.weatherForecastModel = weatherForecastModel
                    self.tableViewController.tableView.reloadData()
                    self.progressHUD.hide()
                    //self.activityIndicatorView.removeFromSuperview()
                }
            })
            .disposed(by: bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
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
        backScrollView.addSubview(blurredImageView)
        backScrollView.contentSize = backgroundView.bounds.size
        backScrollView.delegate = self
        frontScrollView.contentMode = .scaleAspectFill
        frontScrollView.clipsToBounds = true
        frontScrollView.delegate = self
        frontScrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height * 2)
        //frontScrollView.addSubview(progressHUD)
        frontScrollView.addSubview(currentWeatherView)
        frontScrollView.addSubview(segmentedControl)
        frontScrollView.addSubview(containerView)
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
        constrain(blurredImageView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(frontScrollView) { view in
            view.top == view.superview!.top + 40
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        /*constrain(progressHUD) { view in
            view.centerY == view.superview!.centerY
            view.centerX == view.superview!.centerX
        }*/
        constrain(currentWeatherView) { view in
            view.width == view.superview!.width
            view.centerX == view.superview!.centerX
            view.bottom == view.superview!.top + self.view.frame.height - 120
        }
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
        maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        blurredImageView.blurRadius = 10
        blurredImageView.alpha = 0
        
        segmentedControl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.tintColor = UIColor.white
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], for: .normal)
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
        let height = scrollView.bounds.size.height
        let position =  max(scrollView.contentOffset.y, 0.0)
        let percent = min(position / height * 1.2, 1.0)
        self.blurredImageView.alpha = percent
        let foregroundHeight = frontScrollView.contentSize.height - frontScrollView.bounds.height
        let percentageScroll = frontScrollView.contentOffset.y / foregroundHeight
        let backgroundHeight = backScrollView.contentSize.height - backScrollView.bounds.height
        
        backScrollView.contentOffset = CGPoint(x: 0, y: backgroundHeight * percentageScroll * 0.1)
        if #available(iOS 11.0, *) {
            frontScrollView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
        }
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
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
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

extension WeatherViewController: UINavigationControllerDelegate, UINavigationBarDelegate {
    func setupNavigationbar() {
        self.navigationItem.title = "Toronto"
        let navigationBar = navigationController!.navigationBar
        navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 19)!]
       //MARK: - set navigation bar transparent
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        menuButton = UIButton(frame: CGRect(0, 0, 30, 30))
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        
        menuButton.addTarget(self, action: #selector(WeatherViewController.menuButtonPressed), for: .touchUpInside)
        //assign button to navigationbar
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = menuButtonItem
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(WeatherViewController.searchCity))
        searchButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = searchButton
        print("navigationBar.frame.height: " + "\(navigationBar.frame.height)")
    }
}
    
extension WeatherViewController: UISearchBarDelegate {
    @objc func searchCity(_ sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController!.hidesNavigationBarDuringPresentation = false
        searchController!.searchBar.keyboardType = UIKeyboardType.asciiCapable
        let searchBar = searchController!.searchBar
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.tintColor = UIColor.white
        searchBar.placeholder = "Search City"
        searchBar.barTintColor = UIColor(red: (0/255.0), green: (76/255.0), blue: (153/255.0), alpha: 0.8)
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        // Make this class the delegate and present the search
        self.searchController!.searchBar.delegate = self
        present(searchController!, animated: true, completion: nil)
       
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // this method is being called when search btn in the keyboard tapped
         //searchBar.setShowsCancelButton(false, animated: false)
         /*searchBar.isHidden = true
        if searchBar.isFirstResponder {
            _ = searchBar.resignFirstResponder()
        }*/
        if searchController != nil {
             searchController!.dismiss(animated: true, completion: nil)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        guard searchBar.text != nil else {
            //geoCodingViewModel = GeocodingViewModel(cityName: searchBar.text!, apiType: InternetService.self)
            //print("geoCodingViewModel: " + "\(geoCodingViewModel)")
            return
        }
        self.progressHUD.show()
        geoLocation = GeoLocationService.instance.locationGeocoding(address: searchBar.text!)
        self.weatherForecastModelObservable = geoLocation!
            .observeOn(MainScheduler.instance)
            .flatMap(){ [unowned self] locationResult -> Observable<WeatherForecastModel> in
                switch locationResult {
                case .Success(let location):
                    let lat = location.latitude
                    let lon = location.longitude
                    self.viewModel = ViewModel(lat: lat, lon: lon, apiType: InternetService.self)
                    self.backgroundView.image = nil
                    self.flickrImage = (self.viewModel?.flickrImage)!
                    self.bindBackground(flickrImage: self.flickrImage)
                    return (self.viewModel?.weatherForecastData
                        .map(){ weatherData in
                            print("weatherForecastDataSearch: " + "\(String(describing: weatherData.0.last))")
                            return weatherData.0.last!
                        })!
                    
                case .Failure(let error):
                    //show in alert
                    self.displayErrorMessage(userMessage: "\(String(describing: error))", handler: nil)
                    let realm = try? Realm()
                    //let count = realm?.objects(WeatherForecastModel.self).count
                    let weatherForecastModelLast = realm?.objects(WeatherForecastModel.self).last
                    print("weatherForecastModelLast: " + "\(String(describing: weatherForecastModelLast))")
                    return Observable.just(weatherForecastModelLast!)
                }
                
                //searchBar.isHidden = true
            }
        self.weatherForecastModelObservable?
            .subscribe(onNext: { (weatherForecastModel) in
                print("weatherForecastModelLast: " + "\(weatherForecastModel)")
                self.currentWeatherView.update(with: weatherForecastModel)
                self.tableViewController.weatherForecastModel = weatherForecastModel
                self.tableViewController.tableView.reloadData()
                self.progressHUD.hide()
           })
           .disposed(by: bag)
    }
}

extension WeatherViewController {
    @objc func menuButtonPressed(_ sender: AnyObject) {
        if isMenuButtonPressed {
          setupUnitSegmentedView()
          isMenuButtonPressed = false
          windSpeedUnitControl.addTarget(self, action: #selector(unitChange(_:)), for: .valueChanged)
          temperatureUnitControl.addTarget(self, action: #selector(unitChange(_:)), for: .valueChanged)
        } else {
            if temperatureUnitControl.superview != nil && windSpeedUnitControl.superview != nil {
                temperatureUnitControl.removeFromSuperview()
                windSpeedUnitControl.removeFromSuperview()
                isMenuButtonPressed = true
            }
        }
       
     }
    func setupUnitSegmentedView() {
        frontScrollView.addSubview(temperatureUnitControl)
        frontScrollView.addSubview(windSpeedUnitControl)
        unitSegmentedViewLayout()
        unitSegmentedViewStyle()
        setupUnitSegmentedControl()
 
    }
    func unitSegmentedViewLayout() {
        constrain(temperatureUnitControl) {
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left + 5
            $0.width == 120
            $0.height == 40
         }
        constrain(windSpeedUnitControl, temperatureUnitControl) {
            $0.top == $1.bottom + 2
            $0.left == $1.left
            $0.right == $1.right
            $0.height == 40
        }
    }
func unitSegmentedViewStyle() {
    temperatureUnitControl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    temperatureUnitControl.layer.cornerRadius = 5.0
    temperatureUnitControl.tintColor = UIColor.white
    temperatureUnitControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], for: .normal)
    temperatureUnitControl.sizeToFit()
    
    windSpeedUnitControl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    windSpeedUnitControl.layer.cornerRadius = 5.0
    windSpeedUnitControl.tintColor = UIColor.white
    windSpeedUnitControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], for: .normal)
    windSpeedUnitControl.sizeToFit()
    
}
func setupUnitSegmentedControl() {
    // Configure Segmented Control
   temperatureUnitControl.removeAllSegments()
   windSpeedUnitControl.removeAllSegments()
   temperatureUnitControl.insertSegment(withTitle: "°F", at: 0, animated: false)
   temperatureUnitControl.insertSegment(withTitle: "°C", at: 1, animated: false)
   windSpeedUnitControl.insertSegment(withTitle: "mph", at: 0, animated: false)
   windSpeedUnitControl.insertSegment(withTitle: "km/h", at: 1, animated: false)
    
   temperatureUnitControl.selectedSegmentIndex = 0
   windSpeedUnitControl.selectedSegmentIndex = 0
    
}
    @objc func unitChange(_ sender: UISegmentedControl) {
        switch temperatureUnitControl.selectedSegmentIndex {
        case 0:
            print("Farenheit")
        case 1:
            print("Celcius")
        default:
            break
        }
        switch windSpeedUnitControl.selectedSegmentIndex {
        case 0:
            print("mile per hour")
        case 1:
            print("km/h")
        default:
            break
        }
    }
}
