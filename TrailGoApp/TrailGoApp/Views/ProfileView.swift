import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    var userName: String
    var userSurname: String
    
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var trailManager = TrailManager()
    @State private var showToDo: Bool = true // To toggle between To Do and Completed

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .foregroundColor(Color(hex: "#108932"))
                
                // Display user's name and surname
                Text("\(userName) \(userSurname)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Divider()
                
                VStack(spacing: 20) {
                    HStack {
                        VStack {
                            Text("To do: \(trailManager.toDoTrails.count)")
                                .font(.title3)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("✓ Completed: \(trailManager.completedTrails.count)")
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Total Metrics
                    VStack(spacing: 20) {
                        Text("Total: 2134km")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 30) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: 54 123 m")
                                    .font(.subheadline)
                            }
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: 100 days 16h")
                                    .font(.subheadline)
                            }
                        }
                    }
                    Divider()
                }
                .padding(.horizontal,10)
                
                // Buttons to toggle between "To Do" and "Completed" lists
                HStack {
                    Button(action: {
                        showToDo = true
                    }) {
                        Text("To Do")
                            .fontWeight(.semibold)
                            .padding()
                            .background(showToDo ? Color(hex: "#108932") : Color.gray.opacity(0.2))
                            .foregroundColor(showToDo ? .white : .black)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showToDo = false
                    }) {
                        Text("Completed")
                            .fontWeight(.semibold)
                            .padding()
                            .background(!showToDo ? Color(hex: "#108932") : Color.gray.opacity(0.2))
                            .foregroundColor(!showToDo ? .white : .black)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)

                if showToDo {
                    List(trailManager.toDoTrails) { trail in
                        NavigationLink(destination: TrailDetailView(trail: trail, languageManager: languageManager)) {
                            HStack {
                                Image(trail.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                                    .font(.headline)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    List(trailManager.completedTrails) { trail in
                        NavigationLink(destination: TrailDetailView(trail: trail, languageManager: languageManager)) {
                            HStack {
                                Image(trail.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                                    .font(.headline)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    trailManager.fetchData(userId: userId)
                }
            }
        }
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userName: "Jan", userSurname: "Kowalski")
            .environmentObject(LanguageManager())
    }
}
