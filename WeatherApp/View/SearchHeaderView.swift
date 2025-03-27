import SwiftUI

struct SearchHeaderView: View {
    let dismiss: () -> Void

    var body: some View {
        HStack {
            Button(action: dismiss) {
                Image(systemName: "chevron.backward.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 27, height: 27)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color(red: 0.89, green: 0.14, blue: 0.42))
            }

            Spacer()

            Text("Saved Cities")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            // Dummy space to balance the back button width
            Image(systemName: "chevron.backward.square")
                .resizable()
                .opacity(0)
                .frame(width: 27, height: 27)
        }
        .padding(.top, 70)
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}
