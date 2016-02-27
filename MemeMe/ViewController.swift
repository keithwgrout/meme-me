//
//  ViewController.swift
//  MemeMe
//
//  Created by KEITH GROUT on 2/24/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // Properties
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var memeImage:UIImage?
    
    var topTextHasChanged = false
    var bottomTextHasChanged = false
    
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
        
        // set the text attributes of the text fields
        setTextFieldAttributes()
        
        // set this VC as the delegate for my TextFields
        setTextFieldDelegates()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // enable camera if available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // Actions
    
    @IBAction func cancel(sender: AnyObject) {
        restoreDefaultState()
    }
    
    @IBAction func pickImageFromSource(sender: AnyObject){
        
        let sourceType: UIImagePickerControllerSourceType!
        
        if sender as! NSObject == cameraButton {
            sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // sharing the meme with the activity view controller
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // generate a meme
        memeImage = generateMemedImage()
        
        // pass a memed image to the activity VC as an activity item
        let activityController = UIActivityViewController(activityItems: [memeImage!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        
        // save the meme upon completion
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError ) in
        
            if !completed {
                return
            }
            
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

    // Delegate Methods
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        shareButton.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // imagePickerController Delegate (dismissing the view controller, if the user cancels)
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // clear the default text when user taps the textField
    func textFieldDidBeginEditing(textField: UITextField) {
        clearDefaultText(textField)
    }
    
    // dismiss keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // moves the entire frame up by the height of the keyboard
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // moves the entire frame down by the height of the keyboard
    func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)

        }
    }
    
    
    // getting the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        // notifications carry a userInfo dictionary
        let userInfo = notification.userInfo
        
        // one of the values of userInfo is where the keyboard frame ends which is a coordinate.
        let keyboardFrameEnd = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        // we want to return the top of where the keyboard is. aka the height.
        return keyboardFrameEnd.CGRectValue().height
    }
    
    // the VC (self) will call this method in viewWillAppear:animated
    func subscribeToKeyboardNotifications() {
        
        // when each of the "name:" parameters of "addObserver" is called, the corresponding selector will be called automatically
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // we must also unsubscribe from our notifications. We will call this method inside 
    // viewWillDisappear
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    
   
    // Meme functions
    
    func save(){
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image, memedImage: memeImage)
    }
    
    // returns a snapshot of the screen to make the meme
    func generateMemedImage() -> UIImage {
        
        
        // Hide the toolbar and navbar before our photo shoot
        navBar.hidden = true
        toolBar.hidden = true
        
        // render view to an image
        
        // set the current screen as an "image context"
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        // take a snapshot of the screen ('set' the "image context")
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        // store the image context, which is a UIImage.
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the "image context"
        UIGraphicsEndImageContext()
        
        // Show the toolbar and navbar
        navBar.hidden = false
        toolBar.hidden = false
        return memedImage
    }
    
    
    
    
    
    // helper methods
    
    func setTextFieldDelegates(){
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    func setTextFieldAttributes (){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            
            // strokeWidth must be negative in order to fill text
            NSStrokeWidthAttributeName : -3.0,
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // set initial text
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        
        // center text
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    func clearDefaultText(textField:UITextField) {
        if textField == topTextField && topTextHasChanged == false {
            textField.text = ""
            topTextHasChanged = true
        } else if textField == bottomTextField && bottomTextHasChanged == false {
            textField.text = ""
            bottomTextHasChanged = true
        }
    }
    
    func restoreDefaultState(){
        imageView.image = nil
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        topTextHasChanged = false
        bottomTextHasChanged = false
    }
    
    
    
    
    
    
    
}
















