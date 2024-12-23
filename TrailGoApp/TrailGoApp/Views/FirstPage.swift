//
//  FirstPage.swift
//  TrailGoApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI


struct FirstPage: View {
    @State var selection = 1
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
                    

                    TabView(selection: $selection) {
                        ContentView()
                                    .tabItem {
                                        Label("Explore", systemImage: "map")
                                    }.tag(0)

                        TrailsListView()
                                    .tabItem {
                                        Label("Your Trails ", image: selection == 1 ? "routingColor" : "routingGrey")
                                    }.tag(1)

                        ProfileView()
                                    .tabItem {
                                        Label("Your Profile", systemImage: "person")
                                    }.tag(2)

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


