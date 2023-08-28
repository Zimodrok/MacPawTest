import SwiftUI
import Foundation
import AppKit

struct ContentView: View {
    @ObservedObject var personnelData = PersonnelData()
    @ObservedObject var equipmentData = EquipmentData()
    @ObservedObject var equipmentDataCorrection = EquipmentDataCorrection()
    @ObservedObject var oryxequipmentData = ORYXEquipmentData()
    @State private var showLoadedData = false
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var visibleIndices: Range<Int> = 0..<0
    @State private var visibleListIndices: Range<Int> = 1..<1
    @State var showingDetail = false
    @State private var selection: Int = 0
    @Environment(\.displayScale) var displayScale
    @State private var searchQuery: String = ""
    
    static let color0 = Color(red: 72/255, green: 40/255, blue: 65/255);
    static let color1 = Color(red: 81/255, green: 52/255, blue: 79/255);
    static let color2 = Color(red: 40/255, green: 30/255, blue: 40/255);
    let gradient = Gradient(colors: [color0, color1, color2]);
    
    
    func readJSONFile(forName name: String, forParameter parameter: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "json", inDirectory: "data")
        else {
            print("Sources missed")
            return
        }
        let correctioPath = Bundle.main.path(forResource: "russia_losses_equipment_correction", ofType: "json", inDirectory: "data")
        let correctionUrl = URL(fileURLWithPath: correctioPath ?? "")
        let url = URL(fileURLWithPath: path)
        if(name == "russia_losses_personnel"){
            do {
                let personnelDataJSON = try Data(contentsOf: url)
                personnelData.personnelLosses = try JSONDecoder().decode([PersonnelLosses].self, from: personnelDataJSON)
                visibleListIndices = 1..<personnelData.personnelLosses.count
                showLoadedData = true
                
                if let index = personnelData.personnelLosses.firstIndex(where: { $0.date == parameter }) {
                    currentIndex = index
                    updateVisibleIndices(for: index)

                }
            }
            catch {
                print("Error: \(error)")
            }
        } ;if name == "russia_losses_equipment" {
            do {
                let equipmentDataJSON = try Data(contentsOf: url)
                let equipmentDataCorrectionJSON = try Data(contentsOf: correctionUrl)
                
                equipmentData.equipmentLosses = try JSONDecoder().decode([EquipmentLosses].self, from: equipmentDataJSON)
                let equipmentLossesCorrections = try JSONDecoder().decode([EquipmentLosses].self, from: equipmentDataCorrectionJSON)
                
                for correction in equipmentLossesCorrections {
                    if let index = equipmentData.equipmentLosses.firstIndex(where: { $0.date == correction.date }) {
                        equipmentData.equipmentLosses[index].aircraft = (equipmentData.equipmentLosses[index].aircraft ?? 0) + (correction.aircraft ?? 0)
                        equipmentData.equipmentLosses[index].helicopter = (equipmentData.equipmentLosses[index].helicopter ?? 0) + (correction.helicopter ?? 0)
                        equipmentData.equipmentLosses[index].tank = (equipmentData.equipmentLosses[index].tank ?? 0) + (correction.tank ?? 0)
                        equipmentData.equipmentLosses[index].APC = (equipmentData.equipmentLosses[index].APC ?? 0) + (correction.APC ?? 0)
                        equipmentData.equipmentLosses[index].fieldArtillery = (equipmentData.equipmentLosses[index].fieldArtillery ?? 0) + (correction.fieldArtillery ?? 0)
                        equipmentData.equipmentLosses[index].MRL = (equipmentData.equipmentLosses[index].MRL ?? 0) + (correction.MRL ?? 0)
                        equipmentData.equipmentLosses[index].militaryAuto = (equipmentData.equipmentLosses[index].militaryAuto ?? 0) + (correction.militaryAuto ?? 0)
                        equipmentData.equipmentLosses[index].fuelTank = (equipmentData.equipmentLosses[index].fuelTank ?? 0) + (correction.fuelTank ?? 0)
                        equipmentData.equipmentLosses[index].drone = (equipmentData.equipmentLosses[index].drone ?? 0) + (correction.drone ?? 0)
                        equipmentData.equipmentLosses[index].navalShip = (equipmentData.equipmentLosses[index].navalShip ?? 0) + (correction.navalShip ?? 0)
                        equipmentData.equipmentLosses[index].antiAircraftWarfare = (equipmentData.equipmentLosses[index].antiAircraftWarfare ?? 0) + (correction.antiAircraftWarfare ?? 0)
                        equipmentData.equipmentLosses[index].cruiseMissiles = (equipmentData.equipmentLosses[index].cruiseMissiles ?? 0) + (correction.cruiseMissiles ?? 0)
                        equipmentData.equipmentLosses[index].specialEquipment = (equipmentData.equipmentLosses[index].specialEquipment ?? 0) + (correction.specialEquipment ?? 0)
                        equipmentData.equipmentLosses[index].vehiclesAndFuelTanks = (equipmentData.equipmentLosses[index].vehiclesAndFuelTanks ?? 0) + (correction.vehiclesAndFuelTanks ?? 0)
                    }
                }
                showLoadedData = true
                if let index = equipmentData.equipmentLosses.firstIndex(where: { $0.date == parameter }) {
                    currentIndex = index
                    updateVisibleIndices(for: index)
                }
            }
            catch {
                print("Error: \(error)")
            }
        }; if(name == "russia_losses_equipment_oryx"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                oryxequipmentData.oryxequipmentLosses = try JSONDecoder().decode([ORYXEquipmentLosses].self, from: data)
                showLoadedData = true
                if let index = oryxequipmentData.oryxequipmentLosses.firstIndex(where: { $0.model == parameter }) {
                    currentIndex = index
                    updateVisibleIndices(for: index)
                }
            } catch {
                print("Error loading JSON: \(error)")
            }
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            let VW = geometry.size.width
            Rectangle()
                .fill(LinearGradient(
                    gradient: gradient,
                    startPoint: .init(x: 0.97, y: 0.69),
                    endPoint: .init(x: 0.03, y: 0.32)
                ))
                .blur(radius: 82)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                        VStack {
                            HStack{
                                Spacer()
                                TextField("Search by date...", text: $searchQuery, onCommit: {
                                    filterEquipmentData(searchQuery: searchQuery)
                                })
                                .frame(width: 100, height: 5)
                                .padding(10)
                                .background(Color(.gray).opacity(0.2))
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                                .onChange(of: searchQuery) { newValue in
                                    if newValue.isEmpty {
                                        searchQuery = ""
                                        updateVisibleIndices(for: currentIndex)
                                    }
                                }
                            }
                            
                            Picker("", selection: $selection) {
                                Text("Card").tag(0)
                                Text("List").tag(1)
                            }
                            .frame(width: 150, height: 10)
                            .pickerStyle(.segmented)
                            .padding(.top, 10)
                            .opacity(0.5)

                        if showLoadedData {
                            VStack {
                                if selection == 0 {
                                    Spacer()
                                    ZStack {
                                        ForEach(visibleIndices, id: \.self) { index in
                                            Button(action: {
                                                currentIndex = currentIndex == index ? currentIndex : index
                                                self.showingDetail.toggle()
                                            }, label: {
                                                CardView(id: index)
                                            })
                                            .buttonStyle(.plain)
                                            .frame(width : VW < 650 ?  0.72*VW : 0.36*VW)
                                            .environmentObject(personnelData)
                                            .environmentObject(equipmentData)
                                            .cornerRadius(25)
                                            .opacity(currentIndex == index ? 1.0 : 0.75)
                                            .scaleEffect(currentIndex == index ? 1.12 : 0.8)
                                            .offset(x: (VW < 650  ? 3 : 1.75) * CGFloat(index - currentIndex) * 400 + dragOffset, y: currentIndex == index ? +24 : 0)
                                            .sheet(isPresented: $showingDetail) {
                                                DetailView(id: currentIndex)
                                                    .environmentObject(personnelData)
                                                    .environmentObject(equipmentData)
                                                    .environmentObject(oryxequipmentData)
                                            }
                                        }
                                        .gesture(
                                            DragGesture()
                                                .onEnded({ value in
                                                    let threshold: CGFloat = 50
                                                    if value.translation.width > threshold {
                                                        withAnimation {
                                                            currentIndex = max(0, currentIndex - 1)
                                                            updateVisibleIndices(for: currentIndex)
                                                        }
                                                    } else if value.translation.width < -threshold {
                                                        withAnimation{
                                                            currentIndex = min(equipmentData.equipmentLosses.count - 1, currentIndex + 1)
                                                            updateVisibleIndices(for: currentIndex)
                                                            print(VW)
                                                        }
                                                    }
                                                })
                                        )
                                    }
                                    Spacer()
                                }
                                ; if selection == 1 {
                                    List {
                                        ForEach(visibleListIndices, id: \.self) { index in
                                            Button(action: {
                                                currentIndex = index
                                                showingDetail.toggle()
                                            }, label: {
                                                ListView(id: index)
                                                    .background(Color(.gray).opacity(0.2))
                                                    .cornerRadius(5)
                                            })
                                            .buttonStyle(.plain)
                                            .environmentObject(personnelData)
                                            .environmentObject(equipmentData)
                                        }
                                    }
                                    
                                    .scrollContentBackground(.hidden)
                                    .sheet(isPresented: $showingDetail) {
                                        DetailView(id: currentIndex)
                                            .environmentObject(personnelData)
                                            .environmentObject(equipmentData)
                                            .environmentObject(oryxequipmentData)
                                    }
                                }
                            }
                        }
                    }
                        .onAppear {
                            readJSONFile(forName: "russia_losses_equipment", forParameter: "2022-02-25")
                            readJSONFile(forName: "russia_losses_equipment_correction", forParameter: "2022-02-25")
                            readJSONFile(forName: "russia_losses_personnel", forParameter: "2022-02-25")
                            readJSONFile(forName: "russia_losses_equipment_oryx", forParameter: "T-62 Obr. 1967")
                        }
                )
        }
    }
    
    private func updateVisibleIndices(for currentIndex: Int) {
        let start = max(0, currentIndex - 2)
        let end = min(equipmentData.equipmentLosses.count - 1, currentIndex + 3)
        visibleIndices = start..<end
    }
    
    private func filterEquipmentData(searchQuery: String) {
        if searchQuery.isEmpty {
            updateVisibleIndices(for: currentIndex)
            currentIndex = 0
        } else {
            let filteredIndices = equipmentData.equipmentLosses.indices.filter { index in
                equipmentData.equipmentLosses[index].date.contains(searchQuery)
            }
            let minIndex = filteredIndices.min() ?? 0
            let maxIndex = filteredIndices.max() ?? 0
            visibleIndices = minIndex..<maxIndex + 1
            visibleListIndices = minIndex..<maxIndex + 1
            if !visibleIndices.contains(currentIndex) {
                currentIndex = minIndex
            }
            if !visibleListIndices.contains(currentIndex) {
                currentIndex = minIndex
            }
        }
        if selection == 1 && searchQuery.isEmpty {
            currentIndex = 0
            visibleListIndices = 1..<equipmentData.equipmentLosses.count
          }
      }
}

