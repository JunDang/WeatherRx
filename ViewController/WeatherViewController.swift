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
    var viewModel: ViewModel!
    var weatherForecastModelObservable: Observable<WeatherForecastModel>!
    var weatherForecastModel: WeatherForecastModel!
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
    var userDefaults = UserDefaults.standard
    var valueStored:Bool?
    let convertToMetric: String = "convertToMetric"
    var selectedIndex = 0
    var segmentIndexStored: Bool?
    var segmentIndex: Int?
    
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
       fetchData()
        // add refresh time
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.long
        //NSUserDefaults
        valueStored = userDefaults.object(forKey: "unitChange") as? Bool
         if (valueStored == nil) {
            valueStored = false
           userDefaults.set(convertToMetric, forKey: "unitChange")
         }
        
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func fetchData() {
       let locationObservable = Reachability.rx.isConnected
            .flatMap(){return
                GeoLocationService.instance.getLocation()
        }
        weatherForecastModelObservable =
            locationObservable
                  .observeOn(MainScheduler.instance)
                  .flatMap(){ [unowned self] location -> Observable<WeatherForecastModel> in
                    return (self.getWeatherForecastModel(location: location))
              }
        
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
                print("cityName: " + "\( self.cityName)")
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
    func getWeatherForecastModel(location: CLLocationCoordinate2D) -> Observable<WeatherForecastModel> {
        let lat = location.latitude
        let lon = location.longitude
        let key = "\(Int(lat*10000))\(Int(lon)*10000)"
        if let realm = try? Realm() {
            let weatherModel = realm.object(ofType: WeatherForecastModel.self, forPrimaryKey: key)
            print("weatherModelFromRealm: " + "\(String(describing: weatherModel))")
            if weatherModel != nil {
                let unixTime = Int(Date().timeIntervalSince1970)
                let currentTime = weatherModel!.currently!.time
                if (unixTime - currentTime) > 3600 {
                    self.viewModel = ViewModel(lat: lat, lon: lon, apiType: InternetService.self)
                    self.flickrImage = (self.viewModel?.flickrImage)!
                    self.bindBackground(flickrImage: self.flickrImage)
                    self.weatherForecastModelObservable =
                        self.viewModel.weatherForecastData
                            .map() { weatherData in
                                if weatherData.0.last != nil {
                                    let weatherModelUpdated = realm.object(ofType: WeatherForecastModel.self, forPrimaryKey: key)
                                    
                                    return weatherModelUpdated!
                                } else {
                                    self.displayErrorMessage(userMessage: "Weather Data Cannot be Updated", handler: nil)
                                    return weatherModel!
                                }
                    }
                } else {
                    self.weatherForecastModelObservable = Observable.just(weatherModel!)
                    self.flickrImage = BehaviorRelay<UIImage?>(value: UIImage(named: "banff")!)
                    self.bindBackground(flickrImage: self.flickrImage)
                }
            } else {
                self.viewModel = ViewModel(lat: lat, lon: lon, apiType: InternetService.self)
                self.flickrImage = (self.viewModel?.flickrImage)!
                self.bindBackground(flickrImage: self.flickrImage)
                self.weatherForecastModelObservable =
                    self.viewModel?.weatherForecastData
                        .skip(1)
                        .observeOn(MainScheduler.instance)
                        .map() { weatherData in
                            
                            if weatherData.0.last != nil {
                                self.weatherForecastModel = weatherData.0.last!
                            } else {
                                self.displayErrorMessage(userMessage: "Weather Data Cannot be Fetched", handler: nil)
                                let weatherForecastModelLast = realm.objects(WeatherForecastModel.self).last
                                if weatherForecastModelLast != nil {
                                    //print("weatherForecastModelLastFromRealm: " + "\(String(describing: weatherForecastModelLast))")
                                     self.weatherForecastModel = weatherForecastModelLast!
                                } else {
                                     self.weatherForecastModel = self.createEmptyWeatherModel()
                                     print("DefaultWeatherData: " + "\(String(describing: self.weatherForecastModel))")
                                }
                            }
                            return self.weatherForecastModel
                }
            }
        }
        return self.weatherForecastModelObservable!
    }
    func createEmptyWeatherModel() -> WeatherForecastModel {
        let weatherForecastModel = WeatherForecastModel()
        weatherForecastModel.currently = CurrentlyWeatherModel()
        weatherForecastModel.daily = DailyWeatherModel()
        weatherForecastModel.hourly = HourlyWeatherModel()
        let hourlyForecastDataList = List<HourlyForecastData>()
        for _ in 0..<49 {
            let hourlyForecastData = HourlyForecastData()
            hourlyForecastDataList.append(hourlyForecastData)
        }
        weatherForecastModel.hourly?.hourlyWeatherModel = hourlyForecastDataList
        let dailyForecastDataList = List<DailyForecastData>()
        for _ in 0..<8{
            let dailyForecastData = DailyForecastData()
            dailyForecastDataList.append(dailyForecastData)
        }
        weatherForecastModel.daily?.dailyWeatherModel = dailyForecastDataList
        weatherForecastModel.minutely = MinutelyWeatherModel()
        return weatherForecastModel
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
        //unitControl.selectedSegmentIndex = selectedIndex
        try? reachability?.startNotifier()
        Reachability.rx.isDisconnected
            .subscribe(onNext:{
                 self.displayErrorMessage(userMessage: "Not connected to Network",handler: nil)
                 self.weatherForecastModelObservable = self.diplayDataWhenError()
                 self.updateUIWithSearchCityData()
                
            })
            .disposed(by:bag)
    
        updateUIWithSearchCityData()
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
        //print("navigationBar.frame.height: " + "\(navigationBar.frame.height)")
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
        searchBar.barTintColor = UIColor(red: (15/255.0), green: (16/255.0), blue: (50/255.0), alpha: 0.8)
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
       
        guard searchBar.text != nil else {
            //geoCodingViewModel = GeocodingViewModel(cityName: searchBar.text!, apiType: InternetService.self)
            //print("geoCodingViewModel: " + "\(geoCodingViewModel)")
            return
        }
        self.progressHUD.show()
        geoLocation = GeoLocationService.instance.locationGeocoding(address: searchBar.text!)
        guard geoLocation != nil else {
            return
        }
        searchCityWeatherData(geoLocation: geoLocation!)
        updateUIWithSearchCityData()
   }
    func searchCityWeatherData(geoLocation: Observable<Result<(CLLocationCoordinate2D, String), Error>>) {
        
        self.weatherForecastModelObservable = geoLocation
            .observeOn(MainScheduler.instance)
            .flatMap(){ [unowned self] locationResult -> Observable<WeatherForecastModel> in
                switch locationResult {
                case .Success(let result):
                    let location = result.0
                    self.cityName = result.1
                    self.navigationItem.title = self.cityName
                    return self.getWeatherForecastModel(location: location)
                case .Failure(let error):
                    //show in alert
                    self.displayErrorMessage(userMessage: "\(String(describing: error))", handler: nil)
                    let weatherForecastModel = self.diplayDataWhenError()
                    return weatherForecastModel
                }
        }
    }
    func diplayDataWhenError() -> Observable<WeatherForecastModel> {
        let realm = try? Realm()
        //let count = realm?.objects(WeatherForecastModel.self).count
        let weatherForecastModelLast = realm?.objects(WeatherForecastModel.self).last
        print("weatherForecastModelLastFromRealm: " + "\(String(describing: weatherForecastModelLast))")
        guard weatherForecastModelLast != nil else {
            let weatherForecastModel = self.createEmptyWeatherModel()
            self.flickrImage = BehaviorRelay<UIImage?>(value: UIImage(named: "banff")!)
            self.bindBackground(flickrImage: self.flickrImage)
            return Observable.just(weatherForecastModel)
        }
        self.flickrImage = BehaviorRelay<UIImage?>(value: UIImage(named: "banff")!)
        self.bindBackground(flickrImage: self.flickrImage)
        return Observable.just(weatherForecastModelLast!)
    }
    func updateUIWithSearchCityData() {
        weatherForecastModelObservable?
            .subscribe(onNext: { (weatherForecastModel) in
                //print("weatherForecastModelLast: " + "\(weatherForecastModel)")
               
                self.currentWeatherView.update(with: weatherForecastModel)
                self.tableViewController.weatherForecastModel = weatherForecastModel
                self.tableViewController.tableView.reloadData()
                self.graphViewController.drawHourlyLine(with: weatherForecastModel)
                self.graphViewController.drawDailyLines(with: weatherForecastModel)
                self.summaryViewController.updateSummary(with: weatherForecastModel)
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
    
   segmentIndexStored = userDefaults.object(forKey: "segmentIndex") as? Bool
   if (segmentIndexStored == nil) {
       segmentIndexStored = false
       userDefaults.set(selectedIndex, forKey: "segmentIndex")
   }
   segmentIndex =  UserDefaults.standard.integer(forKey: "segmentIndex")
   unitControl.selectedSegmentIndex = segmentIndex!
}
@objc func unitChange(_ sender: UISegmentedControl) {
     let realm = try? Realm()
     var weatherForecastModelLast: WeatherForecastModel?
     if realm?.objects(WeatherForecastModel.self).last != nil {
        weatherForecastModelLast = realm?.objects(WeatherForecastModel.self).last
     } else {
         weatherForecastModelLast = self.createEmptyWeatherModel()
     }
     weatherForecastModelObservable = Observable.just(weatherForecastModelLast!)
     switch unitControl.selectedSegmentIndex {
     case 0:
        
        if valueStored == true {
            userDefaults.removeObject(forKey: "UnitChange")
        }
             userDefaults.set(convertToMetric, forKey: "UnitChange")
        //Set segment index
        
        if segmentIndexStored != nil {
            segmentIndex =  UserDefaults.standard.integer(forKey: "segmentIndex")
            if segmentIndex == 1 {
            userDefaults.removeObject(forKey: "segmentIndex")
            selectedIndex = 0
            userDefaults.set(selectedIndex, forKey: "segmentIndex")
            }
        }
        updateUIWithSearchCityData()
     case 1:
            //let valueStored = userDefaults.object(forKey: "UnitChange") as? Bool
        if valueStored == true {
           userDefaults.removeObject(forKey: "UnitChange")
        }
        let convertToImperial: String = "convertToImperial"
           userDefaults.set(convertToImperial, forKey: "UnitChange")
        
        segmentIndexStored = userDefaults.object(forKey: "segmentIndex") as? Bool
        if segmentIndexStored != nil {
            segmentIndex =  UserDefaults.standard.integer(forKey: "segmentIndex")
            if segmentIndex == 0 {
            userDefaults.removeObject(forKey: "segmentIndex")
            selectedIndex = 1
            userDefaults.set(selectedIndex, forKey: "segmentIndex")
            }
       
        }
        updateUIWithSearchCityData()
      default:
        break
        }
   }
}

private extension WeatherViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        var address: String?
        if self.navigationItem.title != "" {
            address = self.navigationItem.title
        } else {
            address = "Toronto"
        }
        geoLocation = GeoLocationService.instance.locationGeocoding(address: address!)
        print("geolocation: \(geoLocation)")
        guard geoLocation != nil else {
            return
        }
        searchCityWeatherData(geoLocation: geoLocation!)
        updateUIWithSearchCityData()
        let now = Date()
        let updateString = "Last Updated at " + self.dateFormatter.string(from: now)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            
        }
    }
}
