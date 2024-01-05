import SwiftUI
import CoreData


// LoadSessionsView.swift
struct LoadSessionsView: View {
    @ObservedObject var viewModel: LoadSessionsViewModel

    var body: some View {
        Button("Load Sessions from Text") {
            viewModel.toggleImportSheet()
        }
        .sheet(isPresented: $viewModel.showingImportSheet) {
            VStack {
                Text("Paste your Text Data:")
                TextEditor(text: $viewModel.importedJSON)
                    .padding()
                Button("Import Data") {
                    viewModel.importData()
                }
            }
        }
    }
}

