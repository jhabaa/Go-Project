//
//  viewModel.swift
//  NewRouter
//
//  Created by Jean Hubert ABA'A on 25/01/2022.
//

import Foundation
class ViewModel: ObservableObject{
    @Published var recepies: [Recepie] = []
    @Published var ingredients: [Ingredient] = []
    @Published var fullRecipe: [FullRecipe] = []
    @Published var days:[Day] = []
    @Published var buys:[Buy] = []
    func fetch(){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/recepies") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self]
            data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            //convert to JSON
            do{
                let recepies = try JSONDecoder().decode([Recepie].self, from: data)
                DispatchQueue.main.async {
                    self?.recepies = recepies
                }
            }catch{
                print (error)
            }
        }
        task.resume()
    }
    
    func fetchToBuy(){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/tobuy") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self]
            data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            //convert to JSON
            do{
                let buys = try JSONDecoder().decode([Buy].self, from: data)
                DispatchQueue.main.async {
                    self?.buys = buys
                }
            }catch{
                print (error)
            }
        }
        task.resume()
    }
    
    func fetchDays(){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/week") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self]
            data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            //convert to JSON
            do{
                let days = try JSONDecoder().decode([Day].self, from: data)
                DispatchQueue.main.async {
                    self?.days = days
                }
            }catch{
                print (error)
            }
        }
        task.resume()
    }

    func fetchIngredients(){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/ingredients") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self]
            data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            //Decode JSON
            do{
                let ingredients = try JSONDecoder().decode([Ingredient].self, from: data)
                DispatchQueue.main.async {
                    self?.ingredients = ingredients
                }
            }catch{
                print (error)
            }
        }
        task.resume()
        }
    func GetRecipeAndIngredient(name:String){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/fullrecipe/\(name)" ) else {
            return
        }
        var request = URLRequest(url: url)
        //methos, body and headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body:[String: AnyHashable] = ["recepie_name": "\(name)"]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        //Make the request
        
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in guard let data = data, error == nil else{
                return
            }
            do{
                let fullRecipe = try JSONDecoder().decode([FullRecipe].self, from: data)
                DispatchQueue.main.async {
                    self.fullRecipe = fullRecipe
                }
            }catch{
                print (error)
            }
        }
        task.resume()
    }
    func GetIngredient(id:String){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/getingredient/\(id)" ) else {
            return
        }
        var request = URLRequest(url: url)
        //methos, body and headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body:[String: AnyHashable] = ["name": "\(id)"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        //Make the request
        
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in guard let data = data, error == nil else{
                return
            }
            do{
                let ingredients = try JSONDecoder().decode([Ingredient].self, from: data)
                DispatchQueue.main.async {
                    self.ingredients = ingredients
                }
            }catch{
                print (error)
            }
        }
        task.resume()
    }
    func DeleteRecipe(id:String) {
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/deleterecipe/\(id)" ) else {
            return
        }
        var request = URLRequest(url: url)
        //methos, body and headers
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body:[String: AnyHashable] = ["name": "\(id)"]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        //Make the request
        
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in guard let data = data, error == nil else{
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }catch{
                print(error)
            }
        }
        task.resume()
        
    }
    func UpdateRecipe(name:String){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/updaterecipe/\(name)" ) else {
            return
        }
        var request = URLRequest(url: url)
        //methos, body and headers
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body:[String: AnyHashable] = ["name":"\(recipeNameToGet)", "time":"\(recipeTimeToGet)","howto":"\(recipeHowToToGet)"]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        //Make the request
        
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in guard let data = data, error == nil else{
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func UpdateRecipeOfTheDay(day:Day, recipeForTheDay:String){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/week/\(day.day)/" ) else {
            return
        }
        var request = URLRequest(url: url)
        //methos, body and headers
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body:[String: AnyHashable] = ["day":"\(day.day)", "recepie_name":"\(recipeForTheDay)"]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        //Make the request
        
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in guard let data = data, error == nil else{
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}

func AddNewRecipe(recipe:Recepie){
    guard let url = URL(string: "http://\(urlServer):\(urlPort)/newrecipe") else {
        return
    }
    var request = URLRequest(url: url)
    //methos, body and headers
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body:[String: AnyHashable] = ["name": "\(recipe.name)", "time":"\(recipe.time)","howto":"\(recipe.howto)"]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    //Make the request
    
    let task = URLSession.shared.dataTask(with: request){
        data, _, error in guard let data = data, error == nil else{
            return
        }
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }catch{
            print(error)
        }
    }
    task.resume()
}

func AddNewRecipeWithIngredients(recipe:Recepie, ingredient:Ingredient, quantity:Int){
    guard let url = URL(string: "http://\(urlServer):\(urlPort)/newrecipewithingredients") else {
        return
    }
    var request = URLRequest(url: url)
    //methos, body and headers
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body:[String: AnyHashable] = ["recepie_name": "\(recipe.name)", "ingredients_name":"\(ingredient.name)","needed_quantity":quantity]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    //Make the request
    
    let task = URLSession.shared.dataTask(with: request){
        data, _, error in guard let data = data, error == nil else{
            return
        }
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }catch{
            print(error)
        }
    }
    task.resume()
}
