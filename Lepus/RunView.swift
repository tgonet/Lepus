//
//  RunTabView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 16/1/22.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseStorage

struct RunView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @ObservedObject var stopwatchManager = StopwatchManager()
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    @State private var snapshotImage: UIImage? = nil
    
    var body: some View {
        ZStack {
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
                            generateSnapshot(width: 300, height: 300, lineCoord: stopwatchManager.lineCoordinates)
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
        }
    }
    
    func saveRun(duration:String, pace:Double, distance:Double, url:String, coord:CLLocationCoordinate2D){
        let user = Auth.auth().currentUser
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = "dd MMM YYYY H:mm a"
        let date = dateFormatter.string(from: Date())
        let myDict:[String: Any] = ["Duration":duration, "Pace":pace, "Distance":distance, "Startlatitude":"\(coord.latitude)", "Startlongitude":"\(coord.longitude)", "Url":url,  "Date": date, "userId":user!.uid]

        ref.child("Runs").childByAutoId().setValue(myDict)
        self.stopwatchManager.stop()
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    func generateSnapshot(width: CGFloat, height: CGFloat, lineCoord:[CLLocationCoordinate2D]) {
        // The region the map should display.
        let region = MKCoordinateRegion(
            center: self.stopwatchManager.locationManager.location.coordinate,
            span: self.span
        )

        // Map options.
        let mapOptions = MKMapSnapshotter.Options()
        let polyLine = MKPolyline(coordinates: lineCoord, count: lineCoord.count)


        mapOptions.region = region
        mapOptions.size = CGSize(width: width, height: height)
        mapOptions.showsBuildings = true

        // Create the snapshotter and run it.
        let snapshotter = MKMapSnapshotter(options: mapOptions)
        
        // Takes the screenshot of the map
        snapshotter.start { (snapshotOrNil, errorOrNil) in
            if let error = errorOrNil {
              print(error)
              return
            }
            if let snapshot = snapshotOrNil {
                drawLineOnImage(snapshot: snapshot, lineCoord: lineCoord)
            }
        }
    }
    
    func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot, lineCoord:[CLLocationCoordinate2D]){
        let image = snapshot.image
        let lineCoordinates = lineCoord
        
        // for Retina screen
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 300), true, 0)

        // draw original image into the context
        image.draw(at: CGPoint.zero)

        // get the context for CoreGraphics
        let context = UIGraphicsGetCurrentContext()

        // set stroking width and color of the context
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor.orange.cgColor)

        // Here is the trick :
        // We use addLine() and move() to draw the line, this should be easy to understand.
        // The diificult part is that they both take CGPoint as parameters, and it would be way too complex for us to calculate by ourselves
        // Thus we use snapshot.point() to save the pain.
        context!.move(to: snapshot.point(for: lineCoordinates[0]))
        for i in 0...lineCoordinates.count-1 {
          context!.addLine(to: snapshot.point(for: lineCoordinates[i]))
          context!.move(to: snapshot.point(for: lineCoordinates[i]))
        }

        // apply the stroke to the context
        context!.strokePath()

        // get the image from the graphics context
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        // end the graphics context
        UIGraphicsEndImageContext()
        //UIImageWriteToSavedPhotosAlbum(resultImage!, nil, nil, nil)
        upload(imagetoUpload: resultImage!, coord: lineCoord[0])
    }
    
    func upload(imagetoUpload: UIImage, coord:CLLocationCoordinate2D) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(UUID())")
    
        // Convert the image into JPEG and compress the quality to reduce its size
        let data = imagetoUpload.jpegData(compressionQuality: 0.2)
        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Upload the image
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                }
            
            // To get URL for display in run history
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                saveRun(duration: stopwatchManager.timeStr, pace: stopwatchManager.avePace, distance: stopwatchManager.distance, url: url!.absoluteString, coord: coord)
                    })
            }
        }
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
    }
}
