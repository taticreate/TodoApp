//
//  TodoApp.swift
//  TodoApp
//
//  Created by Tati on 2/23/23.
//

import SwiftUI

@main
struct TodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
