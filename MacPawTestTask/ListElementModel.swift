import SwiftUI

    // required in task
struct ListView: View {
    @EnvironmentObject var personnelData: PersonnelData
    @EnvironmentObject var equipmentData: EquipmentData
    let id: Int
    var body: some View {
        if let equipmentLoss = equipmentData.equipmentLosses.first(where: { $0.day == id + 2}) {
            HStack(spacing: 20){
                VStack{
                    Spacer()
                    Text(equipmentLoss.date)
                        .font(.system(size: 18))
                    Spacer()
                    let delta = (personnelData.personnelLosses[id].personnel ?? 0) - (personnelData.personnelLosses[id - 1].personnel ?? 0)
                    Text("+ \(delta)")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .opacity(0.5)
                    Spacer()
                }
                Spacer()
                ForEach([
                    (equipmentLoss.aircraft, "aircrafts"),
                    (equipmentLoss.helicopter, "helicopters"),
                    (equipmentLoss.tank, "tanks"),
                    (equipmentLoss.APC, "APCs"),
                    (equipmentLoss.fieldArtillery, "field artillery"),
                    (equipmentLoss.fuelTank, "fuel tanks"),
                    (equipmentLoss.drone, "drones"),
                    (equipmentLoss.navalShip, "ships"),
                    (equipmentLoss.cruiseMissiles, "cruise missiles")
                ], id: \.0) { value, label in
                    if let amount = value, amount != 0 {
                        Text("\(amount) \(label)")
                            .font(.system(size: 14))
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .padding(10)
        }
    }
}
