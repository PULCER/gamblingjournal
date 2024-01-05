import Foundation
import CoreData

class SessionDetailViewModel: ObservableObject {
    @Published var item: Item
    @Published var isEditing: Bool = false
    @Published var editedProfitLoss: String
    @Published var editedNotes: String
    private var viewContext: NSManagedObjectContext
    
    init(item: Item, context: NSManagedObjectContext) {
        self.item = item
        self.editedProfitLoss = item.profitLoss?.stringValue ?? ""
        self.editedNotes = item.notes ?? ""
        self.viewContext = context
    }
    
    func toggleEditing() {
        if isEditing {
            viewContext.performAndWait {
                item.profitLoss = NSDecimalNumber(string: editedProfitLoss)
                item.notes = editedNotes
                try? viewContext.save()
            }
        }
        isEditing.toggle()
    }
}
