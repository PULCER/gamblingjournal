//
//  ItemListView.swift
//  gamblingjournal
//
//  Created by Anthony Howell on 9/6/23.
//

import SwiftUI
import CoreData

struct ItemListView: View {
    var items: FetchedResults<Item>
    var viewContext: NSManagedObjectContext
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(destination: SessionDetailView(item: item).environment(\.managedObjectContext, viewContext)) {
                    SessionRow(item: item)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .background(Color.clear)
        .listStyle(PlainListStyle())
    }
    
    private func deleteItems(offsets: IndexSet) {
        // Your delete code here
    }
}
