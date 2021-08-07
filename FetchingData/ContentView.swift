//
//  ContentView.swift
//  FetchingData
//
//  Created by Joshua Curry on 8/7/21.
//

import SwiftUI

struct ContentView: View {
    @State private var users: [BreakingBadChar] = []
    var body: some View {
        
        List(users){ user in
            Text(user.name)
        }
        .onAppear(perform: {
            if let url = URL(string: "https://breakingbadapi.com/api/characters"){
                URLSession.shared.dataTask(with: url) { data, response, networkError in
                    if let networkError = networkError {
                        print(networkError.localizedDescription)
                    }
                    else {
                        if let data = data {
                            let decoder = JSONDecoder()
                            do {
                                let users = try decoder.decode([BreakingBadChar].self, from: data)
                                self.users = users
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }.resume()
            }
            
        })
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
}

struct Address: Decodable{
    var street : String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
}

struct Geo: Decodable {
    var lat: String
    var lng: String
}

struct BreakingBadChar: Decodable, Identifiable {
    var id: Int
    var name: String
    var img: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name = "name"
        case img
    }
}

//extension BreakingBadChar: Identifiable {
//    var id: Int {
//        return char_id
//    }
//}
