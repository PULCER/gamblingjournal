import Foundation
import CoreData
import SwiftUI


class ContentViewViewModel: ObservableObject {
    @Published var budget: String = ""
    @Published var profitLoss: String = ""
    @Published var notes: String = ""
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.budget = fetchBudget()
    }


    func saveBudget() {
        saveToCoreData(budget: self.budget)
    }


    func calculateBudgetRemaining(from items: FetchedResults<Item>) -> NSDecimalNumber {
        let earnings = calculateEarnings(from: items)
        let budgetDecimal = NSDecimalNumber(string: budget)
        if budgetDecimal == NSDecimalNumber.notANumber {
            return earnings
        }
        return earnings.adding(budgetDecimal)
    }
    
    func monthlyTotals(from items: FetchedResults<Item>) -> [Date: NSDecimalNumber] {
            let calendar = Calendar.current
            let grouped = Dictionary(grouping: items) { (item) -> Date in
                let components = calendar.dateComponents([.year, .month], from: item.timestamp!)
                return calendar.date(from: components)!
            }
            
            var monthlyTotals: [Date: NSDecimalNumber] = [:]
            
            for (key, value) in grouped {
                let total = value.reduce(NSDecimalNumber.zero) { (result, item) -> NSDecimalNumber in
                    return result.adding(item.profitLoss ?? NSDecimalNumber.zero)
                }
                monthlyTotals[key] = total
            }
            
            return monthlyTotals
        }
    
    func fetchBudget() -> String {
        let request = NSFetchRequest<Budget>(entityName: "Budget")
        let budgets = try? context.fetch(request)
        return budgets?.first?.budget ?? ""
    }

    func saveToCoreData(budget: String) {
        let request = NSFetchRequest<Budget>(entityName: "Budget")
        let existingBudgets = try? context.fetch(request)

        if let existingBudget = existingBudgets?.first {
            existingBudget.budget = budget
            existingBudget.timestamp = Date()
        } else {
            let newBudget = Budget(context: context)
            newBudget.budget = budget
            newBudget.timestamp = Date()
        }

        do {
            try context.save()
        } catch {
            print("Error saving budget to CoreData:", error)
        }
    }



    func addItem() {
        let newItem = Item(context: context)
        newItem.timestamp = Date()
        newItem.profitLoss = NSDecimalNumber(string: profitLoss)
        newItem.notes = notes

        do {
            try context.save()
            
            profitLoss = ""
            notes = ""

        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }


    func deleteItems(offsets: IndexSet, from items: [Item]) {
        offsets.map { items[$0] }.forEach(context.delete)

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }


    func calculateEarnings(from items: FetchedResults<Item>) -> NSDecimalNumber {
        var sum = NSDecimalNumber.zero
        for item in items {
            if let profitLoss = item.profitLoss {
                sum = sum.adding(profitLoss)
            }
        }
        return sum
    }
    
    func cumulativeEarnings(from items: FetchedResults<Item>) -> [NSDecimalNumber] {
        var sum = NSDecimalNumber.zero
        var results: [NSDecimalNumber] = []

        for item in items {
            if let profitLoss = item.profitLoss {
                sum = sum.adding(profitLoss)
            }
            results.append(sum)
        }
        return results
    }

}
