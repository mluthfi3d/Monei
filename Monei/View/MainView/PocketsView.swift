//
//  PocketsView.swift
//  Monei
//
//  Created by Muhammad Luthfi on 09/05/23.
//

import SwiftUI
import CoreData

struct PocketsView: View {
    
    @AppStorage("mainPocket") private var mainPocketName = ""
    @StateObject var viewModel = PocketViewModel()
    
    @State var isOpeningSheet = false
    @State private var isShowingDetailView = false
    @State private var isAddNewExpense = false
    @State var openedPocket:Pocket
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color("BGColor")
                    .edgesIgnoringSafeArea(.all)
                if(!viewModel.pocketArray.isEmpty){
                    ScrollView {
                        VStack(spacing: 0){
                            if(!viewModel.mainPocketArray.isEmpty){
                                ForEach(viewModel.mainPocketArray, id:\.self) {pocket in
                                    PocketListItemView(pocket: pocket, isMainPocket: true)
                                }
                            }
                            ForEach(viewModel.pocketArray, id:\.self) { pocket in
                                if(pocket != viewModel.mainPocketArray.first){
                                    if(pocket.pocketName != nil){
                                        PocketListItemView(pocket: pocket, isMainPocket: false)
                                    }
                                }
                                
                            }
                        }.padding([.vertical], 8)
                    }
                } else {
                    Text("No Pockets")
                }
            }
            
        }
        .task {
            viewModel.fetchMainPocketData(pocketName: mainPocketName)
        }
        .scrollContentBackground(.hidden)
        
        .navigationTitle("Pockets")
        .toolbar {
            Button("New Pocket") {
                isOpeningSheet.toggle()
            }
        }
        .toolbarBackground(
            Color("ItemColor"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $isOpeningSheet){
            AddNewPocketView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $isShowingDetailView){
            DetailsPocketView(pocket: openedPocket, isMainPocket: true, viewModel: TransactionViewModel(pocket: openedPocket), isOpeningSheet: isAddNewExpense)
        }
        .onOpenURL{url in
            let myPocket = handleWidgetDeepLink(url)
            openedPocket = myPocket
            self.isShowingDetailView = true
        }
    }

    private func handleWidgetDeepLink(_ url: URL) -> Pocket {
        let uid = url.description.components(separatedBy: "://")
        let context = PersistenceController.shared.container.viewContext
        var newPocket = Pocket()
        let pocketBase = Pocket()
        
        if uid[2] == "Add" {
            isAddNewExpense = true
        } else {
            isAddNewExpense = false
        }
        
        let request = NSFetchRequest<Pocket>(entityName: "Pocket")
        request.predicate = NSPredicate(format: "pocketID == %@", UUID(uuidString: uid[1].description)! as CVarArg)
        do {
            let results = try context.fetch(request)
            newPocket = results.first ?? pocketBase
        } catch let error as NSError {
            print(error)
        }
        return newPocket
    }
    
}

struct PocketsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        PocketsView(openedPocket: newPocket)
    }
}
