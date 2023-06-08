//
//  Transaction+CoreDataProperties.swift
//  Monei
//
//  Created by Muhammad Luthfi on 15/05/23.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var transactionAmount: String?
    @NSManaged public var transactionCategory: String?
    @NSManaged public var transactionDate: Date?
    @NSManaged public var transactionID: UUID?
    @NSManaged public var transactionNotes: String?
    @NSManaged public var pocket: Pocket?
    
    public var dateAdded: Date {
        return transactionDate ?? Date.now
        }
}

extension Transaction : Identifiable {

}
