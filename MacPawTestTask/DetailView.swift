import SwiftUI

struct DetailView: View {
    @EnvironmentObject var personnelData: PersonnelData
    @EnvironmentObject var equipmentData: EquipmentData
    @EnvironmentObject var oryxequipmentData: ORYXEquipmentData
    @State private var OnHover = false
    @State private var OnDeclineHover = false
    @Environment(\.dismiss) var dismiss
    @State private var selectedModelID: Int = 0
    @State private var hiddenSearch = true
    
    var id: Int
    var body: some View {
        ScrollView{
            
            if let personnelLoss = personnelData.personnelLosses.first(where: { $0.day == id + 2}) {
                if let equipmentLoss = equipmentData.equipmentLosses.first(where: { $0.day == id + 2}) {
                    
                    VStack(alignment: .leading){
                        
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                            .buttonStyle(.plain)
                            .padding(20)
                            .contentShape(Rectangle())
                            .onTapGesture(count:1){
                                dismiss()
                            }
                            .onHover {over in
                                withAnimation(Animation.spring().speed(0.6)) {
                                    OnDeclineHover = over
                                }
                            }
                            .background(OnDeclineHover ? .gray.opacity(0.1) : .clear)
                            .cornerRadius(5)
                        VStack(spacing: 10) {
                            Text("DETAILS FOR DAY \(equipmentLoss.day)")
                                .font(.system(size: 28)).bold()
                                .padding(.top, 30)
                            Text("Date: \(equipmentLoss.date)")
                                .font(.system(size: 18)).monospacedDigit()
                            HStack{
                                Spacer()
                                VStack(alignment: .leading, spacing: 7 ){
                                    Text("Personnel").bold()
                                        .font(.system(size: 18)).bold()
                                    let prefix = personnelLoss.personnelPrefix
                                    Text("\((prefix ?? "" ).capitalized) \(personnelLoss.personnel ?? 0) invaders killed")
                                        .font(.system(size: 16))
                                    Text("Powed \(personnelLoss.POW ?? 0)")
                                        .font(.system(size: 16))
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 7){
                                    Text("Equipment")
                                        .font(.system(size: 18)).bold()
                                    ForEach([
                                        (equipmentLoss.aircraft, "aircrafts shot down"),
                                        (equipmentLoss.helicopter, "helicopters shot down"),
                                        (equipmentLoss.tank, "tanks destroyed"),
                                        (equipmentLoss.APC, "APCs destroyed"),
                                        (equipmentLoss.fieldArtillery, "field artillery pieces destroyed"),
                                        (equipmentLoss.MRL, "multiple rocket launchers destroyed"),
                                        (equipmentLoss.militaryAuto, "military vehicles destroyed"),
                                        (equipmentLoss.fuelTank, "fuel tanks destroyed"),
                                        (equipmentLoss.drone, "drones shot down"),
                                        (equipmentLoss.navalShip, "ships sunk"),
                                        (equipmentLoss.antiAircraftWarfare, "anti-aircraft warfare units destroyed"),
                                        (equipmentLoss.cruiseMissiles, "cruise missiles destroyed"),
                                        (equipmentLoss.specialEquipment, "special equipment destroyed"),
                                        (equipmentLoss.vehiclesAndFuelTanks, "vehicles and fuel tanks destroyed")
                                    ], id: \.0) { value, label in
                                        if let amount = value, amount != 0 {
                                            Text("\(amount) \(label)")
                                                .font(.system(size: 16))
                                        }
                                    }
                                }
                                Spacer()
                            }
                            if(equipmentLoss.greatestLossesDirection != nil){
                                Text("\(equipmentLoss.greatestLossesDirection ?? "") is a greatest losses direction")
                                    .font(.system(size: 18))
                            }
                            Divider()
                                .padding(.bottom, 10)
                                .padding(.top, 25)
                            Button(action: {
                                withAnimation(Animation.easeIn(duration: 0.2)) {
                                    hiddenSearch.toggle()
                                }
                            }) {
                                VStack {
                                    Text("Show Specific Model Information")
                                        .font(.system(size: 18)).monospacedDigit()
                                    Image(systemName: "chevron.compact.down")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                        .opacity(!hiddenSearch ? 0 : 1)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                        HStack{
                            Spacer()
                            if !hiddenSearch {
                                VStack(spacing: 10) {
                                    Text("Equipment List")
                                        .font(.system(size: 28)).bold()
                                        .padding(.top, 30)
                                    Picker("Model: ", selection: $selectedModelID) {
                                        ForEach(1..<oryxequipmentData.oryxequipmentLosses.count, id: \.self) { id in
                                            Text("\(oryxequipmentData.oryxequipmentLosses[id].model)")
                                        }
                                    }
                                    .font(.system(size: 20)).bold()
                                    .pickerStyle(.menu)
                                    .padding(.horizontal, 20)
                                    if (selectedModelID != 0) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Model name:  \(oryxequipmentData.oryxequipmentLosses[selectedModelID].model)")
                                            Text("Equipment type:  \(oryxequipmentData.oryxequipmentLosses[selectedModelID].equipmentOryx)")
                                            Text("Manufacturer: \(oryxequipmentData.oryxequipmentLosses[selectedModelID].manufacturer)")
                                            Text("Total Losses: \(oryxequipmentData.oryxequipmentLosses[selectedModelID].lossesTotal)")
                                            Text("Destroyed by Ukrainian \(oryxequipmentData.oryxequipmentLosses[selectedModelID].equipmentOryx)")
                                        }
                                        .font(.system(size: 18))
                                        .padding()
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded({ value in
                    dismiss()
                }
                        )
        )
        .frame(minWidth: 375, idealWidth: 1200, maxWidth: 1600, minHeight: 667, idealHeight: 900, maxHeight: 1200)
    }
}
