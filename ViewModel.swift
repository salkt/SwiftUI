//
//  ViewModel.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import Foundation
import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    @AppStorage("lucky_count") var lucky_count = 0
    @AppStorage("unlucky_count") var unlucky_count = 0
    @Published var memo: String = ""
    @Published var is_lucky: Bool = false
    @Published var timestamp: Date = Date()
    @Published var isNewData = false
    @Published var updateItem: Item!
    
    func writeData(context: NSManagedObjectContext){
        if updateItem != nil {
            updateItem.timestamp = timestamp
            updateItem.is_lucky = is_lucky
            updateItem.memo = memo
            
            try! context.save()
            
            updateItem = nil
            isNewData.toggle()
            memo = ""
            timestamp = Date()
            return
        }
        
        let newItem = Item(context: context)
        newItem.timestamp = timestamp
        newItem.memo = memo
        newItem.is_lucky = is_lucky
        
        do{
            try context.save()
            isNewData.toggle()
            memo = ""
            timestamp = Date()
            if is_lucky == true {
                lucky_count += 1
            }
            else{
                unlucky_count += 1
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func EditItem(item: Item){
        updateItem = item
        
        timestamp = item.timestamp!
        memo = item.memo!
        is_lucky = item.is_lucky
        isNewData.toggle()
    }
}
