//
//  HomeView.swift
//  Authentic
//
//  Created by Sydney Christenson on 11/6/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        // search button
                        Button(action: {
                            withAnimation(.spring()) {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, isExpanded ? 5 : 1)
                                
                                if isExpanded {
                                    TextField("Search...", text: .constant(""))
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(.vertical, 5)
                                        .transition(.move(edge: .trailing))
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: isExpanded ? .infinity : 50, alignment: .leading)
                            .background(Color("lightgray"))
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        // message icon
                        if !isExpanded {
                            Button(action: {}) {
                                Image(systemName: "message")
                                    .foregroundColor(.gray)
                                    .padding(15)
                                    .background(Color("lightgray"))
                                    .clipShape(Capsule())
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .padding([.leading, .top], 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<10, id: \.self) { index in
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color("bpink"))
                                            .frame(width: 75, height: 75)
                                        // you to be replaced by actual user
                                        Image("you")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            //.overlay(
                                               // Circle()
                                                    //.stroke(Color.pink, lineWidth: 1)
                                           // )
                                        
                                        if index == 0 {
                                            Text("+")
                                                .font(.system(size: 30))
                                                .foregroundColor(.black)
                                                .offset(x: 25, y: 24)
                                        }
                                    }
                                    
                                    
                                    if index == 0 {
                                        Text("You")
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    } else {
                                        Text("Friend")
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    
                    .padding(.top, 20)
                    
                    // posts Section
                    VStack(spacing: 10) {
                        ForEach(0..<10, id: \.self) { index in
                            VStack {
                                ZStack {
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            HStack(spacing: 10) {
                                                Image("pp2")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxWidth: .infinity)
                                                    .clipped()
                                                    .cornerRadius(20)
                                                    .frame(width: 40, height: 40)
                                                VStack (alignment: .leading){
                                                    Text("Ava Jones")
                                                        .font(.headline)
                                                    Text("Starkville, Mississippi")
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            Spacer()
                                            Button(action: {
                                            }) {
                                                Image(systemName: "ellipsis")
                                                    .foregroundColor(.gray)
                                                    .padding(8)
                                            }
                                        }
                                        .padding([.top, .horizontal])
                                        
                                        Image("pic1")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 210)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                            .cornerRadius(20)
                                        
                                        HStack {
                                            Text("Loving the View! ")
                                                .font(.custom("Lexend-Thin", size: 14))
                                            + Text("#starkville ")
                                                .font(.custom("Lexend-Thin", size: 14))
                                                .foregroundColor(.pink)
                                            + Text("#mississippi")
                                                .font(.custom("Lexend-Thin", size: 14))
                                                .foregroundColor(.pink)
                                        }
                                        .padding([.horizontal, .bottom])
                                        .padding(.top, 8)
                                        
                                        // action buttons
                                        HStack {
                                            Button(action: {}) {
                                                HStack{
                                                    Image(systemName: "heart")
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 20))
                                                    Text("1.8k")
                                                        .font(.custom("Lexend-Thin", size: 16))
                                                        .padding(.trailing, 5)
                                                        .foregroundColor(.black)
                                                    
                                                }
                                            }
                                            
                                            Button(action: {}) {
                                                HStack{
                                                    Image(systemName: "bubble.left")
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 20))
                                                    Text("764")
                                                        .font(.custom("Lexend-Thin", size: 16))
                                                        .padding(.trailing, 5)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            
                                            Button(action: {}) {
                                                HStack{
                                                    Image(systemName: "arrow.2.circlepath")
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 20))
                                                    Text("42")
                                                        .font(.custom("Lexend-Thin", size: 16))
                                                        .padding(.trailing, 5)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            
                                            Spacer()
                                            Button(action: {}) {
                                                Image(systemName: "bookmark")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 20))
                                            }
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
    }
}


#Preview {
    HomeView()
}
