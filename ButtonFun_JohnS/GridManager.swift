//
//  GridManager.swift
//  ButtonFun_JohnS
//
//  Created by xavier on 1/13/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit
import CoreData

//CoreData Saving and Loading Grid Methods

extension GridView {
    
    //Auto save on orientaion change
    func saveGrid(name: String){
        
        //Get the Managed Context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a new Grid Entity
        let gridEntity = NSEntityDescription.entity(forEntityName: "Grid", in: managedContext)!
        let grid = NSManagedObject(entity: gridEntity, insertInto: managedContext)
        
        //Serialize the Color Data
        let data = try? JSONSerialization.data(withJSONObject: self.gridColors, options: [])
        let string = String(data: data!, encoding: String.Encoding.utf8)
        
        //Store the Values
        grid.setValue(name, forKeyPath: "name")
        grid.setValue(string,forKeyPath: "colors")
        
        //Save changes
        do {
            try managedContext.save()
            self.grids.append(grid)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func loadGrids(){
        
        //Get the Managed Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create the fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Grid")
        
        //Perform fetch
        do {
            self.grids = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func delteGrid(number: Int){
        
        //Get the Managed Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let managedObject = self.grids[number]
        
        //Perform Delte
        managedContext.delete(managedObject)
        
        //Save changes
        do {
            try managedContext.save()
            self.grids.remove(at: number)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
    
}
