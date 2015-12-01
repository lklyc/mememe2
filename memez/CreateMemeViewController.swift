//
//  ViewController.swift
//  memez
//
//  Created by Kenny Leung on 10/24/15.
//  Copyright © 2015 Kenny Leung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        shareButton.enabled = false
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.becomeFirstResponder()
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.pickedImage.image = image
        }
        
        self.dismissViewControllerAnimated(true) {
            // trying a closure here
            self.shareButton.enabled = true
        }
    }

    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) -> Void{
        if bottomText.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification);
        }
        else if topText.isFirstResponder(){
            self.view.frame.origin.y = 0;
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomText.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func share(sender: AnyObject) {
        navBar.hidden = true
        topBar.hidden = true
        
        let meme = Meme(topText: topText.text, bottomText: bottomText.text, image:pickedImage.image, memedImage: generateMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        let controller = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
        
        func callBack(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void {
            // why would i want to save my meme here?
            // the activity vc is automatically dimissed
            // for now, I'll just get the nav bar to reappear
            navBar.hidden = false
            
            let alert = UIAlertController(title: "MemeMe 1.0", message: "Done!", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        controller.completionWithItemsHandler = callBack
        
        self.presentViewController(controller, animated: true, completion: nil)
        
        navBar.hidden = false
        topBar.hidden = false
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @IBAction func reset(sender: AnyObject) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        pickedImage.image = UIImage(named:  "initial.png")
    }

}

