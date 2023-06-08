//
//  IntentHandler.swift
//  Monei
//
//  Created by Muhammad Luthfi on 15/05/23.
//

import Foundation
import WidgetKit
import SwiftUI
import CoreData
import Intents

class IntentHandler: INExtension,ConfigurationIntentHandling {
    
    var moc = PersistenceController.shared.viewContext
    
    func provideUUIDOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        
        let request = NSFetchRequest<Pocket>(entityName: "Pocket")
                var nameIdentifiers:[NSString] = []
        
                do{
                    let results = try moc.fetch(request)
        
                    for result in results{
                        nameIdentifiers.append(NSString(string: result.pocketID?.description ?? ""))
                    }
                }
                catch let error as NSError{
                    print("Could not fetch.\(error.userInfo)")
                }
        
                let allNameIdentifiers = INObjectCollection(items: nameIdentifiers)
                completion(allNameIdentifiers,nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
