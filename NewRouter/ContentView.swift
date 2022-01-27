//
//  ContentView.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 11/11/2021.
//

import SwiftUI
import UIKit


struct Recepie: Hashable, Codable{
    var name: String
    var time: String
    var howto: String
    
}
struct Day: Hashable, Codable{
    var day: String
    var recepie_name: String
}

struct Ingredient: Hashable, Codable{
    var name: String
    var calorie:Int
    var type:String
}
struct FullRecipe: Hashable,Codable{
    var recepie_name: String
    var ingredients_name: String
    var needed_quantity: Int
}

struct Buy: Hashable, Codable{
    var ingredient: String
    var quantity: Int
}

var quantityNeeded:Int = 0
var urlServer:String = "127.0.0.1"
var urlPort:String = "8080"
var idToGet: String = ""
var textToget: String = ""
var recipeNameToGet: String = ""
var recipeTimeToGet: String=""
var recipeHowToToGet:String=""



struct ContentView: View {
    @State private var showingConfirmation = false
   @State public var name: String = "test"
    @StateObject var viewModel = ViewModel()
    @State private var date = Date()
    @State private var recepieForDay: String = ""
    @State private var isPresented = false
    var body: some View {
        Disclaimer()
    }
    
    func didDismiss(){
        print("Dismissed")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// NEW RECIPE PART
struct ToggleStates {
    var oneIsOn: Bool = false
    var twoIsOn: Bool = true
}


struct NewRecipeView: View{
  @State public var recipeName:String = ""
   @State public var recipeTime: String = ""
    @State public var recipeHowTo: String = ""
    @State private var toggleStates = ToggleStates()
    @State private var topExpanded: Bool = true
    @StateObject var viewModel = ViewModel()
    @State private var showingAlert = false
    @State private var selectedIngredient:[String] = []
    @State private var isPresented = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    var body: some View{

            VStack {
                Section{
                    Button("Abord"){
                        presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(.borderedProminent).tint(Color.red)
                }
                GroupBox{
                        Label("Recipe Name ", systemImage: "leaf.fill").textFieldStyle(.roundedBorder).foregroundStyle(.green)
                        TextField("Enter name here", text: $recipeName)
                        Label("Time(in Seconds)",systemImage: "timer").foregroundStyle(.green)
                        TextField("360", text: $recipeTime)
                    Label("How To Do",systemImage: "timer")
                        TextEditor(text: $recipeHowTo).cornerRadius(15.0)
                    var recipe = Recepie(name:recipeName , time:recipeTime , howto: recipeHowTo)
                       
                }.cornerRadius(15.0)
                Section {
                    var recipe = Recepie(name:recipeName , time:recipeTime , howto: recipeHowTo)
                    Button("NEXT"){
                        AddNewRecipe(recipe: recipe)
                        isPresented.toggle()
                    }.buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                    .fullScreenCover(isPresented: $isPresented) {
                        addToRecipe(recipe: recipe)
                    }
                
                }.padding(30).background(Color.clear)
            }
            .background(Image("2").scaledToFill().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))

    }
}

struct testView: View {
    var body: some View{
        Text("Hello world")
    }
}
struct UpdateRecipeView: View{
    @State public var recipeName:String = recipeNameToGet
     @State public var recipeTime: String = recipeTimeToGet
      @State public var recipeHowTo: String = recipeHowToToGet
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    var recepie:Recepie
      var body: some View{
              VStack {
                  Button("Cancel"){
                      dismiss()
                  }.buttonStyle(.bordered)
                      Form {
                          
                          Label("Recipe Name ", systemImage: "leaf.fill").textFieldStyle(.roundedBorder)
                          TextField(recepie.name, text: $recipeName)
                              Label("Time(in Seconds)",systemImage: "timer")
                          TextField(recepie.time, text: $recipeTime)
                              Label("How To Do",systemImage: "timer")
                          TextField(recepie.howto, text: $recipeHowTo)
                          .frame(height: 400)
                          .opacity(0.8)
                      }
                  Section {
                      Button("Confirm") {
                          viewModel.UpdateRecipe(name: "\(recepie.name)")
                      }.buttonStyle(.bordered)
                      
                  }
              }
      }
}

struct addToRecipe :View{
    @Environment(\.presentationMode) var presentationMode
    var recipe:Recepie
    @Environment(\.dismiss) var dismiss
    @State private var selection = Set<Ingredient>()
    @StateObject var viewModel = ViewModel()
    @State public var quantity:Int = 0
    var body: some View{
        List{
           // Color.primary.edgesIgnoringSafeArea(.all)
            ForEach(viewModel.ingredients, id: \.self){
               ingredient in GoalRow(ingredient: ingredient, recipe: recipe)
            }
            
        }.onAppear{
            viewModel.fetchIngredients()
        }
        Button("Save Recipe"){
            presentationMode.wrappedValue.dismiss()
            dismiss()
        }.buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 30.0))
            .frame(width: .infinity, height: .infinity, alignment: .bottomLeading)
    }
}


struct GoalRow: View {

    var ingredient: Ingredient
    var recipe:Recepie
    @State private var increment: Int = 0
    @State public var quantity:Int = 0
    var body: some View {
        HStack() {
                let step = 1
                let range = 0...50
            Stepper(value: $quantity,
                            in: range,
                            step: step) {
                        Text("\(quantity)")
                Text("\(ingredient.name)")
                Button("Add"){
                    AddNewRecipeWithIngredients(recipe: recipe, ingredient: ingredient, quantity: quantity)
                }.buttonBorderShape(.roundedRectangle(radius: 30.0))
                    .buttonStyle(.bordered)
            }.padding(5)
        }
    }
}


