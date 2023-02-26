//
//  CellDetails.swift
//  TodoApp
//
//  Created by Tati on 2/23/23.
//

import SwiftUI

struct CellDetails: View {
    
    //declare observed object
    @ObservedObject var passedTaskItem: TaskItem
    
    
    var body: some View {
        
        //icon views based on complete/incomplete, urgent/not urgent
        if passedTaskItem.isUrgent && !passedTaskItem.isCompleted {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(Color.red)
                //on tap of icon mark complete
                .onTapGesture {
                    passedTaskItem.isCompleted = true
                }
        } else {
            //tap complete, toogle changed
            Image(systemName: passedTaskItem.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(passedTaskItem.isCompleted ? Color.green : Color.red)
                .onTapGesture {
                    passedTaskItem.isCompleted.toggle()
                }
        }
            
        //name text color for complete/incomplete + date
        VStack(alignment: .leading) {
            Text(passedTaskItem.name ?? "")
                .padding(.horizontal)
                .foregroundColor(passedTaskItem.isCompleted ? Color.green : Color.red)
            Text("\(passedTaskItem.dueDate ?? Date(), formatter: itemFormatter)")
                .padding(.horizontal)
                .foregroundColor(.secondary)
        }
    }
}

//formating the way date displays
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

struct CellDetails_Previews: PreviewProvider {
    static var previews: some View {
        CellDetails(passedTaskItem: TaskItem())
    }
}
