//
//  ContentView.swift
//  BucketList
//
//  Created by Mehmet Alp Sönmez on 21/06/2024.
//


import MapKit
import SwiftUI

struct ContentView: View {
    let startPoisitin = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                ZStack(alignment: .bottomTrailing) {
                    Map(initialPosition: startPoisitin){
                        
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                            
                        }
                    }
                    .mapStyle(viewModel.standardView ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    Button( viewModel.standardView ? "Hybrid View" : "Standard View") {
                        viewModel.changeView()
                    }
                    .padding(.horizontal, 10)
                    .background(.red)
                    .foregroundStyle(.black)
                    .clipShape(.capsule)
                    .shadow(radius: 5)
                    .sheet(item: $viewModel.selectedPlace) { place  in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            
                .alert("Failed Authentication", isPresented: $viewModel.showFailedFaceIdAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("You cannot use the App without Authentication")
                }
        }
    }
    
}

#Preview {
    ContentView()
}
