import Foundation

class BudgetViewModel: ObservableObject {
    @Published var budget: String = ""
    
    init() {
        if let savedBudget = UserDefaults.standard.string(forKey: "userBudget") {
            self.budget = savedBudget
        }
    }
    
    func saveBudget() {
        UserDefaults.standard.set(budget, forKey: "userBudget")
    }
}

