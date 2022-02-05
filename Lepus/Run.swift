//
//  Run.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 20/1/22.
//

import Foundation

class Run : Identifiable, Codable{
    var id:String
    var name:String
    var date:Date
    var distance:Double
    var pace:Double
    var calories:Int
    var duration:String
    var url:String
    
    init(id:String, name:String, date:Date, distance:Double, pace:Double, calories:Int, duration:String, url:String){
        self.id = id
        self.name = name
        self.date = date
        self.distance = distance
        self.pace = pace
        self.calories = calories
        self.duration = duration
        self.url = url
    }
}
