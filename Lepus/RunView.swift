//
//  RunTabView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 16/1/22.
//

import SwiftUI
import MapKit

struct RunView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    
    @ObservedObject var stopwatchManager = StopwatchManager()
    
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    var body: some View {
        VStack{
            MapView(region: MKCoordinateRegion(center: stopwatchManager.locationManager.location.coordinate, span: span),lineCoordinates: stopwatchManager.lineCoordinates).ignoresSafeArea(edges: .top).onAppear{
                stopwatchManager.start()
                print("initss")
            }
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
        
            if stopwatchManager.mode == .running{
                HStack(spacing: 55){
                    Button(action:{self.stopwatchManager.pause()}, label: {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:70)
                            .padding(.trailing, 8)
                        Text("Lepus OFF")
                            .font(Font.custom("Sansita-BoldItalic", size:32))
                            .foregroundColor(Color.black)
                    })
                        .padding(20)
                        .frame(width: 350, height: 80)
                        .background(Color("AccentColor3"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 4, x: 5, y: 5)
                }.padding(30)
            }
            else{
                HStack(spacing: 55){
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
                    
                    Button(action:{
                        showingAlert = true
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
                }.padding(30).alert("Do you want to end the run?", isPresented: $showingAlert) {
                    Button("No", role: .cancel) { }
                    Button("Yes", role: .none) {
                        self.stopwatchManager.stop()
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }
                }
            }
        }
        .background(Color("BackgroundColor"))
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
    }
}
