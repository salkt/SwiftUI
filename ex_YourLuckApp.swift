//
//  ex_YourLuckApp.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import SwiftUI

@main
struct ex_YourLuckApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
