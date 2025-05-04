import MapKit
import SwiftUI
import XCAAQI

struct AirQualityView: View {
    
    @State var vm = AppViewModel()
    
    var body: some View {
        Map(position: $vm.position, selection: $vm.selection) {
            ForEach(vm.annotations) {aqi in Annotation(aqi.aqiDisplay, coordinate: aqi.coordinate){
                CircleAQIView(aqi: aqi, isSelected: aqi == vm.selection)
            }
            .tag(aqi)
            .annotationTitles(.hidden)
            }
        }
        .mapStyle(.hybrid(elevation: .flat, pointsOfInterest: .all, showsTraffic: false))
        .mapControls{
            MapUserLocationButton()
            MapCompass()
        }
        .sheet(isPresented: .constant(true)) {
            ScrollView{
                VStack {
                    if let selection = vm.selection{
                        selectedAQIView(aqi: selection)
                    } else {
                        if vm.locationStatus == .requestingAQIConditions {
                            ProgressView("Requesting AQI Conditions...")
                        }
                        if vm.locationStatus == .requestingLocation{
                            ProgressView("Requesting Current Location...")
                        }
                        if case let .locationNotAuthorized(text) = vm.locationStatus{
                            Text(text)
                        }
                        if case let .error(text) = vm.locationStatus{
                            Text(text)
                        }
                    }
                }
                .padding()
                .safeAreaPadding(.top)
                .presentationDetents([.height(24), .height(176)], selection: $vm.presentationDetent)
                .presentationBackground(.ultraThinMaterial)
                .presentationBackgroundInteraction(.enabled(upThrough: .height(176)))
                .interactiveDismissDisabled()
            }
            .navigationTitle("Clean Living AirQuality IDX")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar )
        }
    }
        func selectedAQIView(aqi: AQIResponse) -> some View {
            HStack{
                CircleAQIView(aqi: aqi, size: CGSize(width: 80, height: 80))
                VStack(alignment: .leading){
                    Text("Coordinate: \(aqi.coordinate.latitude), \(aqi.coordinate.longitude)")
                    Text(aqi.category)
                    Text("Pollutants: \(aqi.dominantPollutant)")
                    Text(aqi.aqiDisplay)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
    }
    
#Preview {
        NavigationStack{
            AirQualityView(vm: .init(radiusNArray: [(4000,1), (8000,2)]))
        }
    }

