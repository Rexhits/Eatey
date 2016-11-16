//
//  Eat.swift
//  Eatey
//
//  Created by Alan Liu on 10/18/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

//
//  ViewController.swift
//  userLocation
//
//  Created by Sebastian Hette on 19.09.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class Eat: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var quitCurrentOrder: UIButton!
    @IBOutlet weak var startAnOrder: UIButton!
    @IBOutlet weak var newOrderView: UIView!
    var timer: Timer?
    let droppin = MKPointAnnotation()
    
    @IBAction func quitCurrentOrder(_ sender: Any) {
        self.view.viewWithTag(5)?.isHidden = true
        self.view.viewWithTag(10)?.isHidden = false
    }
    @IBAction func startAnOrder(_ sender: Any) {
        self.view.viewWithTag(5)?.isHidden = false
        self.view.viewWithTag(10)?.isHidden = true

    }
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    let locationManager = CLLocationManager()
    var myLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showDelivererLocation), userInfo: nil, repeats: true)
        map.addAnnotation(droppin)
        
        
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = true
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        pageControl.addTarget(self, action: #selector(Eat.didChangePageControlValue), for: .valueChanged)
        self.view.viewWithTag(5)?.isHidden = true
        self.view.viewWithTag(10)?.isHidden = false
        self.map.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
           self.tutorialPageViewController = tutorialPageViewController
       }
    }
    
    func showDelivererLocation() {
        if !delivererlocation.isEmpty {
            droppin.coordinate.latitude = delivererlocation[0]
            droppin.coordinate.longitude = delivererlocation[1]
        }
        
    }
    
    
    //Map Code
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func sendMessage(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "New Message!", message: "", preferredStyle: .alert)
        alertVC.addTextField {text in
            text.placeholder = "Enter your message here"
        }
        func okHandler(alert: UIAlertAction!) {
            // Do something...
            print("Chat!")
            let text = alertVC.textFields![0]
            if text.text != nil {
                SocketIOManager.sharedInstance.emit(event: "chat", message: text.text!)
            }
        }
        let action = UIAlertAction(title: "Send", style: .default, handler: okHandler)
        
        let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView()
//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }
//        else {
//            let point = MKPointAnnotation()
//            annotationView.annotation = point
//        }
//        
//        return annotationView
//    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        showDelivererLocation()
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        self.myLocation = location
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        map.setRegion(coordinateRegion, animated: true)
//        locationManager?.stopUpdatingLocation()
//        locationManager = nil
        
        
        map.showsUserLocation = true
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
    
    //PageViewCode
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

//Page View Extension
extension Eat: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}

    
    



