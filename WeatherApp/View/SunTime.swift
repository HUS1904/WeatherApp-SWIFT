import SwiftUI

struct SunTimeView: View {
    let weatherResponse: WeatherResponse

    var sunRise: Int { weatherResponse.current.sunrise ?? 0 }
    var sunSet: Int { weatherResponse.current.sunset ?? 0 }
    var timeZoneOffset: Int { weatherResponse.timezoneOffset }
    var currentTime: Int { Int(Date().timeIntervalSince1970) }

    var progress: Double {
        let totalDaylight = Double(sunSet - sunRise)
        if totalDaylight <= 0 { return 0 }
        let elapsedTime = Double(currentTime - sunRise)
        return max(0, min(elapsedTime / totalDaylight, 1))
    }

    var body: some View {
        HStack {
            VStack {
                Text(formatUnixTime(sunRise, timeZoneOffset))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating)
            }

            Spacer()

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 175, height: 8)
                        .foregroundColor(Color(red: 56/255, green: 56/255, blue: 56/255))

                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 175 * CGFloat(progress), height: 8)
                        .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                }
            }
            .frame(width: 175, height: 8)
            .shadow(radius: 5)

            Spacer()

            VStack {
                Text(formatUnixTime(sunSet, timeZoneOffset))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "moon.fill")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating)
            }
        }
        .padding()
    }
}
