//
//  ContentView.swift
//  Front-End page
//
//  Created by Linh Yui on 5/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Image("Starry Mountain")
                .resizable()
                .frame(width: 900, height: 2000)
            
            VStack{
                Text("Clean Living")
                    .bold()
                    .italic()
                    .font(.title)
                    .foregroundColor(Color(hue: 0.811, saturation: 0.884, brightness: 0.703))
                
                Text("Click here ")
            }
            .showEnvironmentalMessages(
                initialDelay: 10,
                repeatInterval: 50...400
            )
        }
    }
}

#Preview {
    ContentView()
}
