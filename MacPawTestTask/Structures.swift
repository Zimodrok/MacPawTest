import Foundation
import SwiftUI


class PersonnelData: ObservableObject {
    var personnelLosses: [PersonnelLosses] = []
}

struct PersonnelLosses: Codable {
    let date: String
    let day: Int
    let personnel: Int?
    let personnelPrefix: String?
    let POW: Int?
    
    private enum CodingKeys: String, CodingKey {
        case date
        case day
        case personnel
        case personnelPrefix = "personnel*"
        case POW
    }
}


class EquipmentData: ObservableObject {
    var equipmentLosses: [EquipmentLosses] = []
}

class EquipmentDataCorrection: ObservableObject {
    var equipmentLossesCorrection: [EquipmentLosses] = []
}

struct EquipmentLosses: Codable {
    var date: String
    var day: Int
    var aircraft: Int?
    var helicopter: Int?
    var tank: Int?
    var APC: Int?
    var fieldArtillery: Int?
    var MRL: Int?
    var militaryAuto: Int?
    var fuelTank: Int?
    var drone: Int?
    var navalShip: Int?
    var antiAircraftWarfare: Int?
    var cruiseMissiles: Int?
    var specialEquipment: Int?
    var vehiclesAndFuelTanks: Int?
    var greatestLossesDirection: String?

    private enum CodingKeys: String, CodingKey {
        case date
        case day
        case aircraft
        case helicopter
        case tank
        case APC
        case fieldArtillery = "field artillery"
        case MRL
        case militaryAuto = "military auto"
        case fuelTank = "fuel tank"
        case drone
        case navalShip = "naval ship"
        case antiAircraftWarfare = "anti-aircraft warfare"
        case cruiseMissiles = "cruise missiles"
        case specialEquipment = "special equipment"
        case vehiclesAndFuelTanks = "vehicles and fuel tanks"
        case greatestLossesDirection = "greatest losses direction"
    }
}


struct ORYXEquipmentLosses: Codable {
        let equipmentOryx: String
        let model: String
        let manufacturer: String
        let lossesTotal: Int
        let equipmentUA: String

        private enum CodingKeys: String, CodingKey {
        case equipmentOryx = "equipment_oryx"
        case model
        case manufacturer
        case lossesTotal = "losses_total"
        case equipmentUA = "equipment_ua"
    }
}

class ORYXEquipmentData: ObservableObject {
        var oryxequipmentLosses: [ORYXEquipmentLosses] = []
}


