//
//  ViewController.swift
//  AGImagePickerControllerDemo
//
//  Created by ruby on 15/4/18.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AGImagePickerControllerDelegate {
    var ipc = AGImagePickerController()
    var selectedPhotos = NSMutableArray()
    var counter = 0
    

    
    @IBOutlet weak var imgivew: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ipc.delegate = self
        
        ipc.didFailBlock = { (error) -> Void in
            self.selectedPhotos.removeAllObjects()
            print("User cacelled")
            // We need to wait for the view controller to appear first.
            let delayInSeconds :NSTimeInterval = 0.5
            let minseconds = delayInSeconds * Double(NSEC_PER_SEC)
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
            
            dispatch_after(popTime, dispatch_get_main_queue() , {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        }
        ipc.didFinishBlock = { (info) -> Void in
            self.selectedPhotos.setArray(info)
            print("\(info)")

         //   self.imgivew.image = urlis
            
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        }
    }
    
    @IBAction func btnActionCounter(sender: UIButton) {
        
        
        
        if counter < self.selectedPhotos.count
        {
            
            let urlis = self.selectedPhotos.objectAtIndex(counter) as! ALAsset
            self.imgivew.image = UIImage(CGImage: urlis.thumbnail().takeUnretainedValue())
            
            counter += 1

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartImportButtonPressed(sender: AnyObject) {
        
        // Show saved photos on top
        ipc.shouldShowSavedPhotosOnTop = false
        ipc.shouldChangeStatusBarStyle = true
        ipc.selection = self.selectedPhotos as [AnyObject]
        
        // Custom toolbar items
        let selectAllSysButton = UIBarButtonItem(title: "+ Select All", style: .Bordered, target: nil, action: nil)
        let selectAll = AGIPCToolbarItem(barButtonItem: selectAllSysButton) { (index, asset) -> Bool in
            return true
        }
        
        let flexibleSysButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let flexible = AGIPCToolbarItem(barButtonItem: flexibleSysButton, andSelectionBlock: nil)
        
        let selectOddSysButton = UIBarButtonItem(title: "+ Select Odd", style: .Bordered, target: nil, action: nil)
        var selectOdd = AGIPCToolbarItem(barButtonItem: selectOddSysButton) { (index, asset) -> Bool in
            return true
        }
        
        let deselectAllSysButton = UIBarButtonItem(title: "- Deselect All", style: .Bordered, target: nil, action: nil)
        let deselectAll = AGIPCToolbarItem(barButtonItem: deselectAllSysButton) { (index, asset) -> Bool in
            return false
        }
        
        ipc.toolbarItemsForManagingTheSelection = [ selectAll, flexible, deselectAll]
        
        self.presentViewController(ipc, animated: true, completion: nil)
    }
    
    //AGImagePickerControllerDelegate
    func agImagePickerController(picker: AGImagePickerController!, numberOfItemsPerRowForDevice deviceType: AGDeviceType, andInterfaceOrientation interfaceOrientation: UIInterfaceOrientation) -> UInt {
        if deviceType == AGDeviceType.TypeiPad {
            if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
                return 7
            }
            else {
                return 6
            }
        }
        
        if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
            return 5
        }
        else {
            return 4
        }
    }
    
    func agImagePickerController(picker: AGImagePickerController!, shouldDisplaySelectionInformationInSelectionMode selectionMode: AGImagePickerControllerSelectionMode) -> Bool {
        return (selectionMode == AGImagePickerControllerSelectionMode.Single ? false : true)
    }
    
    func agImagePickerController(picker: AGImagePickerController!, shouldShowToolbarForManagingTheSelectionInSelectionMode selectionMode: AGImagePickerControllerSelectionMode) -> Bool {
        return (selectionMode == AGImagePickerControllerSelectionMode.Single ? false : true)
    }
    
    func selectionBehaviorInSingleSelectionModeForAGImagePickerController(picker: AGImagePickerController!) -> AGImagePickerControllerSelectionBehaviorType {
        return AGImagePickerControllerSelectionBehaviorType.Radio
    }
    
}

