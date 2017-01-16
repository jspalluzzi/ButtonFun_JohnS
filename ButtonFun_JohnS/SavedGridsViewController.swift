//
//  SavedGridsViewController.swift
//  ButtonFun_JohnS
//
//  Created by xavier on 1/13/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit

protocol SavedGridsDelegate: NSObjectProtocol {
    func didSelectGrid(number: Int)
    func didDeleteGrid(number: Int)
}

class SavedGridsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Protocaled the RootViewController
    weak var delegate:SavedGridsDelegate!
    
    var gridNames:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - View Styling
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return gridNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "gridCell", for: indexPath)
        
        cell.textLabel?.text = gridNames![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //SavedGridsDelegate callback to RootViewController
        self.delegate.didSelectGrid(number: indexPath.row)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //SavedGridsDelegate callback to RootViewController
            self.delegate.didDeleteGrid(number: indexPath.row)
            
            //Remove the gridName
            self.gridNames.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    //MARK: - Buttons
    @IBAction func didPressDoneBtn(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
