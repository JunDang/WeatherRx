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
    private let unitControl = UISegmentedControl()
    var weatherForecastData: Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)>?
    var flickrImage = BehaviorRelay<UIImage?>(value: UIImage(named: "banff")!)
    var viewModel: ViewModel?
    var weatherForecastModelObservable: Observable<WeatherForecastModel>?
    var geoLocation: Observable<Result<(CLLocationCoordinate2D, String), Error>>?
    let locationManager = CLLocationManager()
    var searchTextField: UITextField?
    var lat: Double?
    var lon: Double?
    var searchController: UISearchController?
    //let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let progressHUD = ProgressHUD(text: "Loading")
    var reachability: Reachability?
    var cityName: String = ""
    var locationObservable: Observable<CLLocationCoordinate2D>?
    var cityResultObservable: Observable<Result<String, Error>>?
    var cityNameObservable: Observable<String>?
    var dateFormatter = DateFormatter()
    var convertToMetric: Bool?
    var userDefaults = UserDefaults.standard
    var defaultWeatherData: WeatherForecastModel = WeatherForecastModel()
    
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
       //self.activityIndicatorView.startAnimating()
        defaultWeatherData.latitude = 0.0
        defaultWeatherData.longitude = 0.0
        defaultWeatherData.currently?.time = 0
        defaultWeatherData.currently?.timeDate = nil
        defaultWeatherData.currently?.summary = ""
        defaultWeatherData.currently?.icon = ""
        defaultWeatherData.currently?.temperature = 0.0
        defaultWeatherData.currently?.apparentTemperature = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.time = 0
        defaultWeatherData.daily?.dailyWeatherModel.first?.timeDate = nil
        defaultWeatherData.daily?.dailyWeatherModel.first?.temperatureMax = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.temperatureMin = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.icon = ""
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunsetTime = 0
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunriseTime = 0
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunriseTimeDate = nil
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunsetTimeDate = nil
        defaultWeatherData.daily?.dailyWeatherModel.first?.precipType = ""
        defaultWeatherData.daily?.dailyWeatherModel.first?.precipProbability = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.precipIntensity = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.dewPoint = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.pressure = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.humidity = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.windSpeed = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.windBearing = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.cloudCover = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.ozone = 0.0
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.timeDate = nil
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.time = 0
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.icon = ""
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.temperature = 0.0
        defaultWeatherData.minutely?.summary = ""
        fetchData()
        // add refresh time
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.long
        //NSUserDefaults
      /* convertToMetric = userDefaults.object(forKey: "convertToMetric") as? Bool
        if (convertToMetric == nil) {
            convertToMetric = false
            userDefaults.set(convertToMetric, forKey: "convertToMetric")
        }
        
        if convertToMetric == true {
            unitControl.selectedSegmentIndex = 0
        } else {
            unitControl.selectedSegmentIndex = 1
        }*/
       
       
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func fetchData() {
        //locationObservable = GeoLocationService.instance.getLocation()
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
        /*weatherForecastModelObservable = weatherForecastData?
            .map(){(weatherForecastData) in
                //print("weatherForecastData: " + "\(weatherForecastData)")
                    guard weatherForecastData.0.first != nil else {
                    let defaultWeatherModel = self.defaultWeatherData
                    return defaultWeatherModel
                }
                let weatherForecastModel = weatherForecastData.0.first
                 print("weatherForecastweatherForecastModel: " + "\(weatherForecastModel)")
                return weatherForecastModel!
            }*/
      /*weatherForecastModelObservable =  locationObservable
            .flatMap(){[unowned self] location -> Observable<WeatherForecastModel> in
                let lat = location.latitude
                let lon = location.longitude
                self.viewModel = ViewModel(lat: lat, lon: lon, apiType: InternetService.self)
                self.backgroundView.image = nil
                self.flickrImage = (self.viewModel?.flickrImage)!
                self.bindBackground(flickrImage: self.flickrImage)
                return (self.viewModel?.weatherForecastData
                    .map(){ weatherData in
                        guard weatherData.0.last != nil else {
                           let defaultWeatherModel = self.defaultWeatherData
                           return defaultWeatherModel
                        }
                        print("weatherForecastDataSearch: " + "\(String(describing: weatherData.0.last))")
                        return weatherData.0.last!
                    })!
              }*/
       cityResultObservable = Reachability.rx.isConnected
            .flatMap(){ _ -> Observable<Result<String, Error>> in return
                GeoLocationService.instance.cityResultObservable!
            }
        cityNameObservable = cityResultObservable?
            .observeOn(MainScheduler.instance)
            .map() {cityResult -> String in
                switch cityResult {
                case .Success(let cityName):
                    self.cityName = cityName
                //print("cityName: " + "\( self.cityName)")
                case .Failure(let error):
                    self.displayErrorMessage(userMessage:"\(String(describing: error))", handler: nil)
                }
                return self.cityName
        }
        cityNameObservable?
            .subscribe(onNext: {cityName in
                self.navigationItem.title = cityName
            })
            .disposed(by: bag)
    }
    func updateUI() {
       /* weatherForecastModelObservable = weatherForecastData?
            .map(){(weatherForecastData) in
                //print("weatherForecastData: " + "\(weatherForecastData)")
                guard weatherForecastData.0.first != nil else {
                    let defaultWeatherModel = self.defaultWeatherData
                    return defaultWeatherModel
                }
                let weatherForecastModel = weatherForecastData.0.first
                print("weatherForecastweatherForecastModel: " + "\(weatherForecastModel)")
                return weatherForecastModel!
        }*/
      /* weatherForecastModelObservable?
            .subscribe(onNext: { (weatherForecastModel) in
                print("weatherForecastModelLast: " + "\(weatherForecastModel)")
                self.currentWeatherView.update(with: weatherForecastModel)
                self.tableViewController.weatherForecastModel = weatherForecastModel
                self.tableViewController.tableView.reloadData()
                self.progressHUD.hide()
            })
            .disposed(by: bag)*/
 /*weatherForecastModelObservable = weatherForecastData?
            .map(){(weatherForecastData) in
                //print("weatherForecastData: " + "\(weatherForecastData)")
                guard weatherForecastData.0.first != nil else {
                    let defaultWeatherModel = self.defaultWeatherData
                    return defaultWeatherModel
                }
                let weatherForecastModel = weatherForecastData.0.first
                print("weatherForecastweatherForecastModel: " + "\(weatherForecastModel)")
                return weatherForecastModel!
        }*/
        weatherForecastData?
            .subscribe(onNext: { (weatherForecastData) in
                //print("weatherForecastData: " + "\(weatherForecastData)")
                let weatherForecastModel = weatherForecastData.0.last
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
       
        updateUI()
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(WeatherViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
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
        frontScrollView.addSubview(refreshControl)
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
        self.navigationItem.title = cityName
    
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
        searchCityWeatherData()
        updateUIWithSearchCityData()
   }
    func searchCityWeatherData() {
        //geoLocation = GeoLocationService.instance.locationGeocoding(address: searchBar.text!)
        self.weatherForecastModelObservable = geoLocation!
            .observeOn(MainScheduler.instance)
            .flatMap(){ [unowned self] locationResult -> Observable<WeatherForecastModel> in
                switch locationResult {
                case .Success(let result):
                    let location = result.0
                    let lat = location.latitude
                    let lon = location.longitude
                    self.viewModel = ViewModel(lat: lat, lon: lon, apiType: InternetService.self)
                    self.backgroundView.image = nil
                    self.flickrImage = (self.viewModel?.flickrImage)!
                    self.bindBackground(flickrImage: self.flickrImage)
                    self.cityName = result.1
                    self.navigationItem.title = self.cityName
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
    }
    func updateUIWithSearchCityData() {
        weatherForecastModelObservable?
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
          unitControl.addTarget(self, action: #selector(unitChange(_:)), for: .valueChanged)
          } else {
            if unitControl.superview != nil {
                unitControl.removeFromSuperview()
                isMenuButtonPressed = true
            }
        }
       
     }
    func setupUnitSegmentedView() {
        frontScrollView.addSubview(unitControl)
        unitSegmentedViewLayout()
        unitSegmentedViewStyle()
        setupUnitSegmentedControl()
 
    }
    func unitSegmentedViewLayout() {
        constrain(unitControl) {
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left + 5
            $0.width == 180
            $0.height == 40
         }
    }
func unitSegmentedViewStyle() {
    unitControl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    unitControl.layer.cornerRadius = 5.0
    unitControl.tintColor = UIColor.white
    unitControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!], for: .normal)
    unitControl.sizeToFit()
}
func setupUnitSegmentedControl() {
    // Configure Segmented Control
   unitControl.removeAllSegments()
   unitControl.insertSegment(withTitle: "Metric", at: 0, animated: false)
   unitControl.insertSegment(withTitle: "Imperial", at: 1, animated: false)
    
   unitControl.selectedSegmentIndex = 0
}
    @objc func unitChange(_ sender: UISegmentedControl) {
        geoLocation = GeoLocationService.instance.locationGeocoding(address: self.navigationItem.title!)
        searchCityWeatherData()
        switch unitControl.selectedSegmentIndex {
        case 0:
            print("Metric")
            convertToMetric = userDefaults.object(forKey: "convertToMetric") as? Bool
            if (convertToMetric == nil) {
                convertToMetric = false
                userDefaults.set(convertToMetric, forKey: "convertToMetric")
            }
            convertToMetric = true
            userDefaults.set(convertToMetric, forKey: "convertToCelsius")
            userDefaults.synchronize()
            updateUIWithSearchCityData()
        case 1:
            convertToMetric = false
            userDefaults.removeObject(forKey: "convertToCelsius")
            userDefaults.synchronize()
            updateUIWithSearchCityData()
            print("convertToMetric: \(convertToMetric)")
            print("Imperial")
            default:
            break
        }
        //userDefaults.set(convertToMetric, forKey: "convertToCelsius")
        //userDefaults.synchronize()
    }
}

private extension WeatherViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        geoLocation = GeoLocationService.instance.locationGeocoding(address: self.navigationItem.title!)
        searchCityWeatherData()
        updateUIWithSearchCityData()
        let now = Date()
        let updateString = "Last Updated at " + self.dateFormatter.string(from: now)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            
        }
    }
}
