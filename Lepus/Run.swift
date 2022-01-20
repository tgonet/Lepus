//
//  Run.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 20/1/22.
//

import Foundation

class Run : Identifiable{
    let id = UUID()
    var name:String
    var date:String
    var distance:Double
    var pace:Double
    var duration:String
    var url:String
    
    init(name:String, date:String, distance:Double, pace:Double, duration:String, url:String){
        self.name = name
        self.date = date
        self.distance = distance
        self.pace = pace
        self.duration = duration
        self.url = url
    }
    
}
