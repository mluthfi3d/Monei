//
//  AddNewPocketView.swift
//  Monei
//
//  Created by Muhammad Luthfi on 09/05/23.
//

import SwiftUI
import CoreData

struct AddNewPocketView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PocketViewModel
    
    init(viewModel: PocketViewModel){
        self.viewModel = viewModel
    }
    
    @State private var pocketName = ""
    @State private var pocketLimit = ""
    @State private var pocketPeriod = "One-Time"
    @State private var pocketColor = "Red"
    @State private var isMainPocket = false
    
    let periods = ["One-Time", "Weekly", "Monthly"]
    let colors = ["Red", "Green", "Blue", "Purple"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter Your Pocket's Name", text: $pocketName)
                HStack{
                    Text("IDR")
                    TextField("Enter Your Budget", text: $pocketLimit)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                Picker("Period", selection: $pocketPeriod){
                    ForEach(periods, id: \.self){period in
                        Text(period)
                    }
                }.pickerStyle(.menu)
                Toggle("Set as Main Pocket", isOn: $isMainPocket)
                VStack(alignment: .leading){
                    Text("Select Background Color")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                                    ForEach(colors, id: \.self) { color in
                                        Button(action: {
                                            pocketColor = color
                                        }) {
                                            Circle()
                                                .fill(Color("BGColor"+color))
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.accentColor, lineWidth: pocketColor == color ? 3 : 0)
                                                        .frame(width: 47, height: 47)
                                                )
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                }
                            }
                }
                
            }
            .background(Color("BGColor"))
            
            .navigationTitle("Add New Pocket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction){
                    Button("Apply"){
                        viewModel.addDataToCoreData(pocketName: pocketName, pocketLimit: pocketLimit, pocketPeriod: pocketPeriod, pocketColor: pocketColor, isMainPocket: isMainPocket)
                        if(isMainPocket){
                            UserDefaults.standard.set(pocketName, forKey: "mainPocket")
                        }
                        dismiss()
                    }.disabled((pocketName.isEmpty || pocketLimit.isEmpty))
                }
            }
            .toolbarBackground(
                Color("ItemColor"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct AddNewPocketView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPocketView(viewModel: PocketViewModel())
    }
}
