//
//  LoadSessionsVM.swift
//  gamblingjournal
//
//  Created by Anthony Howell on 9/19/23.
//

import Foundation
import CoreData

// LoadSessionsViewModel.swift
class LoadSessionsViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext

    // Use @Published for properties the View should listen to.
    @Published var importedJSON: String = ""
    @Published var showingImportSheet = false

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func importData() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let jsonData = importedJSON.data(using: .utf8) {
            do {
                let codableItems = try decoder.decode([CodableItem].self, from: jsonData)
                
                for codableItem in codableItems {
                    let newItem = Item(context: viewContext)
                    newItem.notes = codableItem.notes
                    newItem.profitLoss = NSDecimalNumber(string: codableItem.profitLoss)
                    newItem.timestamp = codableItem.timestamp
                }
                
                try viewContext.save()
                // Reset after import
                importedJSON = ""
                showingImportSheet = false
            } catch {
                print("Error importing data: \(error.localizedDescription)")
            }
        }
    }

    func toggleImportSheet() {
        showingImportSheet.toggle()
    }
}
