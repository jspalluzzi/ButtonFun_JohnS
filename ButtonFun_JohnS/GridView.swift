//
//  GridView.swift
//  ButtonFun_JohnS
//
//  Created by xavier on 1/13/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit
import CoreData

protocol GridViewDelegate: NSObjectProtocol {
    func viewWasTapped(tappedView: UIView)
}

class GridView: UIView, UIGestureRecognizerDelegate {
    
    //Protocaled the RootViewController
    weak var delegate:GridViewDelegate!
    
    //Grid Properties
    var numOfRows:Int!
    var numOfCols:Int!
    let tileSize = CGSize(width: 40, height: 40)
    let colors = [UIColor.blue, UIColor.brown, UIColor.green, UIColor.red, UIColor.cyan, UIColor.yellow, UIColor.orange, UIColor.purple, UIColor.magenta, UIColor.lightGray, UIColor.darkGray, UIColor.white]
    
    //Saved Color Values
    var gridColors:[[Int]] = []
    
    //Saved Grids
    var grids:[NSManagedObject] = []
    
    
    //MARK: - Grid Creation
    override func draw(_ rect: CGRect) {
        
        //Take the size of the View and divide it by the tileSize
        self.numOfRows = Int(ceil(rect.size.width/tileSize.width))
        self.numOfCols = Int(ceil(rect.size.height/tileSize.height))

        
        if(self.gridColors.isEmpty){
            //Create the initial Grid
            self.createGridView(size: rect.size)
        }
        
    }
    
    func createGridView(size: CGSize){
        
        //Clear gridColors
        self.gridColors.removeAll()
        
        //Loop Through Every Cell
        for i in 0..<numOfRows{
            var colors = [Int]()
            for j in 0..<numOfCols{
                
                //Get Tile Position
                let width = Int(tileSize.width)
                let height = Int(tileSize.height)
                let tilePoint = CGPoint(x: i*width, y: j*height)
                
                //Save Random Color
                let randInt = Int(arc4random_uniform(UInt32(self.colors.count)))
                colors.append(randInt)
                
                //Place Tile
                self.placeTile(point: tilePoint, color: self.colors[randInt])
                
            }
            
            //Save the colors
            self.gridColors.append(colors)
        }
    }
    
    func displayLoadedGrid(number: Int){
        
        //Get Color Info
        let gridInfo = self.grids[number]
        let gridColorInfo = gridInfo.value(forKey: "colors") as! String
        if let data = gridColorInfo.data(using: String.Encoding.utf8) {
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[Int]]
                self.gridColors = jsonArray!
            } catch {
                print("Something went wrong")
                self.createGridView(size: self.frame.size)
            }
        }
        
        //If Tiles were saved in different orientations
        if(self.numOfRows != self.gridColors.count){
            self.switchConvertOrientation()
        }
        
        //Reload Grid
        self.reloadGrid()
        
    }
    
    func reloadGrid(){
        
        //Loop Through Every Cell
        for i in 0..<self.gridColors.count{
            for j in 0..<self.gridColors[i].count{
                
                //Get Tile Position
                let width = Int(tileSize.width)
                let height = Int(tileSize.height)
                let tilePoint = CGPoint(x: i*width, y: j*height)
                
                //Load Color Number
                let colorNumber = self.gridColors[i][j]
                
                //Place Tile
                self.placeTile(point: tilePoint, color: self.colors[colorNumber])
                
            }
        }
    }
    
    func placeTile(point: CGPoint, color: UIColor){
        
        //Create UIView
        let tileView = UIView(frame: CGRect(origin: point, size: tileSize))
        tileView.backgroundColor = color
        
        //Add Tap Gesture Recognizer to UIView
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(GridView.handleTap(_:)))
        recognizer.delegate = self
        tileView.addGestureRecognizer(recognizer)
        
        //Add to SuperView
        self.addSubview(tileView)
        
    }
    
    
    //MARK: - Grid Destroy
    
    func destroyGrid(){
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
    }
    
    
    //MARK: - Grid Orientation
    func convertOrientation(){
        
        let tempGridColors = self.gridColors
        self.gridColors.removeAll()
        
        //Transpose the 2d array
        for i in 0..<self.numOfCols{
            var colors = [Int]()
            
            for j in 0..<self.numOfRows{
                
                colors.append((tempGridColors[j][i]))
                
            }
            
            //Resave the colors
            self.gridColors.append(colors)
        }
        
        //Reload Grid
        self.reloadGrid()
    }
    
    //Used when loading a color grid that was saved in a different orientation
    func switchConvertOrientation(){
        
        let tempGridColors = self.gridColors
        let tempNumOfCols = self.numOfRows!
        let tempNumOfRows = self.numOfCols!
        
        self.gridColors.removeAll()
        
        //Transpose the 2d array
        for i in 0..<tempNumOfCols{
            var colors = [Int]()
            
            for j in 0..<tempNumOfRows{
                
                colors.append((tempGridColors[j][i]))
                
            }
            
            //Resave the colors
            self.gridColors.append(colors)
        }
        
        //Reload Grid
        self.reloadGrid()
        
    }
    
    
    //MARK: - Grid Info Functions
    
    func getGridNames()-> [String]{
        
        var namesArray:[String] = []
        for grid in self.grids{
            namesArray.append(grid.value(forKey: "name") as! String)
        }
        return namesArray
    }
    
    
    //MARK: GrideViewDelegate call back to RootViewController
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        if let view = sender.view{
            self.delegate.viewWasTapped(tappedView: view)
        }
    
    }
    
    
    //MARK: - Color Grid
    func updateColorGrid(point: CGPoint, color: UIColor){
        
        //Get the color index of
        let colorArrayPosition = self.tilePositionToColorIndex(position: point)
        
        self.gridColors[colorArrayPosition.0][colorArrayPosition.1] = self.colorIndexFromInstance(color: color)
        
    }
    
    func colorIndexFromInstance(color: UIColor)-> Int{
        
        return self.colors.index(of: color)!
        
    }
    
    //MARK: - Tile Mapping
    func tilePositionToColorIndex(position: CGPoint)->(Int, Int){
        
        let i = Int(floor(position.x / CGFloat(self.tileSize.width)))
        let j = Int(floor(position.y / CGFloat(self.tileSize.width)))
        
        return (i, j)
        
    }
    
    
 

}
