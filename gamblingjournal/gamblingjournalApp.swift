//
//  gamblingjournalApp.swift
//  gamblingjournal
//
//  Created by Anthony Howell on 9/6/23.
//

import SwiftUI

@main
struct gamblingjournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
