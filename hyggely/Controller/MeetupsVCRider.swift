//
//  MeetupsVCRider.swift
//  hyggely
//
//  Created by Shamsheer on 2017-10-12.
//  Copyright © 2017 Shamsheer. All rights reserved.
//


import UIKit
import MapKit

class MeetupsVCRider: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, RiderController, UITableViewDelegate, UITableViewDataSource, FetchData  {
    
    
  //RIDER
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var callUberBtn: UIButton!
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
   
    //i want the driverlocations to be displayed here from driversRef
    private var driverLocation: CLLocationCoordinate2D?;
    
    private var timer = Timer();
    
    private var canCallUber = true;
    private var riderCanceledRequest = false;
    
    private var appStartedForTheFirstTime = true;
    private let CELL_ID = "Cell";
    private let CHAT_SEGUE = "ChatSegue";
    
    private var hosts = [Contact]();
    private var hostName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager();
        MeetupsHandlerRider.Instance.observeMessagesForRider();
        MeetupsHandlerRider.Instance.delegate = self;
        
        DBProvider.Instance.delegate = self;
        
        DBProvider.Instance.getContacts(isHost: false);
        
    }
    
    func dataReceived(contacts: [Contact]) {
        self.hosts = contacts;
        
        // get the name of current user
        for contact in contacts {
            if contact.id == AuthProvider.Instance.userID() {
                AuthProvider.Instance.userName = contact.name
            }
        }
        
        myTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath);
        
        cell.textLabel?.text = hosts[indexPath.row].name;
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //this is where the cell is selected [mapView selectAnnotation:foundAnnotation animated:YES];
/*
        let storyboardd : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboardd.instantiateViewController(withIdentifier: "BookVC") as! BookVC
        
        nextVC.imageURL = hosts[indexPath.row].url
        print(hosts[indexPath.row].name, hosts[indexPath.row].desc)
        nextVC.descr = hosts[indexPath.row].desc
        nextVC.name = hosts[indexPath.row].name
        nextVC.bought = "chat"
        print ("TRYING TO GET BOOK VC")
        self.present(nextVC, animated: false, completion: nil)*/
        updateDriversLocation(lat: hosts[indexPath.row].latLocation, long: hosts[indexPath.row].longLocation)
        hostName = hosts[indexPath.row].name
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            myMap.setRegion(region, animated: true);
            
            myMap.removeAnnotations(myMap.annotations);
            
            if driverLocation != nil {
                if !canCallUber {
                    let driverAnnotation = MKPointAnnotation();
                    driverAnnotation.coordinate = driverLocation!;
                    driverAnnotation.title = hostName;
                    
                    myMap.addAnnotation(driverAnnotation);
                  var driverAnnotationView =  mapView(mapView: myMap, viewForAnnotation: driverAnnotation)
                   driverAnnotationView?.image
                    // driverAnnoationView.
                }
            }
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = userLocation!;
            annotation.title = "Your Location";
            myMap.addAnnotation(annotation);
            
        }
        
    }
    
    @objc func updateRidersLocation() {
        MeetupsHandlerRider.Instance.updateRiderLocation(lat: userLocation!.latitude, long: userLocation!.longitude);
    }
    
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled {
            callUberBtn.setTitle("Cancel Hygge Request", for: UIControlState.normal);
            canCallUber = false;
        } else {
            callUberBtn.setTitle("Request Hygge", for: UIControlState.normal);
            canCallUber = true;
        }
    }
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        
        if !riderCanceledRequest {
            if requestAccepted {
                alertTheUser(title: "Hygge Request Accepted", message: "\(driverName) Accepted Your Hygge Request")
            } else {
                MeetupsHandlerRider.Instance.cancelUber();
                timer.invalidate();
                alertTheUser(title: "Hygge Request Canceled", message: "\(driverName) Canceled Hygge Request")
            }
        }
        riderCanceledRequest = false;
    }
    
    func updateDriversLocation(lat: Double, long: Double) {
        driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long);
    }
    
    @IBAction func callUber(_ sender: AnyObject) {
        if userLocation != nil {
            if canCallUber {
                MeetupsHandlerRider.Instance.requestUber(latitude: Double(userLocation!.latitude), longitude: Double(userLocation!.longitude))
                
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(MeetupsVCRider.updateRidersLocation), userInfo: nil, repeats: true);
                
            } else {
                riderCanceledRequest = true;
                MeetupsHandlerRider.Instance.cancelUber();
                timer.invalidate();
            }
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        if AuthProvider.Instance.logOut() {
            
            if !canCallUber {
                MeetupsHandlerRider.Instance.cancelUber();
                timer.invalidate();
            }
            
            dismiss(animated: true, completion: nil);
            
        } else {
            // problem with loging out
            alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment, please try again later");
        }
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "identifier") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}



