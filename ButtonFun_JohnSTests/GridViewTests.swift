//
//  GridViewTests.swift
//  ButtonFun_JohnS
//
//  Created by xavier on 1/15/17.
//  Copyright © 2017 John. All rights reserved.
//

import XCTest
@testable import ButtonFun_JohnS

class GridViewTests: XCTestCase {
    
    let gridView = GridView()
    
    override func setUp() {
        super.setUp()
        
        //Test as a 2x2 Grid
        gridView.draw(CGRect(x: 0, y: 0, width: 80, height: 80))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Test the converstion of our grid matrix
    func testcConvertOrientation(){
        
        gridView.gridColors = [[1,2],[3,4]]
        
        gridView.convertOrientation()
        
        let answer = [[1,3],[2,4]]
        
        for i in 0..<gridView.gridColors.count{
            for j in 0..<gridView.gridColors[i].count{
                XCTAssertEqual(gridView.gridColors[i][j], answer[i][j])
            }
        }
    }
    
    //Test Tile position to 2d color index
    func testTilePositionToColorIndex(){
        
        let tilePos = CGPoint(x: 40, y: 40)
        
        let viewAnswer = gridView.tilePositionToColorIndex(position: tilePos)
        
        let confirmedAnswer = (1,1)
        
        XCTAssertEqual(viewAnswer.0, confirmedAnswer.0)
        XCTAssertEqual(viewAnswer.1, confirmedAnswer.1)
        
    }
    
}
