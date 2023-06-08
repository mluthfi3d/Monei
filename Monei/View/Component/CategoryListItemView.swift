//
//  CategoryListItemView.swift
//  Monei
//
//  Created by Muhammad Luthfi on 10/05/23.
//

import SwiftUI

struct CategoryListItemView: View {
    @Binding var category:Category
    @State var pocketColor: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center){
                        Image(systemName: "house")
                            .padding([.trailing], 16)
                    }
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            Text(category.category)
                                .font(.system(size: 16))
                            Text(Double(category.amount) ?? 0.0, format: .currency(code: "IDR"))
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                        }
                    }
                    Spacer()
                }
            }.frame(maxWidth: .infinity)
                .padding(16)
                .background(Color("ItemColor"))
//                .background(Color(("BGColor"+(pocketColor))))
                .clipShape(RoundedRectangle(cornerRadius:8))
            
        }
        .padding([.horizontal], 16)
        .padding([.vertical], 4)
        .edgesIgnoringSafeArea(.all)
        .clipShape(RoundedRectangle(cornerRadius:8))
        .foregroundColor(Color.black)
    }
}

struct CategoryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListItemView(category: .constant(Category(category: "", amount: "")), pocketColor: "Blue")
    }
}
