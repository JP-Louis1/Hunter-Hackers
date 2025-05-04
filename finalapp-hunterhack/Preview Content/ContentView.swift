//
//  ContentView.swift
//  finalapp-hunterhack
//
//  Created by Linh Yui on 5/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showDailyChallenge = false
    @State private var showEcoTips = false
    @State private var currentTipIndex = 0
    
    let ecoTips = [
        "Did you know? Recycling one aluminum can saves enough energy to run a TV for 3 hours!",
        "A single reusable water bottle can save 156 plastic bottles annually.",
        "Turning off lights when not in use can reduce energy consumption by up to 15%.",
        "Plant-based meals have a significantly lower carbon footprint than meat-based ones."
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dark purple background (72, 49, 157)
                Color(red: 72/255, green: 49/255, blue: 157/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // App Header
                    VStack(spacing: 15) {
                        Image(systemName: "tree.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Clean Living")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Track your personal and city footprint!")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 40)
                    
                    // Main Action Cards
                    VStack(spacing: 20) {
                        // Daily Challenge Card
                        Button(action: { showDailyChallenge = true }) {
                            ActionCard(
                                icon: "flag.fill",
                                title: "Daily Challenge",
                                subtitle: "Complete today's eco mission",
                                color: .green
                            )
                        }
                        
                        // Eco Tips Card
                        Button(action: {
                            showEcoTips = true
                            currentTipIndex = (currentTipIndex + 1) % ecoTips.count
                        }) {
                            ActionCard(
                                icon: "lightbulb.fill",
                                title: "Eco Tip",
                                subtitle: ecoTips[currentTipIndex],
                                color: .blue
                            )
                        }
                        
                        // Progress Card
                        ActionCard(
                            icon: "chart.bar.fill",
                            title: "Your Impact",
                            subtitle: "42 plastic bottles saved this month",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Bottom Icon Buttons
                    HStack(spacing: 80) {
                        // Settings Button
                        Button(action: {}) {
                            VStack {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                Text("Settings")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Map Button
                        Button(action: {}) {
                            VStack {
                                NavigationLink {
                                    AirQualityView()  // From another file
                                } label: {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 30))
                                    .foregroundColor(.white)}
                                Text("Map")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // CO2 Button
                        Button(action: {}) {
                            VStack {
                                NavigationLink {
                                    CarbonView()  // From another file
                                } label: {
                                    Image(systemName: "fina")
                                        .font(.system(size: 30))
                                    .foregroundColor(.white)}
                                Text("Footprint")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .sheet(isPresented: $showDailyChallenge) {
                DailyChallengeView()
            }
            .sheet(isPresented: $showEcoTips) {
                EcoTipsView(tip: ecoTips[currentTipIndex])
            }
        }
    }
}

// Reusable Action Card Component
struct ActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

// Daily Challenge View
struct DailyChallengeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 72/255, green: 49/255, blue: 157/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "medal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                        .padding(.top, 30)
                    
                    Text("Today's Challenge")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Use public transportation or carpool instead of driving alone")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("+25 Eco Points")
                        .font(.title3)
                        .foregroundColor(.yellow)
                        .padding()
                    
                    Button(action: {}) {
                        Text("I Completed This!")
                            .font(.headline)
                            .foregroundColor(Color(red: 72/255, green: 49/255, blue: 157/255))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Daily Challenge")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Eco Tips View
struct EcoTipsView: View {
    let tip: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 72/255, green: 49/255, blue: 157/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .padding(.top, 30)
                    
                    Text("Did You Know?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(tip)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Learn More")
                            .font(.headline)
                            .foregroundColor(Color(red: 72/255, green: 49/255, blue: 157/255))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Eco Tip")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
