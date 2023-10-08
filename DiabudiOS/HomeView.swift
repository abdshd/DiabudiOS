//
//  HomeView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-06.
//

import SwiftUI
import Amplify
import Charts

struct HomeView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var itemModel = ItemsViewModel()
    @ObservedObject var sugarModel = SugarViewModel()
    
    let user: AuthUser
    
    @State private var isSettingsVisible = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome back, Abdullah!")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Chart(sugarModel.data) {
                    LineMark(
                        x: .value("Time", $0.time ..< $0.time.advanced(by: 300)),
                        y: .value("Sugar", $0.sugarLevel)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2.0))
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .red, location: 0),
                            .init(color: .green, location: 4/10),
                            .init(color: .red, location: 8/10)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                    .interpolationMethod(.catmullRom)
                }

                .chartXAxis {
                    AxisMarks(preset: .aligned, position: .bottom, values:.stride(by: .hour)) { value in
                        AxisValueLabel(format: .dateTime.hour()).foregroundStyle(.gray)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [50, 100, 150, 200, 250, 300]) {
                        AxisValueLabel().foregroundStyle(.gray)
                        AxisGridLine()
                    }
                }
                .padding(16)
                .chartYScale(domain: [50, 300])
                .chartPlotStyle { plotArea in
                    plotArea.frame(maxWidth: .infinity, minHeight: 250.0, maxHeight: 250.0)
                }
                .task {
                    await sugarModel.listSugarData()
                }
                
                Text("Your blood sugar is \(sugarModel.getSugarStatus())!")
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Rectangle()
                        .fill(sugarModel.getSugarColor())
                        .shadow(radius: 3)
                        .cornerRadius(10))
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .navigationBarItems(
                trailing: Button(action: {
                    isSettingsVisible.toggle()
                }) {
                    Image(systemName: "gear")
                }
            )
            .sheet(isPresented: $isSettingsVisible) {
                NavigationView {
                    SettingsView(isSettingsVisible: $isSettingsVisible)
                        .navigationBarTitle("Settings")
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Button(action: {
                                    isSettingsVisible.toggle()
                                }) {
                                    Image(systemName: "chevron.compact.down")
                                        .font(.title)
                                }
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        HomeView(user: DummyUser())
    }
}
