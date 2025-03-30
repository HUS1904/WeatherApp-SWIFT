import SwiftUI

struct SearchBarView: View {
    @Binding var searchQuery: String
    @FocusState var isSearchFieldFocused: Bool
    @Binding var showCancelButton: Bool
    let onSearchChanged: (String) -> Void
    let onClearSearch: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.leading, 12)

                ZStack(alignment: .leading) {
                    if searchQuery.isEmpty {
                        Text("Search for a city")
                            .foregroundColor(.white.opacity(0.6))
                    }

                    TextField("", text: $searchQuery)
                        .foregroundColor(.white)
                        .padding(10)
                        .tint(Color(red: 0.89, green: 0.14, blue: 0.42))
                        .focused($isSearchFieldFocused)
                        .onChange(of: searchQuery) { _, newValue in
                            onSearchChanged(newValue)
                        }
                }
            }
            .frame(height: 50)
            .background(Color(red: 56/255, green: 56/255, blue: 56/255))
            .cornerRadius(15)
            .animation(.easeInOut(duration: 0.25), value: isSearchFieldFocused)

            if showCancelButton {
                Button(action: {
                    isSearchFieldFocused = false
                    searchQuery = ""
                    onClearSearch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white, Color(red: 0.89, green: 0.14, blue: 0.42))
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.25), value: showCancelButton)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}
