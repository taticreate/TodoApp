//
//  ContentView.swift
//  TodoApp
//
//  Created by Tati on 2/23/23.
//

import SwiftUI
import CoreData

struct TaskView: View {
    
    //get object context
    @Environment(\.managedObjectContext) private var viewContext
    
    //fetch task from Core data, sort by duedate
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TaskItem>
    
    //define state variables
    @State private var isPresentingAddTaskView = false
    @State private var showAllTasks = true
    @State private var showUrgentTasks = false
    @State private var showCompletedTasks = false
    
    var body: some View {
        NavigationView {
            VStack {
                //task filter buttons
                HStack {
                    Button(action: {
                        showAllTasks = true
                        showUrgentTasks = false
                        showCompletedTasks = false
                    }) {
                        Text("All")
                          .padding(10)
                    }
                    .foregroundColor(showAllTasks ? .white : .blue)
                    .background(showAllTasks ? Color.blue : Color.white)
                    .cornerRadius(7)
                    
                    
                    Button(action: {
                        showAllTasks = false
                        showUrgentTasks = true
                        showCompletedTasks = false
                    }) {
                        Text("Urgent")
                          .padding(10)
                    }
                    .foregroundColor(showUrgentTasks ? .white : .red)
                    .background(showUrgentTasks ? Color.red : Color.white)
                    .cornerRadius(7)
                    
                    
                    Button(action: {
                        showAllTasks = false
                        showUrgentTasks = false
                        showCompletedTasks = true
                    }) {
                        Text("Completed")
                          .padding(10)
                    }
                    .foregroundColor(showCompletedTasks ? .white : .green)
                    .background(showCompletedTasks ? Color.green : Color.white)
                    .cornerRadius(7)
                    
                }
                .padding(.horizontal)
                

                //filter tasks based on selected button
                List {
                    ForEach(items.filter { item in
                        if showAllTasks {
                            return true
                        } else if showUrgentTasks {
                            return item.isUrgent && !item.isCompleted
                        } else if showCompletedTasks {
                            return item.isCompleted
                        }
                        return false
                    }) { item in
                        //display task details and link to editing
                        NavigationLink(destination: TaskEditView(passedTaskItem: item).navigationBarBackButtonHidden(true)) {
                            CellDetails(passedTaskItem: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                }
                // button for adding new task
                .toolbar {
                    ToolbarItem {
                        Button(action: { isPresentingAddTaskView = true }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .navigationTitle("To Do List")
                
            }
            .sheet(isPresented: $isPresentingAddTaskView) {
                AddTaskView().environment(\.managedObjectContext, viewContext)
            }
            
        }
    }
    // logic for adding task
    private func addItem() {
        withAnimation {
            let newItem = TaskItem(context: viewContext)
            newItem.dueDate = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    //logic for deleting task
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//formatting data
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

