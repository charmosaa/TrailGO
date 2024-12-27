//
//  TrailManager.swift
//  TrailGoApp
//
//  Created by Martyna Lopianiak on 27/12/2024.
//

import Combine
import Foundation


class TrailManager: ObservableObject {
    @Published var trails: [Trail] = []
    @Published var toDoTrailIds: [String] = []
    @Published var completedTrailIds: [String] = []
    
    var toDoTrails: [Trail] {
        trails.filter { toDoTrailIds.contains($0.id) }
    }
    
    var completedTrails: [Trail] {
        trails.filter { completedTrailIds.contains($0.id) }
    }
    
    func fetchData(userId: String) {
        // Fetch all trails
        FirestoreService.shared.fetchTrailsFromFirestore { [weak self] fetchedTrails in
            DispatchQueue.main.async {
                self?.trails = fetchedTrails
            }
        }
        
        // Fetch To Do Trail IDs
        FirestoreService.shared.fetchToDoTrailIds(userId: userId) { [weak self] ids in
            DispatchQueue.main.async {
                self?.toDoTrailIds = ids
            }
        }
        
        // Fetch Completed Trail IDs
        FirestoreService.shared.fetchCompletedTrailIds(userId: userId) { [weak self] ids in
            DispatchQueue.main.async {
                self?.completedTrailIds = ids
            }
        }
    }
}
