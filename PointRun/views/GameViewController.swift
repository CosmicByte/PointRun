//
//  GameViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/16/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import AudioToolbox
import GCHelper
import GoogleMaps
import UIKit

class GameViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var timerImage: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    
    var multiplayer = false
    var gameMode = PRGameMode.timed
    var menuView: MenuView!
    
    var lastLocation: CLLocation!
    
    var mapView: GMSMapView!
    var markers = [GMSMarker]()
    
    var points = 0
    
    var min = 5
    var sec = 0
    var timer: Timer!
    
    var manager = CLLocationManager()
    var location = CLLocation()
    var firstLocUpdate = true
    
    var players = [Player]()
    var playerIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.addObserver(self, selector: #selector(backButton), name: backNotification, object: nil)
        nc.addObserver(self, selector: #selector(mapChanged), name: mapChangedNotification, object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.decreaseTime), userInfo: nil, repeats: true)
        
        if CLLocationManager.locationServicesEnabled() {
            mapView = GMSMapView(frame: CGRect(x: 0, y: 84, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 84))
            mapView.delegate = self
            mapView.isMyLocationEnabled = true
            self.view.addSubview(mapView)
            mapChanged()
        } else {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        if !multiplayer {
            let controller = AlertViewController.initialize(message: "Be mindful of traffic, obstructions, and other hazards while playing PointRun!", buttonTitle: "Start game")
            present(controller, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if gameMode != .timed && !multiplayer {
            timerImage.removeFromSuperview()
            timerLabel.removeFromSuperview()
        }
    }
    
    @objc func decreaseTime() {
        defaults.set(defaults.double(forKey: PRAchievement.Addicted.rawValue) + 1, forKey: PRAchievement.Addicted.rawValue)
        defaults.set(defaults.double(forKey: timePlayedStatistic) + 1, forKey: timePlayedStatistic)
        
        if gameMode == .timed {
            let ssec = NSString(format: "%@%d", (sec > 9 ? "" : "0"), sec)
            timerLabel.text = NSString(format: "%d:%@", min, ssec) as String
            if sec > 0 {
                sec -= 1
            } else {
                if min > 0 {
                    sec = 59
                    min -= 1
                } else {
                    self.endGame(.timerDone)
                    timer.invalidate()
                }
            }
        }
    }
    
    @objc func backButton() {
        self.endGame(.menuExit)
    }
    
    @objc func mapChanged() {
        let mapType = defaults.double(forKey: "mapType")
        switch mapType {
        case 0:
            mapView.mapType = .normal
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        case 3:
            mapView.mapType = .terrain
        default:
            break
        }
    }
    
    @IBAction func menuButton(_ sender: AnyObject) {
        menuView = MenuView()
        menuView.viewController = self
        menuView.showSettings()
        self.view.addSubview(menuView)
        menuView.show()
    }
    
    func sendGameMode(gameMode gameType: PRGameMode) {
        gameMode = gameType
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        
        if lastLocation != nil {
            let distance = location.distance(from: lastLocation)
            defaults.set(distance + defaults.double(forKey: PRAchievement.MarathonMan.rawValue), forKey: PRAchievement.MarathonMan.rawValue)
            checkAchievement(.MarathonMan)
            defaults.set(defaults.double(forKey: metersTravelledStatistic) + distance, forKey: metersTravelledStatistic)
        }
        
        lastLocation = location
        
        if firstLocUpdate && !multiplayer {
            firstLocUpdate = false
            
            mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17.5)
            
            for _ in 0...39 {
                let lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                let lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                let value = Int(arc4random_uniform(10) + 1)
                let uuid = UUID().uuidString
                
                addPoint(mapView, latitude: lat, longitude: lon, value: value, uuid: uuid)
            }
        } else {
            for point in markers {
                let pointCoords = point.position
                let pointLoc = CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)
                let userLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if userLoc.distance(from: pointLoc) <= 7 {
                    if gameMode == .chance {
                        if arc4random_uniform(10) == 0 {
                            self.endGame(.poisonPin)
                            
                            defaults.set(defaults.double(forKey: PRAchievement.BadLuck.rawValue) + 1, forKey: PRAchievement.BadLuck.rawValue)
                            checkAchievement(PRAchievement.BadLuck)
                            
                            defaults.set(defaults.double(forKey: poisonPinsStatistic) + 1, forKey: poisonPinsStatistic)
                            
                            return
                        } else {
                            defaults.set(Double(points), forKey: PRAchievement.Evader.rawValue)
                            checkAchievement(PRAchievement.Evader)
                        }
                    }
                    
                    let pointsInAnnotation = Int((point.snippet!.components(separatedBy: " ")[0] as String))
                    self.points += pointsInAnnotation!
                    pointLabel.text = NSString(format: "%d %@", self.points, (self.points == 1 ? "Point" : "Points")) as String
                    removePoint(point.userData as! String, thisdevice: true)
                    
                    let lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    let lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    let value = Double(arc4random_uniform(10) + 1)
                    let uuid = UUID().uuidString
                    
                    addPoint(mapView, latitude: lat, longitude: lon, value: Int(value), uuid: uuid)
                    
                    if value == 10 {
                        defaults.set(defaults.double(forKey: PRAchievement.HatTrick.rawValue) + 1, forKey: PRAchievement.HatTrick.rawValue)
                        checkAchievement(PRAchievement.HatTrick)
                    } else {
                        defaults.set(0, forKey: PRAchievement.HatTrick.rawValue)
                    }
                    
                    defaults.set(defaults.double(forKey: pinsCollectedStatistic) + 1, forKey: pinsCollectedStatistic)
                    defaults.set(defaults.double(forKey: pointsEarnedStatistic) + value, forKey: pointsEarnedStatistic)
                }
            }
        }
    }
    
    func addPoint(_ map: GMSMapView, latitude lat: Double, longitude lon: Double, value: Int, uuid: String) {
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let point = GMSMarker(position: coordinates)
        point.appearAnimation = .pop
        let s = value == 1 ? "" : "s"
        point.snippet = "\(value) Point\(s)"
        point.map = map
        point.userData = uuid
        
        let colors = [UIColor(red: 0.88, green: 0.22, blue: 0.18, alpha: 1.00), UIColor(red: 0.88, green: 0.22, blue: 0.18, alpha: 1.00), UIColor(red: 0.88, green: 0.22, blue: 0.18, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.19, green: 0.78, blue: 0.41, alpha: 1.00), UIColor(red: 0.19, green: 0.78, blue: 0.41, alpha: 1.00), UIColor(red: 0.19, green: 0.78, blue: 0.41, alpha: 1.00)]
        point.icon = GMSMarker.markerImage(with: colors[value - 1])
        
        markers.append(point)
        
        print("Created \(value) points at \(lat), \(lon) with a UUID of \(uuid)")
    }
    
    func removePoint(_ uuid: String, thisdevice: Bool) {
        var i = 0
        for point in markers {
            if point.userData as! String == uuid {
                point.map = nil
                markers.remove(at: i)
                
                if thisdevice {
                    vibrate()
                }
            }
            i += 1
        }
    }
    
    func endGame(_ reason: PRGameEnd) {
        manager.stopUpdatingLocation()
        timer.invalidate()
        
        let alert = UIAlertController(title: "Game Over!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
            self.pop()
        }))
        
        switch reason {
        case .menuExit:
            self.navigationController?.popViewController(animated: true)
        case .timerDone:
            alert.message = "You have run out of time!"
            GCHelper.sharedInstance.reportLeaderboardIdentifier("mosttimedpoints", score: self.points)
        case .poisonPin:
            alert.message = "That pin was poisonous!"
        case .disconnect:
            alert.message = "Another player has been disconnected."
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (alertAction) -> Void in
                self.manager.startUpdatingLocation()
            }))
        case .error:
            alert.message = "An error has unexpectedly occured."
        case .multiplayerWin:
            alert.message = "You won!"
        case .multiplayerLoss:
            alert.message = "You lost."
        }
        
        alert.message? += "\nYour Score: \(points)"
        self.present(alert, animated: true, completion: nil)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}
