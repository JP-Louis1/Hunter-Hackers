//
//  CarbonView.swift
//  finalapp-hunterhack
//
//  Created by Linh Yui on 5/4/25.
//

import SwiftUI

struct CarbonView: View {
    @State private var searchText: String = ""
    @State private var personalFootprint: Double = 12.5 // Metric tons
    @State private var neighborhoodAverage: Double = 18.7 // Metric tons
    @State private var cityAverage: Double = 15.2 // Metric tons
    @State private var selectedTimeFrame = "Weekly"
    let timeFrames = ["Daily", "Weekly", "Monthly"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 72/255, green: 49/255, blue: 157/255)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 15) {
                            Text("Carbon Footprint")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .padding(.top, 30)
                            
                            // Time frame selector
                            Picker("Time Frame", selection: $selectedTimeFrame) {
                                ForEach(timeFrames, id: \.self) { frame in
                                    Text(frame).tag(frame)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                        }
                        
                        // Personal vs Neighborhood comparison
                        VStack(spacing: 15) {
                            Text("Your \(selectedTimeFrame) Footprint")
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            // Visual comparison
                            HStack(alignment: .bottom, spacing: 20) {
                                VStack {
                                    Text("You")
                                        .foregroundColor(.white)
                                    Capsule()
                                        .fill(Color.green)
                                        .frame(width: 50, height: CGFloat(personalFootprint) * 10)
                                    Text("\(personalFootprint, specifier: "%.1f") t")
                                        .foregroundColor(.white)
                                }
                                
                                VStack {
                                    Text("Neighbors")
                                        .foregroundColor(.white)
                                    Capsule()
                                        .fill(Color.blue)
                                        .frame(width: 50, height: CGFloat(neighborhoodAverage) * 10)
                                    Text("\(neighborhoodAverage, specifier: "%.1f") t")
                                        .foregroundColor(.white)
                                }
                                
                                VStack {
                                    Text("City Avg")
                                        .foregroundColor(.white)
                                    Capsule()
                                        .fill(Color.orange)
                                        .frame(width: 50, height: CGFloat(cityAverage) * 10)
                                    Text("\(cityAverage, specifier: "%.1f") t")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.vertical)
                            
                            // Comparison message
                            if personalFootprint < neighborhoodAverage {
                                Text("You're doing better than \(Int((1 - personalFootprint/neighborhoodAverage)*100))% of your neighbors!")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("Try reducing your footprint by \(Int((personalFootprint - neighborhoodAverage)/neighborhoodAverage*100))% to match your neighbors")
                                    .foregroundColor(.yellow)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Footprint breakdown
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Footprint Breakdown")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.bottom, 5)
                            
                            FootprintCategoryView(name: "Transportation", value: 4.2, color: .red)
                            FootprintCategoryView(name: "Home Energy", value: 5.8, color: .blue)
                            FootprintCategoryView(name: "Food", value: 2.3, color: .green)
                            FootprintCategoryView(name: "Shopping", value: 0.7, color: .purple)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Tips to reduce footprint
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tips to Reduce Your Footprint")
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                TipView(icon: "car.fill", text: "Use public transport 2+ days/week")
                                TipView(icon: "thermometer", text: "Lower thermostat by 2° in winter")
                                TipView(icon: "bicycle", text: "Walk or bike for short trips")
                                TipView(icon: "leaf.fill", text: "Try meat-free meals 3 days/week")
                                TipView(icon: "bolt.fill", text: "Unplug devices when not in use")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 80) // Space for bottom buttons
                    }
                }
                
                // Bottom buttons (fixed position)
                VStack {
                    Spacer()
                    
                    HStack(spacing: 80) {
                        NavigationLink {
                            AirQualityView()
                        } label: {
                            Image(systemName: "map")
                                .font(.title)
                        }
                        
                        NavigationLink {
                            ContentView()
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title)
                        }
                        
                        NavigationLink {
                            CarbonView()
                        } label: {
                            Image(systemName: "c.circle.fill")
                                .font(.title)
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 72/255, green: 49/255, blue: 157/255))
                }
            }
        }
    }
}

struct FootprintCategoryView: View {
    let name: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.white)
                .frame(width: 120, alignment: .leading)
            
            ProgressView(value: value, total: 15)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
            
            Text("\(value, specifier: "%.1f") t")
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 50, alignment: .trailing)
        }
    }
}

struct TipView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24)
            Text(text)
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

#Preview {
    CarbonView()
}
