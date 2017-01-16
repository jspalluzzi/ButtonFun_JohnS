ButtonFun
=========

### Requirements
*	Develop a universal iOS app with no status bar with the name “Button Fun”. 
    --Universal app, No Status bar in any views, "Button Fun" in name.

* Fill the screen with 40 px x 40 px random colored squares laid out in a grid. 
    --All square as 40px x 40px. Colors choosen randomly from a set.
    
* When the user presses a square, change the color of the square to a new one. 
    --When user selects square, it changes it's attributes to indicate selection.
    --When user selects next square, it changes to the same color of the first.

* Handle all device orientations 
    --Handles both protrait and landscape, by doing a NxM to MxN transpose of the grid

* Make the code as reusable as possible.
    --Created a custom GridView with protocal to comumicate with the RootView

* Bonus points, try not to use UIButtons 
    --No UIButtons used

### Extra
--Shake gesture brings up AlertView menu
--You can save and load past Grids
--View your saved grids in SavedGridsViewController (uses UITableView)
--Utalized CoreData and JSONSerialization to save and load Grids

### Updates Since Saturday
--You can now share the Grid as an image
--Added Unit Tests for some of the GridView functions
--Bug fixes, no more crashing when going from Landscape to Landscape
--Added White and Dark Gray Colors


### Submission Instructions

* When complete, zip project folder and send back to us.
