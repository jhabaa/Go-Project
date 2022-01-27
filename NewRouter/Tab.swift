//
//  Tab.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 26/01/2022.
//

import SwiftUI

struct Tab: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false
    var body: some View {
        GeometryReader{
            g in
            TabView{
                RecipeView()

                WeekView()
               
                BuyView()
                
            }
            .frame(width: g.size.width, height: g.size.height + 20)
            .tabViewStyle(.page)
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}


