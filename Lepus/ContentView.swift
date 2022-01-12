//
//  ContentView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var stopwatchManager = StopwatchManager()
    
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
//to push info.plist
    var body: some View {
        
        ZStack{
            VStack{
                MapView(region: MKCoordinateRegion(center: stopwatchManager.locationManager.location.coordinate, span: span),lineCoordinates: stopwatchManager.lineCoordinates)
                VStack{
                    Text("Duration")
                        .font(Font.custom("Rubik-Regular", size:12))
                    Text(stopwatchManager.timeStr)
                        .font(Font.custom("Sansita-BoldItalic", size:60))
                }
                HStack(spacing:50){
                    VStack{
                        Text("Distance")
                            .font(Font.custom("Rubik-Regular", size:12))
                        Text("\(String(format: "%.2f", stopwatchManager.distance))km")
                            .font(Font.custom("Sansita-BoldItalic", size:32))
                    }
                    VStack{
                        Text("Avg Pace")
                            .font(Font.custom("Rubik-Regular", size:12))
                        Text("\(String(format: "%.2f", stopwatchManager.avePace))\"")
                            .font(Font.custom("Sansita-BoldItalic", size:32))
                    }
                }.padding(10)
                HStack(spacing: 55){
                    if stopwatchManager.mode == .stopped
                    {
                        Button(action:{self.stopwatchManager.start()}, label: {
                            Image("Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:70)
                                .padding(.trailing, 8)
                            Text("Lepus On")
                                .font(Font.custom("Sansita-BoldItalic", size:32))
                                .foregroundColor(Color.black)
                        })
                            .padding(20)
                            .frame(width: 350, height: 80)
                            .background(Color("AccentColor3"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .gray, radius: 4, x: 5, y: 5)
                    }
                    else if stopwatchManager.mode == .running
                    {
//                        Button(action:{self.stopwatchManager.start()}, label: {
//                            Image(systemName: "play.fill")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .aspectRatio(contentMode: .fit)
//                                .foregroundColor(Color("AccentColor2"))
//                                .padding(8)
//                        })
//                            .frame(width: 80, height: 80)
//                            .background(Color("AccentColor"))
//                            .clipShape(Circle())
                        
                        Button(action:{self.stopwatchManager.pause()
                            print("HI")
                        }, label: {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("AccentColor"))
                                .padding(8)
                        })
                            .frame(width: 80, height: 80)
                            .background(Color("AccentColor2"))
                            .clipShape(Circle())
                    }
                    else if stopwatchManager.mode == .paused{
                        Button(action:{self.stopwatchManager.start()}, label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("AccentColor2"))
                                .padding(8)
                        })
                            .frame(width: 80, height: 80)
                            .background(Color("AccentColor"))
                            .clipShape(Circle())
                        
                        Button(action:{self.stopwatchManager.stop()
                            print("HI")
                        }, label: {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("AccentColor"))
                                .padding(8)
                        })
                            .frame(width: 80, height: 80)
                            .background(Color("AccentColor2"))
                            .clipShape(Circle())
                    }
                }.padding(25)
            }
            .background(Color("BackgroundColor"))
        }
    }
}
//  var body: some View {
//      HStack {
//          MapView(
//          region: region,
//          lineCoordinates: lineCoordinates)
//        ).edgesIgnoringSafeArea(.all).onReceive(timer) { time in
//            print(latitude)
//            latitude += 0.001
//            longtitude -= 0.001
//            lineCoordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longtitude))
//
//          }
//      }
//  }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
