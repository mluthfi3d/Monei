//
//  AddNewExpenses.swift
//  Monei
//
//  Created by Muhammad Luthfi on 11/05/23.
//

import SwiftUI
import CoreData
import WidgetKit

struct AddNewExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TransactionViewModel
    var pocket: Pocket
    
    init(viewModel: TransactionViewModel, pocket: Pocket){
        self.viewModel = viewModel
        self.pocket = pocket
    }
    
    @State private var transactionNotes = ""
    @State private var transactionAmount = ""
    @State private var transactionCategory = "Food"
    
    let categories = ["Food", "Snack"]
    
    var body: some View {
        NavigationStack {
            Form {
                LabeledContent("Pocket", value: pocket.pocketName ?? "Pocket Name")
                HStack{
                    Text("IDR")
                    TextField("Enter Your Amount", text: $transactionAmount)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                
                Picker("Category", selection: $transactionCategory){
                    ForEach(categories, id: \.self){category in
                        Text(category)
                    }
                }.pickerStyle(.menu)
                
                HStack{
                    Text("Notes")
                    TextField("Enter Notes If Any", text: $transactionNotes)
                        .multilineTextAlignment(.trailing)
                }
                
                
            }
            .background(Color("BGColor"))
            
            .navigationTitle("Add New Pocket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction){
                    Button("Apply"){
                        viewModel.addTransaction(transactionAmount: transactionAmount, transactionCategory: transactionCategory, transactionNotes: transactionNotes)
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    }.disabled((transactionAmount.isEmpty)||( (Double(transactionAmount ) ?? 0.0) > (Double(pocket.pocketBalance ?? "0.0") ?? 0.0)))
                }
            }
            .toolbarBackground(
                Color("ItemColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct AddNewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        AddNewExpenseView(viewModel: TransactionViewModel(pocket: newPocket), pocket: newPocket)
    }
}
