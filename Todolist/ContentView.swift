//
//  ContentView.swift
//  Todolist
//
//  Created by YB on 2019/10/23.
//  Copyright © 2019 YB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
        Text("Hello World")
            Button(action:{
                
            }){
                Text("点击")
                .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
        .cornerRadius(10)
        .shadow(radius: 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
