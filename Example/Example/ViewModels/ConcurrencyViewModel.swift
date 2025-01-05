//
//  URLProcessorViewModel.swift
//  Example
//
//  Created by Nuno Dias on 05/01/2025.
//


import SwiftUI

class ConcurrencyViewModel: ObservableObject {
    @Published var progress: [String: Bool] = [:] // Tracks completion for each URL
    @Published var allCompleted = false          // Indicates when all tasks are done
    
    /// Processes an array of URLs asynchronously.
    func processURLs(_ urls: [String], maxConcurrent: Int? = nil) async {
        allCompleted = false
        progress = urls.reduce(into: [:]) { $0[$1] = false } // Initialize progress
        
        await withTaskGroup(of: Void.self) { group in
            let semaphore = maxConcurrent != nil ? AsyncSemaphore(maxConcurrent!) : nil
            
            for url in urls {
                group.addTask {
                    if let semaphore = semaphore { await semaphore.wait() }
                    
                    defer { semaphore?.signal() }
                    await self.performWork(for: url)
                }
            }
        }
        
        // Mark all tasks as completed
        await MainActor.run { self.allCompleted = true }
    }
    
    /// Simulates asynchronous work for a URL.
    private func performWork(for url: String) async {
        // Simulate network work
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate a 1-second delay
        
        // Update progress on the main thread
        await MainActor.run { progress[url] = true }
    }
}
