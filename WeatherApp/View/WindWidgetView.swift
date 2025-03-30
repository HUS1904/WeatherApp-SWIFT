//
//  WindWidgetView.swift
//  WeatherApp
//
//  Created by Hussein Jarrah on 30/03/2025.
//

import SwiftUI

struct WindWidgetView: View {
    let weatherResponse: WeatherResponse

    var windSpeed: Double {
        weatherResponse.hourly?.first?.windSpeed ?? 0.0
    }
    var windGust: Double {
        weatherResponse.hourly?.first?.windGust ?? 0.0
    }
    var windDirection: Int {
        weatherResponse.hourly?.first?.windDeg ?? 0
    }


    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "wind")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(red: 0.89, green: 0.14, blue: 0.42))

                    Text("WIND")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Wind")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(String(format: "%.1f", windSpeed)) m/s")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }.padding(.top, 10)

                    Divider()
                        .background(Color.white.opacity(0.3))

                    HStack(spacing: 4) {
                        Text("Wind Gust")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(String(format: "%.1f", windGust)) m/s")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Divider()
                        .background(Color.white.opacity(0.3))

                    HStack(spacing: 4) {
                        Text("Wind Direction")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(windDirection)°")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }

            Spacer()

            // Placeholder for CompassView, implementation later
            WindCompassView(direction: Double(windDirection))
                .frame(width: 120, height: 80)
        }
        .padding(16)
        .background(Color(red: 56/255, green: 56/255, blue: 56/255))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

