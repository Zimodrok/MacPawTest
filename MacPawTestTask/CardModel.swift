import SwiftUI


struct CardView: View {
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject var personnelData: PersonnelData
    @EnvironmentObject var equipmentData: EquipmentData
    let id: Int
    var body: some View {
        if let personnelLoss = personnelData.personnelLosses.first(where: { $0.day == id + 2}) {
            if let equipmentLoss = equipmentData.equipmentLosses.first(where: { $0.day == id + 2}) {
                VStack {
                    VStack {
                        Text("\(equipmentLoss.day) days of war summary: ".uppercased())
                            .font(.system(size: 28)).bold()
                            .minimumScaleFactor(0.5)
                            .frame(alignment: .topLeading)
                            .padding(35)
                        Spacer()
                        HStack(alignment: .top){
                            Spacer()
                            VStack(alignment: .leading, spacing: 3 ){
                                Text("Personnel")
                                    .font(.system(size: 18)).bold()
                                    .minimumScaleFactor(0.5)
                                let prefix = personnelLoss.personnelPrefix
                                Text("\((prefix == "more" || prefix == "less" ? "\(prefix!.capitalized) than" : prefix?.capitalized ?? "")) \(personnelLoss.personnel ?? 0) invaders killed")
                                    .font(.system(size: 16))
                                    .minimumScaleFactor(0.5)
                                Text("Powed \(personnelLoss.POW ?? 0)")
                                    .font(.system(size: 16))
                                    .minimumScaleFactor(0.5)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 3){
                                Text("Equipment").font(.system(size: 18)).bold()
                                    .font(.title3).bold()
                                    .minimumScaleFactor(0.8)
                                Text("\(equipmentLoss.aircraft ?? 0) planes shot down")
                                Text("\(equipmentLoss.helicopter ?? 0) helicopters shot down")
                                Text("\(equipmentLoss.tank ?? 0) tanks destroyed")
                                Text("\(equipmentLoss.fieldArtillery ?? 0) field artillery pieces destroyed")
                                Text("\(equipmentLoss.drone ?? 0) drones shot down")
                            }
                            .font(.system(size: 16))
                            .minimumScaleFactor(0.8)
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(Color("AccentColor").opacity(0.15))
                    .cornerRadius(6)
                    Spacer()
                    HStack{
                        VStack(alignment: .leading) {
                            Text("Sneak peek")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(equipmentLoss.date)
                                .font(.title)
                                .minimumScaleFactor(0.5)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            Text("Detailed View".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .layoutPriority(100)
                        Spacer()
                    }
                    .padding(20)
                }
                .aspectRatio(1, contentMode: .fit)
                .background(.regularMaterial)
                .cornerRadius(8)
            } else {
                Text("Equipment data not found for day \(id)")
            }
        }
    }
}
