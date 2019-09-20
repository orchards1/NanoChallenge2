//
//  ViewController.swift
//  NanoChallenge2
//
//  Created by Michael Louis on 18/09/19.
//  Copyright © 2019 Michael Louis. All rights reserved.
//

import UIKit
import LocalAuthentication
import UserNotifications
import CoreLocation
import MapKit

enum AuthenticationState{
    case loggedin, loggedout
}

var context = LAContext()
var timer = Timer()

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    // For Notification based on Location
    var locationManager:CLLocationManager = CLLocationManager()
    //   let regionRadius: CLLocationDistance = 5
    let center = UNUserNotificationCenter.current()
    var state = AuthenticationState.loggedout
    @IBAction func tapButton(_ sender: Any) {
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    
                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [unowned self] in
                        self.state = .loggedin
                        
                    self.performSegue(withIdentifier: "gotohome", sender: nil)
                    }
                }
                    
                    //ELSE
                else {
                    
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    // Fall back to a asking for username and password.`
                    // ...`
                }
                
            }
            
            
            
            
            
        }
        
        if state == .loggedin
        {
            state = .loggedout
        }
            
            
            
        else {
            
            // Get a fresh context for each login. If you use the same context on multiple attempts`
            //  (by commenting out the next line), then a previously successful authentication`
            //  causes the next policy evaluation to succeed without testing biometry again.`
            //  That's usually not what you want.
            context = LAContext()
            context.localizedCancelTitle = "Enter Username/Password"
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
   @objc func seetimeleft()
    {
        var now = Date()
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, hour: 18)
        let next6pm = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
        let name = UserDefaults.standard.string(forKey: "name")
        let diff = calendar.dateComponents([.hour], from: now, to: next6pm)
        var display = diff.hour!
        usernameLabel.text = name
        if(display>=0 && display<=1)
        {
            timeLeftLabel.text = String(format: " 1 hour left till session ends.",display )
        }
        else if(display>1 && display<=4)
        {
            timeLeftLabel.text = String(format: " %d hours left till session ends.",display )
        }
        else if(display>4 && display<=17)
        {
            timeLeftLabel.text = String("Your session hasn't started yet.")
            timeLabel.textColor = UIColor(red: 245.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1.0)
            hiLabel.textColor = UIColor(red: 245.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1.0)
            loginButton.setImage(UIImage(named: "LoginButton"), for: .normal)
        }
        else
        {
            timeLeftLabel.text = String("You've finished your session today! Tap button below to continue.")
            timeLabel.textColor = UIColor(red: 245.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1.0)
            hiLabel.textColor = UIColor(red: 245.0/255.0, green: 103.0/255.0, blue: 103.0/255.0, alpha: 1.0)
            loginButton.setImage(UIImage(named: "LoginButton"), for: .normal)
        }
    }
    
    func setTimer()
    {
        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(tick) , userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(seetimeleft) , userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        
        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // The biometryType, which affects this app s UI when state changes, is only meaningful
        //  after running canEvaluatePolicy. But make sure not to run this test from inside a
        //  policy evaluation callback (for example, don t put next line in the state s didSet
        //  method, which is triggered as a result of the state change made in the callback),
        //  because that might result in deadlock.
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        // For notification based on location
        requestPermissionNotifications()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        //   mapViewLoad.showsUserLocation = true
        locationManager.distanceFilter = 20
        
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(-6.3022,106.6522), radius: 25, identifier: "AppleAcademy")
        locationManager.startMonitoring(for: geoFenceRegion)
        //locationManager.stopUpdatingLocation()
        // Do any additional setup after loading the view.
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        //        if let userLocation = locationManager.location?.coordinate {
        //            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        //            mapViewLoad.setRegion(viewRegion, animated: false)
        //        }
        
        //   self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //    addRadiusCircle(location: appleAcademyLocation)
        
        for currentLocation in locations {
            print("\(String(describing: index)): \(currentLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        postLocalNotifications(eventTitle:"Welcome to \(region.identifier)!")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        postLocalNotifications(eventTitle:"Hey! you are leaving \(region.identifier)")
    }
    
    func requestPermissionNotifications(){
        let application =  UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
                if( error != nil ){
                    print(error!)
                }
                else{
                    if( isAuthorized ){
                        print("authorized")
                        NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                    }
                    else{
                        let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                        if pushPreference == false {
                            let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        // Checking for setting is opened or not
                                        print("Setting is opened: \(success)")
                                    })
                                }
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                                print("user denied")
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            let viewController = UIApplication.shared.keyWindow!.rootViewController
                            DispatchQueue.main.async {
                                viewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func postLocalNotifications(eventTitle:String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "Have fun and don't forget to clock in/clock out"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
    }
}


    
    
    
    
    



