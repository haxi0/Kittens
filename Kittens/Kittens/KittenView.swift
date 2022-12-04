//
//  KittenView.swift
//  Kittens
//
//  Created by Анохин Юрий on 03.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct KittenView: View {
    @ObservedObject var imageManager = ImageManager()
    @Environment(\.scenePhase) var scenePhase
    @State private var showingAlert = false
    @State private var fadeOut = false
    @State private var offline = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if imageManager.image != nil {
                    Image(uiImage: imageManager.image!)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(fadeOut ? 0 : 1) // Animation on background.
                        .animation(.easeInOut(duration: 0.25), value: fadeOut) // Animation on background.
                    
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all) // Blur effect.
                    
                    Image(uiImage: imageManager.image!)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                        .shadow(radius: 5)
                        .opacity(fadeOut ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: fadeOut) // Animation on background.
                        .onTapGesture {
                            self.fadeOut.toggle()
                            SDImageCache.shared.clearMemory() // Deletes cached random cat image.
                            SDImageCache.shared.clearDisk() // Deletes cached random cat image.
                            print("Loading...")
                            
                            DispatchQueue.main.async { // NEEDS to have some time to clear cached image.
                                self.imageManager.load(url: URL(string: "https://cataas.com/cat?height=350"))
                            }
                            
                            // Delayed appear.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.fadeOut.toggle()
                                    print("Done!")
                                }
                            }
                        }
                        .disabled(fadeOut)
                } else {
                    Button("Error occured! Click here to try to refresh") {
                        self.fadeOut.toggle()
                        SDImageCache.shared.clearMemory() // Deletes cached random cat image.
                        SDImageCache.shared.clearDisk() // Deletes cached random cat image.
                        print("Loading...")
                        
                        DispatchQueue.main.async { // NEEDS to have some time to clear cached image.
                            self.imageManager.load(url: URL(string: "https://cataas.com/cat?height=350"))
                            offline = false
                        }
                        
                        // Delayed appear.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.fadeOut.toggle()
                                print("Done!")
                            }
                        }
                    }
                    .disabled(fadeOut)
                    .padding()
                    .buttonStyle(untitledStyle())
                }
            }
            .onAppear {  // Loads the image on appear.
                if Reachability.isConnectedToNetwork() {
                    print("Connected to network! Loading...")
                    self.imageManager.load(url: URL(string: "https://cataas.com/cat?height=350"))
                    fadeOut = true
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in // After we are sure it loads we set off the timeout.
                        fadeOut = false
                        print("Done!")
                    }
                } else {
                    offline = true
                    print("Oh no! No connection!")
                }
            }
            .onChange(of: scenePhase) { newPhase in // If app has been opened after going into the background and so on.
                if newPhase == .active {
                    if Reachability.isConnectedToNetwork() {
                        print("Connected to network! Loading...")
                        self.imageManager.load(url: URL(string: "https://cataas.com/cat?height=350"))
                        fadeOut = true
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in // After we are sure it loads we set off the timeout.
                            fadeOut = false
                            print("Done!")
                        }
                    } else {
                        offline = true
                        print("Oh no! No connection!")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        UIImageWriteToSavedPhotosAlbum(imageManager.image!, nil, nil, nil)
                        showingAlert = true
                        print("Saved to photos!")
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .disabled(fadeOut)
                    .disabled(offline)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Success!"), message: Text("The image has been saved to your photo gallery."), dismissButton: .default(Text("Nice!")))
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct KittenView_Previews: PreviewProvider {
    static var previews: some View {
        KittenView()
    }
}
