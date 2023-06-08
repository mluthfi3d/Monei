//
//  AddExpenseWidget.swift
//  AddExpenseWidge0t
//
//  Created by Muhammad Luthfi on 11/05/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct PocketEntry: TimelineEntry {
    let date: Date
    let pocket: Pocket
    let deepLinkCommand: String
}

struct AddExpenseWidgetEntryView : View {
    var entry: PocketEntry
    @State var pocketExpenses = "0"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            if entry.pocket.pocketName ?? "" != "" {
                VStack(alignment: .leading, spacing: 0){
                    HStack {
                        HStack{
                            Text(entry.pocket.pocketIcon ?? "🍘")
                                .font(.system(size: 36))
                                .padding([.trailing], 8)
                            VStack(alignment: .leading){
                                if(pocketExpenses == "0"){
                                    Text("Your " + (entry.pocket.pocketPeriod ?? "No") + " Budget on")
                                        .font(.system(size: 12))
                                } else {
                                    Text("Your " + (entry.pocket.pocketPeriod ?? "No") + " Expenses on")
                                        .font(.system(size: 12))
                                }
                                Text(entry.pocket.pocketName ?? "Pocket Name")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 32)
                    .padding([.vertical], 8)
                    .background(Color(("BGColor"+(entry.pocket.pocketColor ?? "Blue"))))
                    .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    VStack {
                        if(pocketExpenses != "0"){
                            VStack(alignment: .leading){
                                Text(Double(pocketExpenses) ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                HStack(spacing: 0){
                                    Text("/ ")
                                        .font(.system(size: 12))
                                    Text(Double(entry.pocket.pocketLimit ?? "40000") ?? 0.0, format: .currency(code: "IDR"))
                                        .font(.system(size: 12))
                                }
                            }
                            .frame(alignment: .leading)
                        } else {
                            VStack (alignment: .leading){
                                Text("Budget Limit")
                                    .font(.system(size: 12))
                                Text(Double(entry.pocket.pocketLimit ?? "") ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                            }
                        }
                        
                    }
                    .padding([.horizontal], 32)
                    
                    Spacer()
                    Link(destination: URL(string: "monei://\(entry.deepLinkCommand)://Add")!)
                    {
                        HStack{
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(Color("AccentColor"))
                            Text("Add New Expense")
                                .font(.system(size: 12))
                        }
                        .padding([.horizontal], 16)
                        .padding([.vertical], 8)
                        .background(Color("ItemColor"))
                        .clipShape(RoundedRectangle(cornerRadius:32))
                        .padding([.horizontal], 32)
                    }
                    
                    .widgetURL(URL(string: "monei://\(entry.deepLinkCommand)://Open"))
                    
                    Spacer()
                    
                }
            } else {
                VStack{
                    VStack(alignment: .leading){
                        HStack {
                            HStack{
                                Circle()
                                    .fill(Color("ItemColor"))
                                VStack(alignment: .leading){
                                    HStack{
                                        Text((entry.pocket.pocketPeriod ?? "No") + " Pocket")
                                            .font(.system(size: 12))
                                            .background(Color("ItemColor"))
                                            .foregroundColor(Color("ItemColor"))
                                    }
                                    Text(entry.pocket.pocketName ?? "Pocket Name")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .background(Color("ItemColor"))
                                        .foregroundColor(Color("ItemColor"))
                                }
                            }
                            Spacer()
                            VStack{
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .background(Color("ItemColor"))
                                    .foregroundColor(Color("ItemColor"))
                            }.padding(8)
                                .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.horizontal], 32)
                        .padding([.top], 16)
                        .padding([.bottom], 8)
                        .background(Color("BGColor"))
                        Spacer()
                        VStack {
                            
                            VStack (alignment: .leading){
                                Text("Budget Limit")
                                    .font(.system(size: 12))
                                    .background(Color("ItemColor"))
                                    .foregroundColor(Color("ItemColor"))
                                Text(Double(entry.pocket.pocketLimit ?? "") ?? 0.0, format: .currency(code: "IDR"))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .background(Color("ItemColor"))
                                    .foregroundColor(Color("ItemColor"))
                                
                            }
                        }
                        .padding([.horizontal], 32)
                        .padding([.bottom], 16)
                        .padding([.top], 8)
                        
                        Spacer()
                    }
                    HStack{
                        Text("Tap or Hold to Select Pocket")
                            .font(.system(size: 12))
                            .frame(alignment: .bottom)
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(Color("ItemColor"))
                }
                .background(Color("BGColor"))
            }
        }
        .onAppear() {
            let tempBalance = Double(entry.pocket.pocketBalance ?? "0") ?? 0.0
            let tempLimit = Double(entry.pocket.pocketLimit ?? "0") ?? 0.0
            let tempExpenses = tempLimit - tempBalance
            if(tempExpenses > 0.0){
                pocketExpenses = String(tempExpenses)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color("BGColor"))
        //        .background(Color("BGColor"+(entry.pocket.pocketColor ?? "Blue")))
        
        
    }
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> PocketEntry {
        
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        
        return PocketEntry(date: Date(), pocket: newPocket, deepLinkCommand: "")
    }
    
    func getSnapshot(for configuration: SelectPocketIntent,
                     in context: Context,
                     completion: @escaping (PocketEntry) -> ()) {
        
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        let entry = PocketEntry(date: Date(), pocket: newPocket, deepLinkCommand: "")
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectPocketIntent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> ()) {
        
        guard
            let pocketID = configuration.selectedPocket?.identifier else {
            
            showEmptyState(completion: completion)
            return
        }
        
        Task {
            let context = PersistenceController.shared.container.viewContext
            let request = NSFetchRequest<Pocket>(entityName: "Pocket")
            request.predicate = NSPredicate(format: "pocketID == %@", UUID(uuidString: pocketID)! as CVarArg)
            let newPocket = Pocket(context: context)
            
            guard let result = try? context.fetch(request) else {
                showEmptyState(completion: completion)
                return
            }
            
            let entry = PocketEntry(date: Date(), pocket: result.first ?? newPocket, deepLinkCommand: result.first?.pocketID?.description ?? "")
            executeTimelineCompletion(completion, timelineEntry: entry)
        }
    }
    
    private func showEmptyState(completion: @escaping (Timeline<PocketEntry>) -> ()){
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        
        let entry = PocketEntry(date: Date(), pocket: newPocket, deepLinkCommand: "")
        executeTimelineCompletion(completion, timelineEntry: entry)
    }
    
    func executeTimelineCompletion(_ completion: @escaping(Timeline<PocketEntry>) -> (), timelineEntry: PocketEntry){
        let nextUpdate = Calendar.current.date(byAdding: DateComponents(second: 1), to: Date())!
        
        let timeline = Timeline(entries: [timelineEntry], policy: .after(nextUpdate))
        completion(timeline)
    }
}




struct AddExpenseWidget: Widget {
    let kind: String = "AddExpenseWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: SelectPocketIntent.self,
                            provider: Provider()
        ) { entry in
            AddExpenseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Monei Pocket")
        .description("Select Your Pocket!")
        .supportedFamilies([.systemMedium])
    }
}

struct AddExpenseWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        let newPocket = Pocket(context: context)
        
        AddExpenseWidgetEntryView(entry: PocketEntry(date: Date(), pocket: newPocket, deepLinkCommand: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
