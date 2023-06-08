//
//  DetailsPocketView.swift
//  Monei
//
//  Created by Muhammad Luthfi on 09/05/23.
//

import SwiftUI
import CoreData

struct DetailsPocketView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var pocket: Pocket
    @State var isMainPocket: Bool
    
    @State var viewModel: TransactionViewModel
    @State var pocketViewModel = PocketViewModel()
    @State var isOpeningSheet = false
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.vertical){
                    VStack (alignment: .leading, spacing: 16){
                        VStack(alignment: .leading, spacing: 8){
                            VStack{
                                HStack(spacing: 8){
                                    Text(pocket.pocketIcon ?? "🍘")
                                        .font(.system(size: 48))
                                        .padding([.trailing], 8)
                                    VStack(alignment: .leading) {
                                        Text((pocket.pocketPeriod ?? "Monthly") + " Budget")
                                            .font(.system(size: 14))
                                        Text(pocket.pocketName ?? "Pocket Preview")
                                            .font(.system(size: 24))
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(("BGColor"+(pocket.pocketColor ?? "Blue")+"Dark")))
                            
                            VStack (alignment: .leading, spacing: 0){
                                Text("Budget Left This Month")
                                    .font(.system(size: 14))
                                Text(Double(pocket.pocketBalance ?? "20000") ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 36))
                                    .fontWeight(.bold)
                                HStack(spacing: 0){
                                    Text("/ ")
                                        .font(.system(size: 14))
                                    Text(Double(pocket.pocketLimit ?? "40000") ?? 0.0, format: .currency(code: "IDR"))
                                        .font(.system(size: 14))
                                }
                            }
                            .padding([.horizontal, .bottom], 24)
                            .padding([.top], 12)
                            
                        }
                        .background(Color(("BGColor"+(pocket.pocketColor ?? "Blue"))))
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius:8))
                        .padding([.top], 8)
                        .padding([.horizontal], 16)
                        
                        VStack(spacing: 0){
                            HStack{
                                Text("Most Spending Category")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                Spacer()
                                if(viewModel.categoryArray.count > 2){
                                    Button(action:{}){
                                        Text("Show More")
                                            .font(.system(size: 14))
                                    }
                                }
                            }.padding([.horizontal], 16)
                                .padding([.bottom], 4)
                            if(!viewModel.categoryArray.isEmpty){
                                ForEach($viewModel.categoryArray, id: \.self) { $category in
                                    CategoryListItemView(category: $category, pocketColor: pocket.pocketColor ?? "")
                                    
                                }
                            } else {
                                VStack{
                                    Text("No Expenses Yet")
                                }.padding([.vertical], 32)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 0){
                            HStack{
                                Text("Recent Expenses")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                Spacer()
                                if(viewModel.transactionArray.count > 5){
                                    Button(action:{}){
                                        Text("Show More")
                                            .font(.system(size: 14))
                                    }
                                }
                            }.padding([.horizontal], 16)
                                .padding([.bottom], 4)
                            if(!viewModel.transactionArray.isEmpty){
                                ForEach(viewModel.transactionArray.prefix(5), id:\.self) { transaction in
                                    TransactionListItemView(transaction: transaction, pocketColor: pocket.pocketColor ?? "")
                                }
                            } else {
                                VStack{
                                    Text("No Expenses Yet")
                                }.padding([.vertical], 32)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                    }.frame(maxWidth: .infinity)
                        .padding([.vertical], 8)
                }.background(Color("BGColor"))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color(red: 249/255, green: 249/255, blue: 249/255))
                        .frame(maxWidth: .infinity, maxHeight: 0)
                    Button(action: {
                        isOpeningSheet.toggle()
                    }) {
                        Label("New Expense", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.horizontal], 16)
                    .padding(.top, 16)
                    .padding([.bottom], 8)
                }.frame(alignment: .bottom)
                    .background(Color("ItemColor"))
            }
            .task {
                viewModel = TransactionViewModel(pocket: pocket)
                viewModel.fetchTransaction()
                viewModel.fetchCategory()
            }
            .navigationTitle("Pocket Details")
            .navigationBarTitleDisplayMode(.inline).toolbar{
                ToolbarItem(placement: .primaryAction){
                    Menu(content: {
                        Button(action: {
                            if(isMainPocket){
                                UserDefaults.standard.removeObject(forKey: "mainPocket")
                                isMainPocket = false
                            } else {
                                UserDefaults.standard.removeObject(forKey: "mainPocket")
                                UserDefaults.standard.set(pocket.pocketName, forKey: "mainPocket")
                                isMainPocket = true
                            }
                        }) {
                            if(isMainPocket){
                                Label("Unset As Main Pocket", systemImage: "star.fill")
                            } else {
                                Label("Set As Main Pocket", systemImage: "star")
                            }
                        }
                        Button(action: {}) {
                            Label("Customize Pocket", systemImage: "square.and.pencil")
                        }
                        Button(action: {
                            dismiss()
                            pocketViewModel.deleteData(pocket: pocket)
                        }) {
                            Label("Delete Pocket", systemImage: "trash")
                                .accentColor(.red)
                        }
                    }, label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                    })
                }
            }
            .toolbarBackground(
                Color("ItemColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $isOpeningSheet){
                AddNewExpenseView(viewModel: viewModel, pocket: pocket)
            }
        }
    }
}

struct DetailsPocketView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        
        DetailsPocketView(pocket: newPocket, isMainPocket: false, viewModel: TransactionViewModel(pocket: newPocket))
    }
    
}
