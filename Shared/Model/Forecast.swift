//
//  Forecast.swift
//  WeatherAppScrolling (iOS)
//
//
//  Created by Stavros Pachoundakis on 2022-01-04.
//

import SwiftUI

// Sample Model and ten days data....

struct DayForecast: Identifiable{
    var id = UUID().uuidString
    var day: String
    var farenheit: CGFloat
    var image: String
}

var forecast = [

    DayForecast(day: "Today", farenheit: 12,image: "cloud.rain"),
    DayForecast(day: "Wed", farenheit: 11,image: "cloud.rain"),
    DayForecast(day: "Tue", farenheit: 5,image: "cloud.sun.bolt"),
    DayForecast(day: "Thu", farenheit: 8,image: "sun.max"),
    DayForecast(day: "Fri", farenheit: 9,image: "cloud.rain"),
    DayForecast(day: "Sat", farenheit: 11,image: "cloud.rain"),
    DayForecast(day: "Sun", farenheit: 2,image: "cloud.rain"),
    DayForecast(day: "Mon", farenheit: 1,image: "sun.max"),
    DayForecast(day: "Tue", farenheit: 0,image: "cloud.rain"),
    DayForecast(day: "Wed", farenheit: 2,image: "cloud.sun"),
]
