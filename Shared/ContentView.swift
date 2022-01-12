//
//  ContentView.swift
//  Shared
//
//  Created by Stavros Pachoundakis on 2022-01-04.
//

import SwiftUI
import CoreLocationUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    var body: some View {
        
        // Since WIndow is Decrepted in iOS 15....
        // Getting Safe area using Geometry Reader...
        GeometryReader{ proxy in
         
            let topEdge = proxy.safeAreaInsets.top
            if let location = locationManager.location {
                if let weather = weather {
                    Home(weather: weather, topEdge: topEdge)
                        .ignoresSafeArea(.all, edges: .bottom)
                    
                    
                    
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
      
            } else {
                
                if locationManager.isLoading {
                    LoadingView()
                } else {
            TabBar()
                    .environmentObject(locationManager)
                }
            }
                
            }
        .background (
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            
            .ignoresSafeArea()
            // Blur Material...
       
            .overlay(.ultraThinMaterial)
            }
        )

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
