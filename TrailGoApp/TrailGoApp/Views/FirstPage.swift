//
//  FirstPage.swift
//  TrailGoApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI


struct FirstPage: View {
    @AppStorage("isEnglish") private var isEnglish = true
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    
    
    
    var body: some View {
        VStack{
            NavigationView{
                VStack (alignment: .leading){
                    

                    TabView {
                        ContentView()
                                    .tabItem {
                                        Label("Explore", systemImage: "map")
                                    }

                        TrailsListView()
                                    .tabItem {
                                        Label("Your Trails ", systemImage: "road.lanes")
                                    }

                        ProfileView()
                                    .tabItem {
                                        Label("Your Profile", systemImage: "person")
                                    }

                    }.tint(Color(hex: "#108932"))
                    .navigationTitle("TrailGO")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Toggle(isOn: $isEnglish) {
                                Text("PL")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            
                        }
                    }.toolbarBackground(.visible, for: .navigationBar)
                    
                }
            }
        }
    }
}


#Preview {
    FirstPage()
}


