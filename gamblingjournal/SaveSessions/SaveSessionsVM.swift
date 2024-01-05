import SwiftUI
import CoreData

class SaveSessionsViewModel: ObservableObject {
    var items: [Item]
    @Published var exportedJSON: String = ""
    @Published var showingExportSheet: Bool = false

    
    init(items: [Item]) {
        self.items = items
    }

    func saveToText() {
        self.exportedJSON = exportData(items: self.items)
        self.showingExportSheet.toggle()
    }

    func copyToClipboard() {
        UIPasteboard.general.string = self.exportedJSON
        self.showingExportSheet = false
    }
    
    private func exportData(items: [Item]) -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let codableItems = items.map { CodableItem(notes: $0.notes, profitLoss: $0.profitLoss?.stringValue, timestamp: $0.timestamp) }

        do {
            let jsonData = try encoder.encode(codableItems)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error exporting data: \(error.localizedDescription)")
        }
        return ""
    }
}

