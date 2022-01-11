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
    var sec = "0"
    var min = "0"
    var hr = "0"
    var calSec:Int?
    var calMin:Int?
    var calHr:Int?
    @Published var timeStr = "00:00:00"
    @Published var mode: stopWatchMode = .stopped
    var timer = Timer()
    var latitude = 37.330828
    var longtitude = -122.007495
    
    @Published var lineCoordinates:[CLLocationCoordinate2D] = []
    
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
            self.latitude += 0.001
            self.longtitude -= 0.001
            self.lineCoordinates.append(CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longtitude))
            
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
}

enum stopWatchMode {
    case running
    case stopped
    case paused
}

