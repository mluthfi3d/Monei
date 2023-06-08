//
//  PocketViewModel.swift
//  Monei
//
//  Created by Muhammad Luthfi on 10/05/23.
//

import Foundation
import CoreData

class PocketViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    @Published var pocketArray: [Pocket] = []
    @Published var mainPocketArray: [Pocket] = []
    
    init(){
        fetchPocketData()
    }
    
    func fetchPocketData(){
        let request = NSFetchRequest<Pocket>(entityName: "Pocket")
        do {
            pocketArray = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Error while Fetching")
        }
    }
    
    func fetchMainPocketData(pocketName: String){
        let request = NSFetchRequest<Pocket>(entityName: "Pocket")
        request.predicate = NSPredicate(format: "pocketName == %@", pocketName)
        
        do {
            mainPocketArray = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Error while Fetching")
        }
    }
    
    func addDataToCoreData(pocketName: String, pocketLimit: String, pocketPeriod: String, pocketColor: String, isMainPocket: Bool){
        let pocket = Pocket(context: viewContext)
        pocket.pocketID = UUID()
        pocket.pocketName = pocketName
        pocket.pocketBalance = pocketLimit
        pocket.pocketLimit = pocketLimit
        pocket.pocketPeriod = pocketPeriod
        pocket.pocketColor = pocketColor
        pocket.pocketIcon = "💰"
        pocket.pocketDateAdded = Date.now
        save()
        
        self.fetchPocketData()
        if(isMainPocket){
            UserDefaults.standard.set(pocket.pocketName, forKey: "mainPocket")
            self.fetchMainPocketData(pocketName: pocketName)
        }
    }
    
    func deleteData(pocket: Pocket){
        let transaction = pocket.transactionsArray
        if (!transaction.isEmpty) {
            for trx in transaction {
                viewContext.delete(trx)
            }
        }
        viewContext.delete(pocket)
        save()
    }
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: Error while saving")
        }
    }
}
