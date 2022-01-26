//
//  NetworkManager.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 25/1/22.
//

import Foundation
import Network


class NetworkManager : ObservableObject{
    let monitor = NWPathMonitor()
    @Published var isConnected = false
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    init(){
        monitor.pathUpdateHandler = { path in
            if path.usesInterfaceType(.wifi) || path.usesInterfaceType(.cellular){
                if path.status == .satisfied {
                    self.isConnected = true
                    print("We're connected!")
                } else {
                    self.isConnected = false
                    print("No connection.")
                }
            }
        }
        monitor.start(queue: queue)
    }
}
