//
//  IntentHandler.swift
//  SelectPocket
//
//  Created by Muhammad Luthfi on 15/05/23.
//

import Intents
import CoreData

class IntentHandler: INExtension, SelectPocketIntentHandling {
    
    func provideSelectedPocketOptionsCollection(for intent: SelectPocketIntent) async throws -> INObjectCollection<Pockets> {
        let moc = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<Pocket>(entityName: "Pocket")
        let results = try moc.fetch(request)
        let pocketList = results.map { pocketAttr in
            let pocketItem = Pockets(
                identifier: pocketAttr.pocketID?.description ?? "",
                display: pocketAttr.pocketName ?? ""
            )
            pocketItem.symbol = pocketAttr.pocketIcon ?? ""
            pocketItem.name = pocketAttr.pocketName ?? ""
            
            return pocketItem
        }
//
//        var num: [Int] = []
//        var loop = 0
//
//        for i in pocketList.indices {
//            if pocketList[i].name == "" {
//                num.append(i)
//            }
//        }
//        for i in num {
//            pocketList.remove(at: i-loop)
//            loop += 1
//        }
        let collection = INObjectCollection(items: pocketList)
        return collection
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
