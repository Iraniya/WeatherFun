//
//  ViewController.swift
//  WeatherFun
//
//  Created by iraniya on 19/08/20.
//  Copyright © 2020 iraniya. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {

    //MARK: - Types
    
    private enum AlertType {
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
        case noWeatherDataAvailabel
    }
    
    //MARk: - Constants
    
    private let sequeDayView  = "SegueDayView"
    private let sequeWeekView = "SegueWeekView"
    private let sequeSettingView = "SegueSettingsView"
    private let sequeLocationView = "SegueLocationsView"
    
    //MARK: - Properties
    
    @IBOutlet weak var dayViewController: DayViewController!
    @IBOutlet weak var weekViewController: WeekViewController!
    
    
    //MARK: -
    
    private var currentLocation: CLLocation? {
        didSet {
            //fetchWeatherLocation()
        }
    }
    
    //MARK: -
    
    private lazy var dataManager = DataManager()
    
    //MARK: -
    
    private var locationManager: CLLocationManager = {
        // Initialize Location Manger
        let locationManger = CLLocationManager()
        
        locationManger.distanceFilter = 1000.0
        locationManger.desiredAccuracy = 1000.0
        
        return locationManger
    }()
    
    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Notification Handling
        setupNotificationHandling()
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier  = segue.identifier else { return }
        
        switch identifier {
        case sequeDayView:
            guard let destination = segue.destination as? DayViewController else {
                fatalError("Unexpected destination view controller")
            }
            
            //Configure destination
            //destination.delegate = self
            
            //Update day view controller
            self.dayViewController = destination
            
        case sequeWeekView:
            guard let destination = segue.destination as? WeekViewController else {
                fatalError("Unexpected destination view controller")
            }
            
            //Configure destination
            //destination.delegate = self
            
            //update Week View Controller
            self.weekViewController  = destination
        
        default: break
        }
    }

    //MARK: - Actions
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) { }

    //MARK: - Helper Methods
    
    private func setupNotificationHandling() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            //Request Location
            self?.requestLocation()
        }
    }
    
    //Mark: -
    
    private func requestLocation() {
        //Configure Location Manager
        //locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Request current location
            locationManager.requestLocation()
        default:
            //Request Autorization
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func fetchWeatherData() {
        guard let location = currentLocation else {
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        //Fetch weather data for the location
        
        //dataManager.
    }
}

