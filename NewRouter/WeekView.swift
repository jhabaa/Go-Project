//
//  WeekView.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 25/01/2022.
//

import SwiftUI

struct WeekView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
            ScrollView{
                
                VStack{
                    ForEach(viewModel.days, id: \.self) {
                        day in AddRecipeTodayOnly(day: day, recipe: day.recepie_name)
                    }
                    
                }.padding(.top, 80)
            }
            .overlay(alignment: .top, content: {
                Section{
                    Text("This Week \(Image(systemName: "calendar"))")
                        .font(Font.largeTitle)
                        .tint(Color.black)
                        .padding()
                }.background(Color.white)
                    .cornerRadius(20)
                    .opacity(0.7)
            })
            .onAppear{
                viewModel.fetchDays()
        }
        .tabItem{Label("Week", systemImage: "calendar.circle.fill")}
        .tint(Color.blue)
    }
}

struct AddRecipeTodayOnly: View{
    var day:Day
    var recipe:String
    @State var recepieForDay:String = ""
    @State private var showingConfirmation = false
    @StateObject var viewModel = ViewModel()
    var body: some View{
        HStack{
            GroupBox(label: Label("\(day.day)", systemImage:"cart")) {
                HStack{
                    TextField("\(day.recepie_name)", text: $recepieForDay)
                        .multilineTextAlignment(.center)
                        .tint(Color.blue)
                        .font(Font.title)
                    Button("\(Image(systemName: "arrow.triangle.2.circlepath.doc.on.clipboard"))"){
                        showingConfirmation = true
                        }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                        .confirmationDialog("Change Recipe", isPresented: $showingConfirmation) {
                            ForEach(viewModel.recepies, id: \.self){
                                recepie in HStack{
                                    Button("\(recepie.name)"){
                                        recepieForDay = recepie.name
                                        viewModel.UpdateRecipeOfTheDay(day: day, recipeForTheDay: recepieForDay)
                                    }
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Select a new Recipe")
                        }
                }.onAppear(perform: viewModel.fetch)
            }.cornerRadius(50)
                .groupBoxStyle(.automatic)
            
        }
    }
}
