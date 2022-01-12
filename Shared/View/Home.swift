//
//  Home.swift
//  WeatherAppScrolling (iOS)
//
//  Created by Stavros Pachoundakis on 2022-01-04.
//

import SwiftUI
import SpriteKit
import CoreLocationUI

struct Home: View {
    var weather: ResponseBody

    @State var offset: CGFloat = 0
    var topEdge: CGFloat
    @EnvironmentObject var locationManagher: LocationManager
    @StateObject var locationMan = LocationManager()
    // to avoid early starting of landing animation...
    @State var showRain = false
    @State var isRaining = false
    @State var isSunny = false
    @State var isSnowing = false
    // were going to delay start it...
    
    var body: some View {
        
        ZStack{
            
            // Geometry Reader for getting height and width...
            GeometryReader{proxy in
                
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            // Blur Material...
       
            .overlay(.ultraThinMaterial)
            
            // Rain Fall View....
            // May be its a bug..
            // while scrolling it gets restarted....
            
            // to avoid..
            GeometryReader{_ in
                
                SpriteView(scene: RainFall(),options: [.allowsTransparency])

            }
            .ignoresSafeArea()
            .opacity(showRain ? 1 : 0)
            
            // Main View....
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    
                    // Weather Data...
                    VStack(alignment: .center, spacing: 5) {
//
//                        LocationButton(.shareCurrentLocation) {
//                            locationManagher.requestLocation()
//                        }
//                        .cornerRadius(30)
//                        .foregroundColor(.white)
//                        .symbolVariant(.fill)
//
                            
                        Text(weather.name)
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                        Text("\(weather.weather[0].main)")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
//                        Text("H:20˚L:-1˚")
                        Text("H:" + weather.main.tempMax.roundDouble() + "° L:" + weather.main.tempMin.roundDouble() + ("°"))
                            .foregroundStyle(.primary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                    }
                    .offset(y: -offset)
                    // For Bototm Drag Effect...
                    .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                    .offset(y: getTitleOffset())
                    
                    // Custom Data View...
                    VStack(spacing: 8){
                        
                        // Custom Stack....
                        CustomStackView {
                            
                            // Label Here....
                            Label {
                                
                                Text("Hourly Forecast")
                                
                            } icon: {
                                
                                Image(systemName: "clock")
                            }

                            
                        } contentView: {
                         
                            // Content...
  
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 15){
                                    
                                    ForecastView(time: "12 PM",celcius: 5,image: "cloud.bolt.rain")
                                    
                                    ForecastView(time: "1 PM",celcius: 7,image: "cloud.heavyrain")
                                    
                                    ForecastView(time: "2 PM",celcius: 8,image: "cloud.rain")
                                    
                                    ForecastView(time: "3 PM",celcius: 3,image: "cloud.sun.rain")
                                    
                                    ForecastView(time: "4 PM",celcius: 3,image: "cloud")
                                }
                            }
                        }
                        
                        WeatherDataView()

                    }
                    .background(
                        GeometryReader{_ in
                            
                            SpriteView(scene: RainFallLanding(),options: [.allowsTransparency])
                            .offset(y: UIScreen.main.bounds.height < 750 ? -12 : -10)

                        }
                            .offset(y: -(offset + topEdge) > 90 ? -(offset + (90 + topEdge)) : 0)
                            .opacity(showRain ? 1 : 0)
                        
                    )
                    .padding(.top,20)
                }
                .padding(.top,25)
                .padding(.top,topEdge)
                .padding([.horizontal,.bottom])
                // getting Offset....
                .overlay(
                
                    // Using Geometry Reader....
                    GeometryReader{proxy -> Color in
                    
                    let minY = proxy.frame(in: .global).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                        
                    }
                    
                    return Color.clear
                    
                    }
                )
            }
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                withAnimation{
                    showRain = true
                }
            }
        }
    }
    
    func getTitleOpactiy()->CGFloat{
        
        let titleOffset = -getTitleOffset()
        
        let progress = titleOffset / 20
        
        let opacity = 1 - progress
        
        return opacity
    }
    
    func getTitleOffset()->CGFloat{
        
        // setting one max height for whole title...
        // consider max as 120....
        if offset < 0{
            let progress = -offset / 120
            
            // since top padding is 25....
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            
            return -newOffset
        }
        
        return 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ForecastView: View {
    var time: String
    var celcius: CGFloat
    var image: String
    
    var body: some View {
        VStack(spacing: 15){
            
            Text(time)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Image(systemName: image)
                .font(.title2)
            // MultiColor...
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .white)
            // max Frame...
                .frame(height: 30)
            
            Text("\(Int(celcius))˚")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal,10)
    }
}

// going to create Rain/Snow Effect Like iOS 15 Weather App....
// Sprite Kit Rain SCene...
class RainFall: SKScene{
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        // anchor point..
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // bg Color...
        backgroundColor = .clear
        
        // creating node and adding to scene...
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        addChild(node)
        
        // Full width...
        node.particlePositionRange.dx = UIScreen.main.bounds.width
        
    }
}

// Next Rain Fall Landing Scene...
class RainFallLanding: SKScene{
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        // anchor point..
        let height = UIScreen.main.bounds.height
        // getting percentage by eminiationg postion range....
        anchorPoint = CGPoint(x: 0.5, y: (height - 5) / height)
        
        // bg Color...
        backgroundColor = .clear
        
        // creating node and adding to scene...
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        addChild(node)
        
        // Removed for card padding...
        node.particlePositionRange.dx = UIScreen.main.bounds.width - 30
        
    }
}
// Extension for rounded Double to 0 decimals
extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
