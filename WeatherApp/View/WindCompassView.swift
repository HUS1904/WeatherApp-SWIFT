//
//  WindCompassView.swift
//  WeatherApp
//
//  Created by Hussein Jarrah on 30/03/2025.
//

import SwiftUI

struct WindCompassView: View {
    let direction: Double
    let frameSize: CGFloat = 120

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))

            Image("compassMarker")
                .resizable()
                .scaledToFit()
                .frame(width: frameSize * 0.08, height: frameSize * 0.8)
                .rotationEffect(Angle(degrees: direction - 180))
                .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)

            Circle()
                .fill(Color.black.opacity(0.15))
                .frame(width: frameSize / 2, height: frameSize / 2)

            VStack(spacing: 2) {
                Text(convertWindDirectionToCompassPoint(direction))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)

                Text("\(String(format: "%.0f", direction))°")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)
            }

            ForEach(CompassMarker.markers(), id: \.self) { marker in
                CompassMarkerView(marker: marker, compassDegrees: direction, frameSize: frameSize)
            }
        }
        .frame(width: frameSize, height: frameSize)
    }

    struct CompassMarker: Hashable {
        let degrees: Double
        let label: String

        init(degrees: Double, label: String = "") {
            self.degrees = degrees
            self.label = label
        }

        static func markers() -> [CompassMarker] {
            return [
                CompassMarker(degrees: 0, label: "N"),
                CompassMarker(degrees: 90, label: "E"),
                CompassMarker(degrees: 180, label: "S"),
                CompassMarker(degrees: 270, label: "W")
            ]
        }
    }

    struct CompassMarkerView: View {
        let marker: CompassMarker
        let compassDegrees: Double
        let frameSize: CGFloat

        var body: some View {
            VStack(spacing: 2) {
                Capsule()
                    .frame(width: 1.5, height: marker.label.isEmpty ? 4 : 6)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .padding(.bottom, marker.label.isEmpty ? -2 : -4)

                if !marker.label.isEmpty {
                    Text(marker.label)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .rotationEffect(labelRotation(for: marker.label))
                }

                Spacer(minLength: frameSize / 2)
            }
            .rotationEffect(Angle(degrees: marker.degrees))
        }

        private func labelRotation(for label: String) -> Angle {
            switch label {
            case "E":
                return Angle(degrees: -90)
            case "S":
                return Angle(degrees: -180)
            case "W":
                return Angle(degrees: 90)
            default:
                return Angle(degrees: 0)
            }
        }
    }

    private func convertWindDirectionToCompassPoint(_ degrees: Double) -> String {
        let directions = [
            "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
            "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"
        ]
        let index = Int((degrees + 11.25) / 22.5)
        return directions[index % 16]
    }
}

