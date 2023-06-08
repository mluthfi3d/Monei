//
//  TransactionViewModel.swift
//  Monei
//
//  Created by Muhammad Luthfi on 11/05/23.
//

import Foundation
import CoreData

struct Category: Hashable {
    var category: String
    var amount: String
}

class TransactionViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.viewContext
    @Published var transactionArray = [Transaction]()
    @Published var categoryArray: Array<Category> = []
    
    var pocket: Pocket
    
    init(pocket: Pocket){
        self.pocket = pocket
    }

    func fetchTransaction(){
        transactionArray = pocket.transactionsArray
        
    }
    
    func fetchCategory(){
        categoryArray = []
        let tempArray = pocket.transactionsArray
        for temp in tempArray {
            let key = temp.transactionCategory ?? ""
            if let i = categoryArray.firstIndex(where: {$0.category == key}) {
                let tempCategory = Double(categoryArray[i].amount)
                let tempAmount = Double(temp.transactionAmount ?? "0.0")
                categoryArray[i].amount = String((tempCategory ?? 0.0) + (tempAmount ?? 0.0))
            } else {
                let tempObject = Category(category: key, amount: temp.transactionAmount ?? "0.0")
                categoryArray.append(tempObject)
            }
        }
        
    }

    func addTransaction(transactionAmount: String, transactionCategory: String, transactionNotes: String){
        let transaction = Transaction(context: viewContext)
        transaction.transactionID = UUID()
        transaction.transactionDate = Date.now
        transaction.transactionAmount = transactionAmount
        transaction.transactionCategory = transactionCategory
        transaction.transactionNotes = transactionNotes
        
        
        let tempBalance = Double(pocket.pocketBalance ?? "0") ?? 0.0
        let tempAmount = Double(transaction.transactionAmount ?? "0") ?? 0.0
        if(tempBalance > tempAmount){
            pocket.addToTransaction(transaction)
            pocket.pocketBalance = String(tempBalance-tempAmount)
            save()
            fetchTransaction()
            fetchCategory()
        } else {
            
        }
        
    }
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("Error While Saving")
        }
    }
}
