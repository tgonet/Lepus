//
//  StopwatchManager.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import Foundation
import SwiftUI
import MapKit

class StopwatchManager : ObservableObject{
    @Published var secondsElapsed = 0
    var doubleTime = 0.0
    var sec = "0"
    var min = "0"
    var hr = "0"
    var calSec:Int?
    var calMin:Int?
    var calHr:Int?
    @Published var timeStr = "00:00:00"
    @Published var avePaceStr = "0:00"
    @Published var mode: stopWatchMode = .onLoad
    var timer = Timer()
    @Published var lineCoordinates:[CLLocationCoordinate2D] = []
    @Published var distance = 0.00
    @Published var avePace = 0.00
    var location:CLLocation? = nil
    var locationManager : LocationManager = LocationManager()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsElapsed += 1
            
            self.calSec = self.secondsElapsed % 60
            self.sec = self.calSec! > 0 ? String(format: "%02d", self.calSec!) : "00"
            
            self.calMin = (self.secondsElapsed % 3600) / 60
            self.min = self.calMin! > 0 ? String(format: "%02d", self.calMin!) : "00"
            
            self.calHr = self.secondsElapsed / 3600
            self.hr = self.calHr! > 0 ? String(format: "%02d", self.calHr!) : "00"
            
            self.timeStr = "\(self.hr):\(self.min):\(self.sec)"
            
            if(self.lineCoordinates.count > 0){
                self.distance += (self.lineCoordinates.last?.distance(from: CLLocationCoordinate2D(latitude: self.locationManager.location.coordinate.latitude, longitude: self.locationManager.location.coordinate.longitude)) ?? 0.00) / 1000
            }
            
            self.lineCoordinates.append(CLLocationCoordinate2D(latitude: self.locationManager.location.coordinate.latitude, longitude: self.locationManager.location.coordinate.longitude))
            
            self.doubleTime = Double(self.secondsElapsed)
            self.avePace = ((self.doubleTime / 60) / self.distance).isInfinite ? 0.00 : (self.doubleTime / 60) / self.distance
            //self.avePaceStr = "\(Int(self.avePace)):\(self.avePace - Int(self.avePace))"
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        self.sec = "00"
        self.min = "00"
        self.hr = "00"
        self.avePace = 0.00
        self.distance = 0.00
        self.lineCoordinates = []
        self.timeStr = "\(self.hr):\(self.min):\(self.sec)"
        mode = .stopped
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
}

enum stopWatchMode {
    case onLoad
    case running
    case stopped
    case paused
}

extension CLLocationCoordinate2D {
    /// Returns distance from coordianate in meters.
    /// - Parameter from: coordinate which will be used as end point.
    /// - Returns: Returns distance in meters.
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}

