import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    var userName: String
    var userSurname: String
    
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var trailManager = TrailManager()
    @State private var showToDo: Bool = true // To toggle between To Do and Completed
  
     private var totalDistance: Int {
         trailManager.completedTrails.reduce(0) { $0 + $1.distance }
     }
     private var totalElevation: Int {
         trailManager.completedTrails.reduce(0) { $0 + $1.elevation }
     }
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 90, height: 85)
                    .foregroundColor(Color(hex: "#108932"))
                
                // Display user's name and surname
                Text("\(userName) \(userSurname)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Divider()
                
                VStack(spacing: 20) {
                    HStack {
                        
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "#108932"))
                            Text("To do: \(trailManager.toDoTrails.count)")
                                .font(.subheadline)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(Color(hex: "#108932"))
                            Text("Completed: \(trailManager.completedTrails.count)")
                                .font(.subheadline)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    // Total Metrics
                    VStack(spacing: 20) {
                        Text("Total: \(totalDistance)km")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        HStack() {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: \(totalElevation)m")
                                    .font(.subheadline)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: 100 days 16h")
                                    .font(.subheadline)
                            }
                        }
                    }.padding(.horizontal)
                    Divider()
                }
                
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
