//
//  ViewController.swift
//  Nearby
//
//  Created by Aditya Narayan on 6/14/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        let pin = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2DMake(40.741314, -73.989889)
        pin.coordinate = coordinate
        pin.title = "TTT"
        pin.subtitle = "This is a place"
        self.mapView.addAnnotation(pin)
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func changeMapType(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .Standard
        case 1:
            self.mapView.mapType = .Hybrid
        case 2:
            self.mapView.mapType = .Satellite
        default:
            self.mapView.mapType = .Standard
        }
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        self.mapView.setRegion(region, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text!
        request.region = self.mapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler {(response, error) in
            guard let response = response else {
                print("Search error:\(error)")
                return
            }
            print(response)
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for item in response.mapItems {
                let pin = MKPointAnnotation()
                pin.coordinate = item.placemark.coordinate
                pin.title = item.name
                pin.subtitle = item.placemark.title!
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
