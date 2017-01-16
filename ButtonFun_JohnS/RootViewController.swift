//
//  RootViewController.swift
//  ButtonFun_JohnS
//
//  Created by xavier on 1/13/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var firstSelection: UIView?
    var gridView:GridView = GridView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        
        //Set delegates
        self.gridView.delegate = self
        
        //Load saved Grids
        self.gridView.loadGrids()
        
        //Set gridView to RootView
        self.view = gridView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - View Styling
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: - Orientaion Changes
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let oldSize = self.view.frame.size
        if(oldSize.width != size.width || oldSize.height != size.height){
            self.gridView.destroyGrid()
            self.gridView.convertOrientation()
        }
    }
    
    
    //MARK: - Shake Motion
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        self.bringUpAlertViewMenu()
        
    }
    
    
    //MARK: - AlertMenu
    
    func bringUpAlertViewMenu(){
        
        //Create AlertView with UITextField
        let alertController = UIAlertController(title: "Save this Grid?", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Grid Name"
        }
        
        //Save Grid
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            guard firstTextField.text != nil else { return }
            
            self.gridView.saveGrid(name: firstTextField.text!)
            
        })
        
        //Load Grids and Segue to SavedGridsVC
        let loadAction = UIAlertAction(title: "Load", style: .default, handler: {
            alert -> Void in
            
            self.gridView.loadGrids()
            self.performSegue(withIdentifier: "loadedGrids", sender: nil)
            
        })
        
        //New Grid
        let newGrid = UIAlertAction(title: "New", style: .default, handler: {
            alert -> Void in
            
            self.gridView.destroyGrid()
            self.gridView.createGridView(size: self.gridView.frame.size)
            
        })
        
        let shareGrid = UIAlertAction(title: "Share", style: .default, handler: {
            alert -> Void in
            
            self.shareGridAsImage()
            
        })
        
        //Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(loadAction)
        alertController.addAction(newGrid)
        alertController.addAction(shareGrid)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Animations
    
    func animationDoSelection(selectedView: UIView){
        
        UIView.animate(withDuration: 0.5, animations: {
            
            selectedView.layer.cornerRadius = self.gridView.tileSize.width/5
            selectedView.layer.masksToBounds = true
            
            selectedView.layer.borderWidth = 4
            selectedView.layer.borderColor = UIColor.black.cgColor
            
        }, completion: { complete in
            self.firstSelection = selectedView
        })
        
    }
    
    func animationUndoSelection(selectedView: UIView){
        
        UIView.animate(withDuration: 0.5, animations: {
            
            selectedView.layer.cornerRadius = 0
            selectedView.layer.masksToBounds = false
            
            selectedView.layer.borderWidth = 0
            selectedView.layer.borderColor = UIColor.clear.cgColor
            
        }, completion: { complete in
            self.firstSelection = nil
        })
    }
    
    func animationDoColorChange(selectedView: UIView, toColor: UIColor){
        
        //After animation, we updates the gridView's colorGrid
        UIView.animate(withDuration: 0.2, animations: {
            
            selectedView.backgroundColor = toColor
            
        }, completion: { complete in
            
            //Update the gridViews color grid
            self.gridView.updateColorGrid(point: selectedView.frame.origin, color: toColor)
            
        })
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "loadedGrids"){
            let savedVC = segue.destination as! SavedGridsViewController
            
            //Set RootVC as delegate
            savedVC.delegate = self
            
            //Pass grid names to be displayed
            savedVC.gridNames = gridView.getGridNames()
        }
    }
    
    
    //MARK: - Sharing
    
    func shareGridAsImage() {
        
        // image to share
        let image = UIImage(view: self.view)
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // for iPads to not crash says stackoverflow
        
        // present the activityViewController
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


//MARK: - GridViewDelegate
extension RootViewController: GridViewDelegate{
    
    func viewWasTapped(tappedView: UIView) {
        
        //Check to see if we already have a view selected
        if let selctedView = self.firstSelection{
            
            //get the old selected view's color
            let newColor = selctedView.backgroundColor
            
            //Change tapped view's color
            self.animationDoColorChange(selectedView: tappedView, toColor: newColor!)
            
            //Undo old selected view's selection
            self.animationUndoSelection(selectedView: selctedView)
            
        }else{
            
            //Undo old selected view's selection
            self.animationDoSelection(selectedView: tappedView)
        }
    }
    
}

// MARK: - SavedGridsDelegate
extension RootViewController: SavedGridsDelegate{
    
    func didSelectGrid(number: Int) {
        
        //Destroy old Grid
        self.gridView.destroyGrid()
        
        //Display the selected, saved grid
        self.gridView.displayLoadedGrid(number: number)
    }
    
    func didDeleteGrid(number: Int) {
        
        self.gridView.delteGrid(number: number)
        
    }
    
}
