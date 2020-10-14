//
//  UnitOfMeasurePlist.swift
//  repEAT
//
//  Created by Witt, Robert on 14.10.20.
//

import Foundation

class UnitOfMeasurePlist {
    
    struct Unit {
        let code: String
        let name: String
    }
    
    private(set) var units = [Unit]()
    
    init() {
        do {
            units = try loadUnits()
        } catch {
            // TODO Error handling
        }
    }
    
    private func loadUnits() throws -> [Unit] {
        let plist = try readPlist()
        let units = plist.map { (entry) -> Unit in
            return Unit(code: entry["code"]!, name: entry["name"]!)
        }
        return units
    }
    
    private func readPlist() throws -> [[String: String]] {
        guard let path = Bundle.main.path(forResource: "UnitOfMeasures", ofType: "plist") else {
            return []
        }
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]]
        
        return plist ?? []
    }
    
}
