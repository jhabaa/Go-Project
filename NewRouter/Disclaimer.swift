//
//  Disclaimer.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 26/01/2022.
//

import SwiftUI

struct Disclaimer: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false
    var body: some View {
        
        VStack{
            Image("isib").resizable()
            Text("This app is in development, it could make fire in your kitchen or shave your cat. 😄\n Use with caution").font(Font.largeTitle)
                .textFieldStyle(.roundedBorder).padding()
                .multilineTextAlignment(.center)
            Button("Enter anyway")
            {
                isPresented.toggle()
            }.buttonStyle(.borderedProminent)
                .font(Font.largeTitle)
                .tint(Color.red)
            .fullScreenCover(isPresented: $isPresented){
                Tab()
            }
        }
    }
}


