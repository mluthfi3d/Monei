//
//  Pocket+CoreDataProperties.swift
//  Monei
//
//  Created by Muhammad Luthfi on 15/05/23.
//
//

import Foundation
import CoreData


extension Pocket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pocket> {
        return NSFetchRequest<Pocket>(entityName: "Pocket")
    }

    @NSManaged public var pocketID: UUID?
    @NSManaged public var pocketBalance: String?
    @NSManaged public var pocketColor: String?
    @NSManaged public var pocketDateAdded: Date?
    @NSManaged public var pocketLimit: String?
    @NSManaged public var pocketName: String?
    @NSManaged public var pocketPeriod: String?
    @NSManaged public var pocketIcon: String?
    @NSManaged public var transaction: NSSet?
    
    public var transactionsArray: [Transaction] {
        let transactionSet = transaction as? Set<Transaction> ?? []
        
        return transactionSet.sorted {
            $0.dateAdded > $1.dateAdded
        }
    }
    
    public var categoryArray: [Transaction] {
        let categorySet = transaction as? Set<Transaction> ?? []
        
        return categorySet.sorted {
            $0.dateAdded > $1.dateAdded
        }
    }

}

// MARK: Generated accessors for transaction
extension Pocket {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: Transaction)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: Transaction)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}

extension Pocket : Identifiable {

}
