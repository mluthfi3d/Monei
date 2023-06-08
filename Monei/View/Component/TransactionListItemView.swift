//
//  TransactionListItemView.swift
//  Monei
//
//  Created by Muhammad Luthfi on 10/05/23.
//

import SwiftUI

struct TransactionListItemView: View {
    @ObservedObject var transaction:Transaction
    @State var pocketColor: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack (alignment: .leading){
                HStack{
                    HStack(alignment: .top) {
                        HStack(alignment: .center){
                            VStack(alignment: .leading){
                                Text(transaction.transactionCategory ?? "Transaction Category")
                                    .font(.system(size: 16))
                                Text(Double(transaction.transactionAmount ?? "20000") ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                            }
                        }
                        Spacer()
                        HStack(spacing: 0){
                            Text(transaction.transactionDate ?? Date.now, style: .date)
                                .font(.system(size: 12))
                        }
                    }
                }
                if(transaction.transactionNotes != ""){
                    Divider()
                    Text(transaction.transactionNotes ?? "Date.now")
                        .font(.system(size: 12))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color("ItemColor"))
//            .background(Color(("BGColor"+(pocketColor))))
            .clipShape(RoundedRectangle(cornerRadius:8))
            
            
        }
        .padding([.horizontal], 16)
        .padding([.vertical], 4)
        .edgesIgnoringSafeArea(.all)
        .clipShape(RoundedRectangle(cornerRadius:8))
        .foregroundColor(Color.black)
    }
}

struct TransactionListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let newTransaction = Transaction(context: context)
        
        TransactionListItemView(transaction: newTransaction, pocketColor: "Blue")
    }
}
