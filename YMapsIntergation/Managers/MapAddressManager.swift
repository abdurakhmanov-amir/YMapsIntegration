//
//  MapAddressManager.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import Foundation
import CoreData
import UIKit

class MapAddressManager: AddressManager {
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    init() {
    }
    
    
    func save(_ address: AddressModel) {
        let addressEntity = AddressEntity(context: container.viewContext)
        addressEntity.title = address.title
        addressEntity.address = address.address
        addressEntity.longitude = address.geometry?.point?.longitude ?? 0
        addressEntity.latitude = address.geometry?.point?.latitude ?? 0
        
        do {
            try container.viewContext.save()
        }
        catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func getAddresses() -> [AddressModel] {
        let request = AddressEntity.fetchRequest()
        
        do {
            var addressEntities = try container.viewContext.fetch(request)
            var addresses  = addressEntities.map {entity in
                return AddressModel(entity.title ?? "", entity.address ?? "", entity.longitude, entity.latitude)
            }
            
            return addresses
        }
        catch {
            print("\(error.localizedDescription)")
        }
        
        return []
    }
    
    func delete(_ address: AddressModel) {
        let context = container.viewContext
        let request = AddressEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", address.title)
        request.predicate = NSPredicate(format: "address = %@", address.address)
        request.returnsObjectsAsFaults = false

            do {
                let results = try context.fetch(request)

                if results.count > 0 {

                    for result in results {

                        print ("Note:")
                        if let designation = result.value(forKey: "designation") {
                            print("Designation: \(designation)")
                        }

                          context.delete(result)

                         do {
                             try context.save()
                         } catch {
                             print("failed to delete address")
                         }
                    }
                }
            } catch {
                print ("\(error.localizedDescription)")
            }
    }
}
