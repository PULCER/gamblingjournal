import SwiftUI

struct SettingsView: View {
    @ObservedObject var saveSessionsViewModel: SaveSessionsViewModel
    @ObservedObject var loadSessionsViewModel: LoadSessionsViewModel
    @ObservedObject var contentViewViewModel: ContentViewViewModel
    @Binding var budget: String

    @State private var showingAddBudget: Bool = false
    @State private var showingInvalidInputAlert: Bool = false

    var isBudgetValid: Bool {
        return Double(budget) != nil
    }

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)

            Button("Add Budget") {
                showingAddBudget.toggle()
            }
            .padding()

            SaveSessionsView(viewModel: saveSessionsViewModel)
                .padding()

            LoadSessionsView(viewModel: loadSessionsViewModel)
                .padding()

        }
        .padding()
        .sheet(isPresented: $showingAddBudget) {
            VStack {
                TextField("Enter Budget", text: $budget)
                    .keyboardType(.numbersAndPunctuation)
                Button("Save") {
                    if isBudgetValid {
                        contentViewViewModel.budget = budget
                        contentViewViewModel.saveBudget()
                        budget = ""
                        showingAddBudget = false
                    } else {
                        showingInvalidInputAlert = true
                    }
                }
                .alert(isPresented: $showingInvalidInputAlert) {
                    Alert(title: Text("Invalid Input"),
                          message: Text("Please enter a valid numeric value for the budget."),
                          dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
    }
}


