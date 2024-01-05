import Foundation
import SwiftUI

struct SessionDetailView: View {
    @ObservedObject var viewModel: SessionDetailViewModel
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {  // <- Align to the leading side
            Text("Profit/Loss")
            
            if viewModel.isEditing {
                TextField("", text: $viewModel.editedProfitLoss)
                    .font(.title3)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .frame(maxWidth: .infinity)
                    .keyboardType(.numbersAndPunctuation)
            } else {
                TextField("", text: $viewModel.editedProfitLoss)
                    .font(.title3)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .frame(maxWidth: .infinity)
                    .keyboardType(.numbersAndPunctuation)
                    .disabled(true)
            }
            
            Text("Notes")

            if viewModel.isEditing {
                TextEditor(text: $viewModel.editedNotes)
                    .font(.title3)
                    .padding()
                    .frame(height: 175) // fixed height when editing
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            } else {
                Text(viewModel.editedNotes)
                    .font(.title3)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            
            Text("Timestamp: \(viewModel.item.timestamp!, formatter: itemFormatter)")
                .padding(.top)
            
            if viewModel.isEditing {
                HStack {
                    Spacer()
                    Button("Save") {
                        if let _ = Double(viewModel.editedProfitLoss) {
                            viewModel.toggleEditing()
                        } else {
                            showAlert = true
                        }
                    }
                    .padding(.top)
                    Spacer()
                }
            }

        }
        .padding(.horizontal)  // <- Move the horizontal padding here
        .padding(.top)
        .navigationBarItems(trailing: Button(viewModel.isEditing ? "Done" : "Edit") {
            if viewModel.isEditing {  // Check if currently editing
                if let _ = Double(viewModel.editedProfitLoss) {
                    viewModel.toggleEditing()
                } else {
                    showAlert = true
                }
            } else {
                viewModel.toggleEditing()  // Simply toggle editing mode if not currently editing
            }
        })        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Input"),
                  message: Text("Profit and Loss must be a numeric value!"),
                  dismissButton: .default(Text("OK")))
        }
    }
}
