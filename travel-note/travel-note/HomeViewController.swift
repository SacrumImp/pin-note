//
//  HomeViewController.swift
//  travel-note
//
//  Created by Алексей Савельев on 26.10.2020.
//

import UIKit
import FirebaseAuth
import GoogleMaps

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    let lableVC: UILabel = {
        let lable = UILabel(frame:CGRect(x: 0, y: 50, width: 300, height: 50))
        lable.text = "MapVC" //STRINGS:
        lable.font = .systemFont(ofSize: 24, weight: .bold)
        lable.textAlignment = .center
        return lable
    }()
    
    let authentificationButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 180, y: 50, width: 300, height: 50))
        if FirebaseAuth.Auth.auth().currentUser != nil {
            button.setTitle("Выход", for: .normal) //STRINGS:
        }
        else{
            button.setTitle("Авторизация", for: .normal) //STRINGS:
        }
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    let testSettingsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 180, y: 100, width: 300, height: 50))
        button.setTitle("Настройки", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal) //красным чтоб заметно было
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        view.addSubview(getMapView())
        
        view.addSubview(lableVC)
        lableVC.center.x = self.view.center.x
        
        view.addSubview(authentificationButton)
        authentificationButton.addTarget(self, action: #selector(useAuthentification(sender:)), for: .touchUpInside)
        
        view.addSubview(testSettingsButton)
        testSettingsButton.addTarget(self, action: #selector(openSettings(sender:)), for: .touchUpInside)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    
    func getMapView() -> UIView{
        let latitude = 55.75
        let longitude = 37.62
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Ваше местоположение" //STRINGS:
        marker.map = mapView
        
        return mapView
    }
    
    
    @objc func useAuthentification(sender: UIButton) {
        
        if FirebaseAuth.Auth.auth().currentUser != nil{
            do{
                try FirebaseAuth.Auth.auth().signOut()
            }
            catch{
                print("Error sign out") //STRINGS:
            }
            print("Signed out")
            authentificationButton.setTitle("Авторизация", for: .normal)

        } else {
            let authentificationViewModel = AuthentificationViewModel()
            let authentificationView = Authentication_Phone()
            authentificationView.viewModel = authentificationViewModel
            authentificationView.modalTransitionStyle = .coverVertical
            authentificationView.modalPresentationStyle = .automatic
            self.present(authentificationView, animated: true)
        }
    }
    
    @objc func openSettings(sender: UIButton) {
        let settingsView = SettingsView()
        settingsView.modalTransitionStyle = .crossDissolve
        settingsView.modalPresentationStyle = .fullScreen
        self.present(settingsView, animated: true)
    }
}
