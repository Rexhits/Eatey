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
        self.map.delegate = self    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
           self.tutorialPageViewController = tutorialPageViewController
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        else {
            let point = MKPointAnnotation()
            annotationView.annotation = point
        }
        
        return annotationView
    }
    
    func showLocation(latitude: Double, longitude: Double) {
        let droppin = MKPointAnnotation()
        droppin.coordinate.latitude = latitude
        droppin.coordinate.longitude = longitude
        map.addAnnotation(droppin)
        if myLocation != nil {
            let center = CLLocationCoordinate2DMake((myLocation!.coordinate.latitude + latitude) / 2, (myLocation!.coordinate.longitude + longitude) / 2)
            let span = MKCoordinateSpanMake(abs(myLocation!.coordinate.latitude - latitude) + 0.01, abs(myLocation!.coordinate.longitude - longitude) + 0.01)
            let region = MKCoordinateRegionMake(center, span)
            map.setRegion(region, animated: true)
        }
    }
    
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

    
    


