import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showingAddSession = false
    @State private var showingCalculateEarnings = false
    @State private var showingAddBudget = false
    @State private var showingSettings: Bool = false
    @State private var showingChart = false
    @State private var expandedMonths: Set<Date> = []
    @State private var showAlert: Bool = false

    
    private var groupedSessions: [Date: [Item]] {
          let calendar = Calendar.current
          return Dictionary(grouping: items) { (item) -> Date in
              let components = calendar.dateComponents([.year, .month], from: item.timestamp!)
              return calendar.date(from: components)!
          }
      }
    
    var monthlyTotals: [Date: NSDecimalNumber] {
            contentViewViewModel.monthlyTotals(from: items)
        }
    
    
    @StateObject private var loadSessionsViewModel = LoadSessionsViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject private var contentViewViewModel = ContentViewViewModel(context: PersistenceController.shared.container.viewContext)
    
    var body: some View {
            NavigationView {
                ZStack{
                    VStack {
                        List {
                               ForEach(groupedSessions.keys.sorted(), id: \.self) { month in
                                   Section(header:
                                       HStack {
                                       Text(month, formatter: onlyMonthYearFormatter)
                                           Spacer()
                                       Text(currencyFormatter.string(from: monthlyTotals[month] ?? 0) ?? "N/A")
                                           .font(.title3)
                                               .foregroundColor(monthlyTotals[month]?.doubleValue ?? 0 > 0 ? .green : .red)
                                               .padding(5)
                                               .background(monthlyTotals[month]?.doubleValue ?? 0 > 0 ? Color.green.opacity(0.4) : Color.red.opacity(0.4))
                                               .cornerRadius(5)
                                           Image(systemName: expandedMonths.contains(month) ? "chevron.up" : "chevron.down")
                                       }
                                       .contentShape(Rectangle())
                                       .onTapGesture {
                                           if expandedMonths.contains(month) {
                                               expandedMonths.remove(month)
                                           } else {
                                               expandedMonths.insert(month)
                                           }
                                       }
                                   ){
                                                    if expandedMonths.contains(month) {
                                                        ForEach(groupedSessions[month]!) { item in
                                                            NavigationLink(destination: SessionDetailView(viewModel: SessionDetailViewModel(item: item, context: viewContext))) {
                                                                HStack {
                                                                    Text("Session at \(item.timestamp!, formatter: onlyDateFormatter)")
                                                                    Spacer()
                                                                    Text(currencyFormatter.string(from: item.profitLoss ?? 0) ?? "N/A")
                                                                        .foregroundColor(item.profitLoss?.doubleValue ?? 0 > 0 ? .green : .red)
                                                                        .padding(5)
                                                                        .background(item.profitLoss?.doubleValue ?? 0 > 0 ? Color.green.opacity(0.4) : Color.red.opacity(0.4))
                                                                        .cornerRadius(5)
                                                                }
                                                            }
                                                        }
                                                        .onDelete { offsets in
                                                            let itemsForMonth = Array(groupedSessions[month]!)
                                                            contentViewViewModel.deleteItems(offsets: offsets, from: itemsForMonth)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .background(Color.clear)
                                        .listStyle(GroupedListStyle())
                        .navigationBarItems(leading: NavigationLink(destination:
                                SettingsView(
                                    saveSessionsViewModel: SaveSessionsViewModel(items: Array(items)),
                                    loadSessionsViewModel: loadSessionsViewModel,
                                    contentViewViewModel: contentViewViewModel, // Non-binding argument
                                    budget: $contentViewViewModel.budget  // Binding argument
                                )) {
                                Text("Settings")
                        })

                        Spacer() 

                        HStack {
                            Button("Chart") {
                                showingChart.toggle()
                            }
                            .sheet(isPresented: $showingChart) {
                                LineChartView(data: contentViewViewModel.cumulativeEarnings(from: items))
                            }
                            .padding()
                            
                            Spacer()
                            
                            Button("Calculate Earnings") {
                                showingCalculateEarnings.toggle()
                            }.padding()
                        .sheet(isPresented: $showingCalculateEarnings) {
                            VStack {
                                Text("Total Earnings: \(contentViewViewModel.calculateEarnings(from: items).stringValue)")
                                    .font(.largeTitle)
                                    .padding()
                                if contentViewViewModel.calculateBudgetRemaining(from: items) != contentViewViewModel.calculateEarnings(from: items) {
                                    Text("Budget Remaining: \(contentViewViewModel.calculateBudgetRemaining(from: items).stringValue)")
                                        .font(.title)
                                        .padding()
                                }
                            }
                        }
                        }
    
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button("Add Session") {
                            showingAddSession.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingAddSession) {
                    VStack(alignment: .leading) {  // Outer VStack with leading alignment
                        Text("Profit/Loss")
                        TextField("", text: $contentViewViewModel.profitLoss)
                            .font(.title2)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .frame(maxWidth: .infinity)
                            .keyboardType(.numbersAndPunctuation)
                        
                        Text("Notes")
                        TextEditor(text: $contentViewViewModel.notes)
                            .font(.title2)
                            .frame(height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        
                        HStack {  // HStack with Spacers to center-align the Save button
                                    Spacer()
                                    Button("Save") {
                                        if let _ = Double(contentViewViewModel.profitLoss) {
                                            contentViewViewModel.addItem()
                                            showingAddSession = false
                                        } else {
                                            showAlert = true
                                        }
                                    }
                                    Spacer()
                                }
                            }
                    .padding(.horizontal)  // Horizontal padding for the whole VStack
                    .padding(.vertical)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Input"),
                              message: Text("Profit and Loss must be a numeric value!"),
                              dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
