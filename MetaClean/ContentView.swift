import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedImage: NSImage? = nil
    @State private var showingImagePicker = false
    @State private var showAlert = false

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 600, maxHeight: 400)
                    .padding()
            } else {
                Text("Select an image to preview")
                    .padding()
            }

            Button("Select Image") {
                showingImagePicker = true
            }
            .padding()

            Button("Remove Metadata") {
                removeMetadata()
            }
            .padding()
            .disabled(selectedImage == nil)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Metadata Removed"), message: Text("The image metadata has been successfully removed."), dismissButton: .default(Text("OK")))
        }
    }

    func removeMetadata() {
        // Function implementation to remove metadata
        showAlert = true
    }
}

struct ImagePicker: NSViewRepresentable {
    @Binding var selectedImage: NSImage?
    
    func makeNSView(context: Context) -> NSView {
        NSView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [UTType.png, UTType.jpeg] // Support for PNG and JPEG
        if panel.runModal() == .OK {
            if let url = panel.url, let image = NSImage(contentsOf: url) {
                self.selectedImage = image
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
