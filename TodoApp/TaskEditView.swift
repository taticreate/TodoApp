//
//  TaskEditView.swift
//  TodoApp
//
//  Created by Tati on 2/23/23.
//

import SwiftUI

struct TaskEditView: View {
   
    //presentation mode and managed object variables
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    //state variables defined
    @State var selectedTaskItem: TaskItem?
    @State var name: String
    @State var dueDate: Date
    @State var isCompleted: Bool
    @State var isUrgent: Bool

    //constructor for passed task details and defaults in edit mode
    init(passedTaskItem: TaskItem?){
        
        if let taskItem = passedTaskItem
                {
                    //passed details
                    _selectedTaskItem = State(initialValue: taskItem)
                    _name = State(initialValue: taskItem.name ?? "")
                    _dueDate = State(initialValue: taskItem.dueDate ?? Date())
                    _isCompleted = State(initialValue: taskItem.isCompleted)
                    _isUrgent = State(initialValue: taskItem.isUrgent)
                }
                else
                {
                    //defaults
                    _name = State(initialValue: "")
                    _dueDate = State(initialValue: Date())
                    _isCompleted = State(initialValue: false)
                    _isUrgent = State(initialValue: false)
                }
    
    }
    
    
    var body: some View
    {
        NavigationView {
            
            //sections for editing
            Form
            {
                Section(header: Text("Task Name"))
                {
                    TextField("Edit Name", text: $name)
                }
                
                Section(header: Text("Status"))
                {
                    HStack {
                        Toggle("Is Urgent", isOn: $isUrgent)
                        Toggle("Completed", isOn: $isCompleted)
                    }
                }
                Section(header: Text("Due Date"))
                {
                    DatePicker("", selection: $dueDate)
                    
                }
                Section()
                {
                        //save button
                        Button("Save", action: saveAction)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Button("Cancel")
                        {
                            // go back to TaskView without saving
                             presentationMode.wrappedValue.dismiss()
                        }.font(.headline)
                         .frame(maxWidth: .infinity, alignment: .center)
                
                }
            }.navigationTitle("Update Task")
        }
    }
    

    //task save logic
    func saveAction()
    {
        withAnimation
        {
            if selectedTaskItem == nil
            {
                selectedTaskItem = TaskItem(context: viewContext)
            }
            //update task details with current state
            selectedTaskItem?.name = name
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.isCompleted = isCompleted
            selectedTaskItem?.isUrgent = isUrgent
            
            //return to main task list after editing
            self.presentationMode.wrappedValue.dismiss()
            
        }
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(passedTaskItem: TaskItem())
    }
}
