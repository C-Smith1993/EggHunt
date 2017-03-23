//
//  CoreDataHelper.swift
//  EggHunt
//
//  Created by Chris Smith on 22/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import CoreData

func addAllEggs() {
    createEgg(name: "Chick", imageName: "010-chicken")
    createEgg(name: "Yellow egg", imageName: "yellowEgg")
    createEgg(name: "Classic egg", imageName: "011-easter-egg")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}


func createEgg(name: String, imageName: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let egg = Egg(context: context)
    egg.name = name
    egg.imageName = imageName
}

func getAllEggs() -> [Egg] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
    let eggs = try context.fetch(Egg.fetchRequest()) as! [Egg]
        
        if eggs.count == 0 {
            addAllEggs()
            return getAllEggs()
        }
        return eggs
    } catch {}
    return []
}


func getAllCaughtEggs() -> [Egg] {
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Egg.fetchRequest() as NSFetchRequest<Egg>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    
    do {
    let eggs = try context.fetch(fetchRequest) as [Egg]
        return eggs
    } catch {}
    return []
}


func getAllUncaughtEggs() -> [Egg] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Egg.fetchRequest() as NSFetchRequest<Egg>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    
    do {
        let eggs = try context.fetch(fetchRequest) as [Egg]
        return eggs
    } catch {}
    return []
}





































