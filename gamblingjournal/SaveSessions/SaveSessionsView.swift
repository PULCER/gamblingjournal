import SwiftUI

struct SaveSessionsView: View {
    @ObservedObject var viewModel: SaveSessionsViewModel

    var body: some View {
        Button("Save Sessions to Text") {
            viewModel.saveToText()
        }
        .sheet(isPresented: $viewModel.showingExportSheet) {
            VStack {
                Text("Your Text Data:")
                TextEditor(text: $viewModel.exportedJSON)
                    .padding()
                Button("Copy to Clipboard") {
                    viewModel.copyToClipboard()
                }
            }
        }
    }
}
