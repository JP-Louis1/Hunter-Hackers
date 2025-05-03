//
//  ContentManager.swift
//  Front-End page
//
//  Created by Linh Yui on 5/2/25.
//

import Foundation
import SwiftUI

struct EnvironmentalMessageView: View {
    // MARK: - Message Data
    private let messages = [
        "Remember to recycle when you're done with tasks! ♻️",
        "Did you know? Completing tasks digitally saves paper! 🌳",
        "Take a short walk after completing 3 tasks - good for you and the planet! 🚶‍♂️",
        "Consider using public transport for your next outing! 🚆",
        "Turning off unused devices saves energy! ⚡",
        "Every small eco-friendly action makes a difference! 🌎",
        "Hydrate with a reusable water bottle today! 💧",
        "Meatless Mondays can reduce your carbon footprint! 🥦"
    ]
    
    // MARK: - State Management
    @State private var showMessage = false
    @State private var currentMessage = ""
    @State private var timer: Timer?
    
    // Configuration
    let initialDelay: TimeInterval
    let repeatInterval: ClosedRange<TimeInterval>
    
    init(initialDelay: TimeInterval = 5, repeatInterval: ClosedRange<TimeInterval> = 30...120) {
        self.initialDelay = initialDelay
        self.repeatInterval = repeatInterval
    }
    
    // MARK: - Main View
    var body: some View {
        Color.clear // Invisible background
            .frame(width: 0, height: 0)
            .alert("Eco Tip", isPresented: $showMessage) {
                Button("Got it!", role: .cancel) {
                    // Dismiss action
                }
            } message: {
                Text(currentMessage)
                    .multilineTextAlignment(.center)
            }
            .onAppear(perform: startMessageTimer)
            .onDisappear(perform: stopMessageTimer)
    }
    
    // MARK: - Message Functions
    private func getRandomMessage() -> String {
        return messages.randomElement() ?? "Small eco-actions create big change! 🌱"
    }
    
    private func showRandomMessage() {
        currentMessage = getRandomMessage()
        showMessage = true
    }
    
    // MARK: - Timer Control
    private func startMessageTimer() {
        // Initial message after delay
        timer = Timer.scheduledTimer(withTimeInterval: initialDelay, repeats: false) { _ in
            showRandomMessage()
            
            // Subsequent messages at random intervals
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval.random(in: repeatInterval),
                                       repeats: true) { _ in
                showRandomMessage()
            }
        }
    }
    
    private func stopMessageTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - View Modifier for Easy Use
struct EnvironmentalMessagesModifier: ViewModifier {
    let initialDelay: TimeInterval
    let repeatInterval: ClosedRange<TimeInterval>
    
    func body(content: Content) -> some View {
        ZStack {
            content
            EnvironmentalMessageView(
                initialDelay: initialDelay,
                repeatInterval: repeatInterval
            )
        }
    }
}

extension View {
    /// Adds random environmental messages to the view
    /// - Parameters:
    ///   - initialDelay: Time until first message appears (default: 5 seconds)
    ///   - repeatInterval: Range for subsequent messages (default: 30-120 seconds)
    func showEnvironmentalMessages(
        initialDelay: TimeInterval = 5,
        repeatInterval: ClosedRange<TimeInterval> = 30...120
    ) -> some View {
        self.modifier(EnvironmentalMessagesModifier(
            initialDelay: initialDelay,
            repeatInterval: repeatInterval
        ))
    }
}

// MARK: - Preview
struct EnvironmentalMessageView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Main App Content")
            .showEnvironmentalMessages(initialDelay: 2, repeatInterval: 5...10)
            .previewDisplayName("Message Demo")
    }
}
