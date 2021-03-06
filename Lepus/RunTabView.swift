//
//  ContentView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import SwiftUI
import MapKit


struct RunTabView: View {
    
    @ObservedObject var stopwatchManager = StopwatchManager()
    
    var span = MKCoordinateSpan(latitudeDelta: 0.00000001, longitudeDelta: 0.0000001)
    
    @State var selection: Int? = nil
    @State private var tabBar: UITabBar! = nil
    
    init(){
        print(selection)
    }
    
    var body: some View {
            ZStack{
                MapView(region: MKCoordinateRegion(center: stopwatchManager.locationManager.location.coordinate, span: span),lineCoordinates: stopwatchManager.lineCoordinates).ignoresSafeArea(edges: .top)
                VStack{
                    Spacer()
                    NavigationLink(destination: RunView()
                                    .onAppear { self.tabBar.isHidden = true }     // !!
                                    .onDisappear { self.tabBar.isHidden = false } , tag: 1, selection: $selection) {
                        Button(action:{
                            self.selection = 1
                        }, label: {
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
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    }
                }.padding(30).padding(.bottom, 30)
                .navigationBarTitle("", displayMode: .inline) //this must be empty
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }.background(TabBarAccessor { tabbar in   // << here !!
            self.tabBar = tabbar
            })
        }
    }

    struct RunTabView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                RunTabView()
            }
        }
    }

struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }

    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
            }
        }
    }
}
