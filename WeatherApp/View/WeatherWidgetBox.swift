import SwiftUI

struct WeatherWidgetBox<Content: View>: View {
    let iconName: String
    let title: String
    let content: Content

    init(iconName: String, title: String, @ViewBuilder content: () -> Content) {
        self.iconName = iconName
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon + Title
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(red: 0.89, green: 0.14, blue: 0.42))

                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }

            content

            Spacer(minLength: 0) // Pushes content upward consistently
        }
        .padding(.init(top: 16, leading: 0, bottom: 16, trailing: 16))
        .frame(width: 180, height: 160)
        .background(Color(red: 56/255, green: 56/255, blue: 56/255))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}
