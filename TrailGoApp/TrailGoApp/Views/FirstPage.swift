//
//  FirstPage.swift
//  TrailGoApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }

    init() {
        self.selectedLanguage = Locale.current.languageCode ?? "en"
    }

    func setLanguage(_ language: String) {
        self.selectedLanguage = language
    }
}

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}



struct FirstPage: View {
    @State var selection = 0
    @StateObject var languageManager = LanguageManager()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(hex: "#108932"))
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    var body: some View {
        VStack{
            NavigationView{
                VStack (alignment: .leading){
                    HStack {
                        Spacer()
                        Picker("Language", selection: $languageManager.selectedLanguage) {
                            Text("English").tag("en")
                            Text("Polski").tag("pl")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: languageManager.selectedLanguage) { newValue in
                            languageManager.setLanguage(newValue)}
                        .frame(width: 150)
                    }.padding(.trailing)

                    TabView(selection: $selection) {
                        ContentView(languageManager: languageManager)
                                    .tabItem {
                                        Label("Explore", systemImage: "map")
                                    }.tag(0)

                        TrailsListView(languageManager: languageManager)
                                    .tabItem {
                                        Label("Your Trails", image: selection == 1 ? "routingColor" : "routingGrey")
                                    }.tag(1)

                        ProfileView()
                                    .tabItem {
                                        Label("Your Profile", systemImage: "person")
                                    }.tag(2)
                            .environmentObject(languageManager)

                    }.tint(Color(hex: "#108932"))
                    .navigationTitle("TrailGO")
                }
                
            }
        }
    }
}




#Preview {
    FirstPage()
}


