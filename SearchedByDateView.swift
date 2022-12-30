//
//  SearchedDataView.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import SwiftUI
import CoreData

struct SearchedByDateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ViewModel
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]
    )
    var items: FetchedResults<Item>
    @AppStorage("lucky_count") var lucky_count = 0
    @AppStorage("unlucky_count") var unlucky_count = 0
    @State var searchText: String = ""
    @State var fromDate: Date = Date()
    @State var toDate: Date = Date()
    @State var value: Int
    var body: some View {
        NavigationView{
            List{
                ForEach(items){item in
                    VStack{
                        Text(item.memo! == "" ? "No Title" : item.memo!)
                            .font(.title)
                            .fontWeight(.ultraLight)
                        HStack{
                            Text(item.timestamp ?? Date(), style: .date)
                                .fontWeight(.ultraLight)
                            Text(item.timestamp ?? Date(), style: .time)
                                .fontWeight(.ultraLight)
                            Text(item.is_lucky == true ? "lucky" : "unlucky")
                        }
                    }
                    .foregroundColor(.primary)
                }
                .onDelete(perform: deleteItem)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "search")
        .onChange(of: searchText) {newValue in
            search(text: newValue)
        }
        .onAppear{
            if value == 0 {
                calcTodayData()
            }
            else if value == 1{
                calcYesterdayDate()
            }
            else{
                calcThisweekDate()
            }
            searchByDate()
        }
    }
    
    func deleteItem(offsets: IndexSet){
        for index in offsets{
            if items[index].is_lucky == true {
                lucky_count -= 1
            }
            else{
                unlucky_count -= 1
            }
            viewContext.delete(items[index])
        }
        try? viewContext.save()
    }
    
    func calcTodayData(){
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let DC = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        fromDate = calendar.date(from: DateComponents(year: DC.year, month: DC.month, day: DC.day, hour: 0, minute: 0))!
        toDate = now
    }
    
    func calcYesterdayDate(){
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let DC = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        fromDate = calendar.date(from: DateComponents(year: DC.year, month: DC.month, day: DC.day!-1, hour: 0, minute: 0))!
        toDate = calendar.date(from: DateComponents(year: DC.year, month: DC.month, day: DC.day!, hour: 0, minute: 0))!
    }
    
    func calcThisweekDate(){
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let DC = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        fromDate = calendar.date(from: DateComponents(year: DC.year, month: DC.month, day: DC.day!-7, hour: 0, minute: 0))!
        toDate = now
    }
    
    func search(text: String) {
        let datePredicate: NSPredicate = NSPredicate(format: "timestamp BETWEEN {%@, %@}", fromDate as CVarArg, toDate as CVarArg)
        if text.isEmpty {
            items.nsPredicate = nil
            items.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [datePredicate])
        } else {
            let memoPredicate: NSPredicate = NSPredicate(format: "memo contains %@", text)
            items.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [memoPredicate])
        }
    }
    
    func searchByDate(){
        let datePredicate: NSPredicate = NSPredicate(format: "timestamp BETWEEN {%@, %@}", fromDate as CVarArg, toDate as CVarArg)
        items.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [datePredicate])
    }
}

struct SearchedByDateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedByDateView(viewModel: ViewModel(), value: 0)
    }
}
