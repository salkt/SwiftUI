//
//  DataView.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import SwiftUI
import CoreData

struct DefaultDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ViewModel
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]
        )
    var items: FetchedResults<Item>
    @AppStorage("lucky_count") var lucky_count = 0
    @AppStorage("unlucky_count") var unlucky_count = 0
    var body: some View {
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
}

struct DefaultDataView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultDataView(viewModel: ViewModel())
    }
}
