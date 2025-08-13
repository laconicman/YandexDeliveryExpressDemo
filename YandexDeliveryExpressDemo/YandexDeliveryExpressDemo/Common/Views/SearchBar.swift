import SwiftUI

struct SearchBar: View {
    @Binding private(set) var text: String
    @State private var isEditing = false
        
    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .textInputAutocapitalization(.never)
                .padding()
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                                
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                        }
                    }
                )
                .onTapGesture {
                    isEditing = true
                }
            
            if isEditing {
                Button {
                    isEditing = false
                    text = ""
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Text("Cancel")
                }
                .padding(.trailing)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    SearchBar(text: $text)
}
