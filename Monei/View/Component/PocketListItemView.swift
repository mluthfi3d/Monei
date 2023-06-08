//
//  PocketListViewItem.swift
//  Monei
//
//  Created by Muhammad Luthfi on 10/05/23.
//

import SwiftUI

struct PocketListItemView: View {
    @ObservedObject var pocket:Pocket
    @State var isMainPocket: Bool = false
    
    @State var pocketExpenses = "0"
    
    var body: some View {
        NavigationLink(destination: DetailsPocketView(pocket: pocket, isMainPocket: isMainPocket, viewModel: TransactionViewModel(pocket: pocket))) {
            HStack{
                VStack(alignment: .leading) {
                    HStack(alignment: .center){
                        Text(pocket.pocketIcon ?? "🍘")
                            .font(.system(size: 48))
                            .padding([.trailing], 8)
                        VStack(alignment: .leading){
                            if(isMainPocket){
                                Text("Main Pocket")
                                    .font(.system(size: 14))
                            }
                            Text(pocket.pocketName ?? "Pocket Name")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                        }
                    }.padding([.bottom], 8)
                    if(pocketExpenses != "0"){
                        VStack (alignment: .leading, spacing: 0){
                            Text("Your Expenses This Month")
                                .font(.system(size: 14))
                            Text(Double(pocketExpenses) ?? 0.0, format: .currency(code: "IDR"))
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                            HStack(spacing: 0){
                                Text("/ ")
                                    .font(.system(size: 14))
                                Text(Double(pocket.pocketLimit ?? "40000") ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 14))
                            }
                        }.padding([.vertical], 8)
                    } else {
                        HStack{
                            VStack(alignment: .leading){
                                Text("Budget Limit")
                                    .font(.system(size: 14))
                                Text(Double(pocket.pocketLimit ?? "Pocket Limit") ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 36))
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }.padding([.vertical], 8)
                    }
                    
                    HStack(spacing: 0){
                        Text(pocket.pocketPeriod ?? "Period")
                            .font(.system(size: 12))
                        Text(" Budget")
                            .font(.system(size: 12))
                    }.padding([.top], 8)
                }.task{
                    let tempBalance = Double(pocket.pocketBalance ?? "0") ?? 0.0
                    let tempLimit = Double(pocket.pocketLimit ?? "0") ?? 0.0
                    let tempExpenses = tempLimit - tempBalance
                    if(tempExpenses > 0.0){
                        pocketExpenses = String(tempExpenses)
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity)
                .padding(16)
//                .background(Color("ItemColor"))
                .background(Color(("BGColor"+(pocket.pocketColor ?? "Blue"))))
                .clipShape(RoundedRectangle(cornerRadius:8))
            
        }
//        .buttonStyle(PlainButtonStyle())
        .padding([.horizontal], 16)
        .padding([.vertical], 8)
        .edgesIgnoringSafeArea(.all)
        .clipShape(RoundedRectangle(cornerRadius:8))
        .foregroundColor(Color.white)
    }
}

struct PocketListItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        
        
        PocketListItemView(pocket: newPocket, isMainPocket: true)
    }
}
