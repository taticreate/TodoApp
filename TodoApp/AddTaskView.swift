//
//  AddTaskView.swift
//  TodoApp
//
//  Created by Tati on 2/25/23.
//

import SwiftUI

struct AddTaskView: View {
    
    //presentation mode and and object context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    //state variables defined
    @State var name: String
    @State var dueDate: Date
    @State var isCompleted: Bool
    @State var isUrgent: Bool
    
    //initial values of state variable set
    init(taskItem: TaskItem? = nil) {
            _name = State(initialValue: taskItem?.name ?? "")
            _isUrgent = State(initialValue: taskItem?.isUrgent ?? false)
            _isCompleted = State(initialValue: taskItem?.isCompleted ?? false)
            _dueDate = State(initialValue: taskItem?.dueDate ?? Date())
        }
    
    var body: some View {
        
        NavigationView {
            
            //sections for adding input
            Form {
                Section(header: Text("Task Name")) {
                    TextField("Add Name", text: $name)
                }
                Section(header: Text("Status")) {
                    HStack {
                        Toggle("Is Urgent", isOn: $isUrgent)
                        
                    }
                }
                Section(header: Text("Due Date")) {
                    DatePicker("", selection: $dueDate)
                }
                Section()
                {
                        //add task button
                        Button("Create", action: addItem)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Button("Cancel")
                        {
                            // Go back to TaskView without saving
                             presentationMode.wrappedValue.dismiss()
                        }.font(.headline)
                         .frame(maxWidth: .infinity, alignment: .center)
                
                }
            }.navigationTitle("Add New Task")
        }
    }
    
    //logic for adding
    private func addItem() {
        withAnimation {
            let newItem = TaskItem(context: viewContext)
            newItem.name = name
            newItem.isUrgent = isUrgent
            newItem.isCompleted = isCompleted
            newItem.dueDate = dueDate
            
            //save to object context
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            //return to TaskView
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskItem: TaskItem())
    }
}
