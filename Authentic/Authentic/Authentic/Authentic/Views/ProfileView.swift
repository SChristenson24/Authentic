//
//  ProfileView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 9/22/24.
//

import SwiftUI


struct ProfileView: View {
    @State private var isExpanded = false
    @State private var selectedTab: String = "All"
    @StateObject private var userViewModel = ViewModel()

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let imageHeight = geometry.size.height / 1.45
                let iconSize: CGFloat = 90
                let iconOffset = (imageHeight - iconSize / 2)
                
                Image("profiletop")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height / 3)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.pink)
                            .frame(width: iconSize, height: iconSize)
                        
                        Image("you")
                            .resizable()
                            .scaledToFill()
                            .frame(width: iconSize, height: iconSize)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.pink, lineWidth: 3)
                            )
                        
                        HStack(spacing: 160) {
                            VStack {
                                Text("12.4k")
                                    .font(.custom("Lexend", size: 14))
                                    .foregroundColor(.black)
                                Text("Followers")
                                    .font(.custom("Lexend", size: 10))
                                    .foregroundColor(.gray)
                            }
                            VStack {
                                Text("298")
                                    .font(.custom("Lexend", size: 14))
                                    .foregroundColor(.black)
                                Text("Following")
                                    .font(.custom("Lexend", size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 50)
                        
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "gearshape")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.top, 44)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 15)
                        
                        VStack(spacing: 10) {
                            Text(userViewModel.firstName + " " + userViewModel.lastName)
                                .font(.custom("Lexend", size: 15))
                                .padding(.top, 50)
                            Text("Just for fun.")
                                .font(.custom("Lexend", size: 13))
                                .foregroundStyle(.gray)
                        }
                        .padding(.top, iconSize + 20)
                    }
                    .frame(height: iconSize + 80)
                    .offset(y: -iconOffset)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                VStack(alignment: .leading){
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)

                    HStack(spacing: 20) {
                        Button(action: {
                            selectedTab = "All"
                        }) {
                            Text("All")
                                .font(.custom("Lexend", size: 14))
                                .foregroundColor(selectedTab == "All" ? .black : .gray)
                        }
                        Button(action: {
                            selectedTab = "Photo"
                        }) {
                            Text("Photo")
                                .font(.custom("Lexend", size: 14))
                                .foregroundColor(selectedTab == "Photo" ? .black : .gray)
                        }
                        Button(action: {
                            selectedTab = "Video"
                        }) {
                            Text("Video")
                                .font(.custom("Lexend", size: 14))
                                .foregroundColor(selectedTab == "Video" ? .black : .gray)
                        }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 30)

                    if selectedTab == "All" {
                        VStack{
                            HStack {
                                Image("picyou1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image("picyou2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image("picyou3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(.horizontal, 7)
                            HStack {
                                Image("picyou4")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image("picyou5")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image("picyou6")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(.horizontal, 7)
                            HStack {
                                Image("picyou7")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image("picyou8")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image("picyou9")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(.horizontal, 7)
                        }
                    } else if selectedTab == "Photo" {
                        Text("Displaying Photo Content")
                    } else if selectedTab == "Video" {
                        Text("Displaying Video Content")
                    }
                }
                .offset(y: 4 * iconSize)
            }

            VStack {
                HStack {
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
                                    .padding(.vertical, 10)
                                    .transition(.move(edge: .trailing))
                            }
                        }
                        .padding(15)
                        .frame(maxWidth: isExpanded ? .infinity : 50, alignment: .leading)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }

                    Spacer()

                    if !isExpanded {
                        Button(action: {}) {
                            Image(systemName: "message")
                                .foregroundColor(.gray)
                                .padding(15)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .padding(.trailing, 10)
                    }
                }
                .padding(.leading, 20)

                Spacer()
                .onAppear {
                    Task {
                        await userViewModel.fetchData()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}







