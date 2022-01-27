//
//  RecipeView.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 25/01/2022.
//

import SwiftUI
import UIKit

var clickedRecipeName:String = ""
var recipeSelected:Recepie = Recepie(name: "", time: "", howto: "")

struct RecipeView: View {
    @State private var isPresented = false
    @StateObject var viewModel = ViewModel()
    @State var gridLayout: [GridItem] = [GridItem(), GridItem()]
    @State private var showingSheet = false
    var body: some View {
                        ScrollView{
                            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 5){
                                ForEach(viewModel.recepies, id: \.self){
                                    recepie in ZStack{
                                        Image("images")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(height:200)
                                        .cornerRadius(10)
                                        .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                        .padding()
                                        .blur(radius: 2)
                                        .overlay(){
                                            Button("\(recepie.name)"){
                                                showingSheet.toggle()
                                                recipeSelected = recepie
                                            }.buttonStyle(.borderedProminent)
                                                .tint(Color.white)
                                            .padding()
                                            .buttonBorderShape(.capsule)
                                            .font(Font.title)
                                            .foregroundColor(Color.black)
                                            .opacity(0.5)
                                            .overlay(){
                                                RoundedRectangle(cornerRadius: 38)
                                                    .stroke(Color.white, lineWidth:2)
                                            }
                                            .sheet(isPresented: $showingSheet){
                                                PlayerView(recipeName: recepie.name)
                                            }
                                            
                                        }
                                                
                                    }.onAppear(){
                                        viewModel.fetch()
                                    }
                                    .padding(.all, 5)
                                    .contextMenu {
                                        Button("Delete \(recepie.name) 🗑"){
                                            viewModel.DeleteRecipe(id: "\(recepie.name)")
                                            viewModel.fetch()
                                        }
                                    }
                                    
                                }.onDelete(perform: delete)
                            }.padding(.top, 40)
                            
                            
                        }
                        .overlay(alignment: .top, content: {
                            HStack{
                                    Text("Recepies")
                                    .padding()
                                        .font(Font.title)
                                        .background(Color.white)
                                        .cornerRadius(20.0)
                                        .shadow(radius: 30.0)
                                        .opacity(0.9)
                            }
                        })
                        .onAppear{
                            UITableView.appearance().backgroundColor = UIColor.clear
                            viewModel.fetch()
                        }
                        .overlay(alignment: .bottom, content: {

                                Button("\(Image(systemName: "plus.circle.fill"))"){
                                    isPresented.toggle()
                                }.font(Font.largeTitle)
                                    .padding()
                                    .buttonBorderShape(.capsule)
                                    .tint(Color.blue)
                                    .fullScreenCover(isPresented: $isPresented) {
                                NewRecipeView()
                                    }
                        })
            .tabItem{Label("Recipes", systemImage: "house.circle.fill").foregroundStyle(.green).background(Color.blue)}
            .background(Image("1").scaledToFill().edgesIgnoringSafeArea(.all))
        
    }
    func delete(at offsets: IndexSet){
        viewModel.recepies.remove(atOffsets:offsets)
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}


struct PlayerView: View {
    public var recipeName:String
    
    @State var ingredientList:[Ingredient] = []
    @StateObject var viewModel = ViewModel()
    @State private  var name:String = ""
    @State private var isPresented = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        TabView{
                ScrollView {
                    
                    GroupBox(label: Label("Ingredients", systemImage: "checklist")) {
                        ForEach(viewModel.fullRecipe, id: \.self){
                            recipe in VStack{
                                Text("\(recipe.needed_quantity)").foregroundColor(Color.black)
                                Text("\(recipe.ingredients_name)")
                                }.foregroundColor(Color.black)
                        }
                    }.padding(.top, 80.0)
                    Section(){
                        Button("Get Ingredients"){
                            viewModel.GetRecipeAndIngredient(name: recipeSelected.name)
                        }.padding()
                            .buttonStyle(.bordered)
                    }
                    GroupBox(label: Label("How To", systemImage: "list.bullet.circle.fill")){
                        Text("\(Image(systemName: "timer")) : \(recipeSelected.time)")
                        Text("\(recipeSelected.howto)")
                            .padding()
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 20.0)
                            
                    }
                    

                }
                .overlay(alignment: .top, content: {
                    Section{
                        Text("\(recipeSelected.name)").foregroundColor(Color.black).font(Font.largeTitle)
                            .padding()
                            .background(Color.white)
                            
                            .cornerRadius(20)
                    }.opacity(0.8)
                        .shadow(radius: 20.0)
                })
                .overlay(alignment: .bottom, content: {
                    Button("\(Image(systemName: "pencil"))"){
                        isPresented.toggle()
                    }.font(Font.largeTitle)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(Color.yellow)
                        
                })
                .sheet(isPresented: $isPresented){
                                           UpdateRecipeView(recepie: recipeSelected)}
                .onAppear(){
                    viewModel.fetch()
                }
                .background(Image("2").scaledToFill().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))

        }
        .edgesIgnoringSafeArea(.all)
        
        
    }
}
