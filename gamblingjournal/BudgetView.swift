import SwiftUI

struct BudgetView: View {
    @Binding var budget: String
        @State private var showingAddBudget = false
        @ObservedObject var contentViewViewModel: ContentViewViewModel

    var body: some View {
        VStack {
            Button("Add Budget") {
                showingAddBudget.toggle()
            }
            .sheet(isPresented: $showingAddBudget) {
                VStack {
                    TextField("Enter Budget", text: $budget)
                        .keyboardType(.numbersAndPunctuation)
                    Button("Save") {
                        contentViewViewModel.budget = budget
                        contentViewViewModel.saveBudget()
                        showingAddBudget = false
                    }
                    .padding()
                }
            }
        }
    }
}
