//
//  ProfileView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 22/1/22.
//

import SwiftUI
import Firebase
import Kingfisher

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var showingImagePicker = false
    @State private var imageChanged = false
    @State private var inputImage: UIImage?
    @State private var height:String = ""
    @State private var weight:String = ""
    var gender = ["Male", "Female"]
    @State private var selectedGender = "Male"
    @State var url:URL? = Auth.auth().currentUser?.photoURL ?? URL(string: "")
    @ObservedObject var firebaseManager = FirebaseManager()
    @State var image:Image = Image("profileImg")
    
    init(){
        firebaseManager.getprofileDetails(id: Auth.auth().currentUser!.uid)
    }
    
    var body: some View {
        VStack(spacing:0){
            if(imageChanged){
                image.resizable().clipShape(Circle()).frame(width: 100.0, height: 100.0)
            }
            else{
                KFImage.url(url)
                    .placeholder{image}
                    .resizable()
                    .loadDiskFileSynchronously()
                    .cacheOriginalImage()
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in  }
                    .onFailure { error in }
                    .clipShape(Circle()).frame(width: 100.0, height: 100.0)
            }
            Button(action: {showingImagePicker = true}, label: {
                Text("Change profile image").padding().font(Font.custom("Rubik-Medium", size:16)).padding(.bottom, 20)
            })
            
            HStack(alignment:.center, spacing:10){
                Text("Name").padding(.leading,20)
                TextField("Name", text: $firebaseManager.name)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .foregroundColor(Color("AccentColor"))
                    .disableAutocorrection(true) .multilineTextAlignment(.trailing).padding(.trailing, 20)
                }
                .padding(.vertical,10)
                .background(Color.white)
            Divider()
            HStack(alignment:.center, spacing:10){
                Text("Gender").padding(.leading,20)
                Menu {
                    Picker("Please select your gender", selection: $firebaseManager.gender) {
                                    ForEach(gender, id: \.self) {
                                        Text($0).font(Font.custom("Rubik-Regular", size:18))
                                    }
                    }
                } label:{
                    Text(firebaseManager.gender)
                        .font(Font.custom("Rubik-Regular", size:18))
                }.frame(minWidth: 200, maxWidth: UIScreen.main.bounds.width, alignment: .trailing).padding(.trailing, 20)
            }
                .padding(.vertical,10)
                .background(Color.white).padding(.bottom,40)
            
            HStack(alignment:.center, spacing:10){
                Text("Height (M)").padding(.leading,20)
                TextField("Height", value: $firebaseManager.height, format: .number)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .foregroundColor(Color("AccentColor"))
                    .disableAutocorrection(true) .multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad)
                }
                .padding(.vertical,10)
                .background(Color.white)
            Divider()
            HStack(alignment:.center, spacing:10){
                Text("Weight (KG)").padding(.leading,20)
                Spacer()
                TextField("Weight", value: $firebaseManager.weight, format: .number)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .foregroundColor(Color("AccentColor"))
                    .disableAutocorrection(true).multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad
                    )
                }
                .padding(.vertical,10)
                .background(Color.white)
            
            Text("We will use these information to provide you with more accurate results").frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .center).multilineTextAlignment(.center).foregroundColor(Color("TextColor")).padding(.top, 30)
            Spacer()
        }.navigationBarTitleDisplayMode(.inline).navigationTitle("Edit Profile").toolbar {
            Button("Save") {
                print("Help tapped!")
                firebaseManager.updateProfile(weight: firebaseManager.weight, height: firebaseManager.height, name: firebaseManager.name, gender: firebaseManager.gender)
                if(imageChanged){
                    upload(imagetoUpload: inputImage!)
                }
                
                showingAlert = true
            }.alert("Profile updated", isPresented: $showingAlert) {
                Button("Ok", role: .none) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.background(Color("BackgroundColor")).fullScreenCover(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }.onChange(of: inputImage) { _ in loadImage() }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        imageChanged = true
        image = Image(uiImage: inputImage)
    }
    
    func upload(imagetoUpload: UIImage) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(UUID())")
        let firebaseManager = FirebaseManager()
    
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
                firebaseManager.updateProfilePic(url: url!)
                    })
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
