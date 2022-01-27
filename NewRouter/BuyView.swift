//
//  BuyView.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 25/01/2022.
//

import SwiftUI

struct BuyView: View {
    @StateObject var viewModel = ViewModel()
    private var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: twoColumnGrid ) {
                ForEach(viewModel.buys, id: \.self){
                    recipe in HStack{
                        Section{
                            Image("").frame(width: 150, height: 60).background(Color.gray).opacity(0.4)
                                .cornerRadius(20)
                                .overlay(){
                                    Text("\(recipe.ingredient)")
                                        .padding()
                                }
                        }
                     
                    }
                }
            }.padding(.top, 80)
            .onAppear{
                
                viewModel.fetchToBuy()
                }
              //  .background(Image("3").scaledToFill().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        }
        .tabItem{Label("To Buy", systemImage: "cart")}
        .overlay(alignment: .top, content: {
            Section{
                Text("To Buy \(Image(systemName: "cart"))")
                    .font(Font.largeTitle)
                    .tint(Color.black)
                    .padding()
            }.background(Color.white)
                .cornerRadius(20)
                .opacity(0.7)
        })
        
        //Synchronize button
        .overlay(alignment: .bottomTrailing, content: {
            Section{
                Button("\(Image(systemName: "arrow.triangle.2.circlepath.circle"))"){
                    viewModel.fetchToBuy()
                }
                .font(Font.system(size: 70.0))
            }.padding(.bottom)
        })
    }
}

