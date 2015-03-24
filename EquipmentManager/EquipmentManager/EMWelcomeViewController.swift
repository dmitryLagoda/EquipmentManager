//
//  EMWelcomeViewController.swift
//  EquipmentManager
//
//  Created by lsd on 3/20/15.
//  Copyright (c) 2015 lsd. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class EMWelcomeViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate
{
    @IBOutlet weak var m_UserLogoButton: UIButton!

    
//MARK: - UIViewController
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil)
        {
            var logInController = PFLogInViewController()
            logInController.logInView.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage")!)
            //logInController.logInView.usernameField.backgroundColor = UIColor.darkGrayColor()
            //logInController.logInView.logo = UIImageView(image: UIImage(named: "Logo"))
            //logInController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//            logInController.logInView.alpha = 0.8
            logInController.delegate = self
            
            var signUpController = PFSignUpViewController()
            signUpController.delegate = self
            
            logInController.signUpController = signUpController
            
            self.presentViewController(logInController, animated:true, completion: nil)
        }
    }
    
    
//MARK: - PFLogInViewControllerDelegate protocol
    
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser!) -> Void
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Sent to the delegate to determine whether the log in request should be submitted to the server.
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool
    {
        // Check if both fields are completed
        if (username != nil && password != nil && !username.isEmpty && !password.isEmpty)
        {
            return true
        }
        
        UIAlertView(title: "Missing information", message: "Make sure you fill out all of the information!", delegate: nil, cancelButtonTitle: "OK").show()
        
        return false
    }

// MARK: - PFSignUpViewControllerDelegate protocol
    
    // Sent to the delegate to determine whether the sign up request should be submitted to the server.
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!)
    {
        NSLog("User dismissed the signUpViewController");
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool
    {
        var bInfoIsComplete = true
        
        for (key, value) in info
        {
            var sValue = value as String
            if sValue.isEmpty
            {
                bInfoIsComplete = false
                break
            }
        }
        
        if (!bInfoIsComplete)
        {
             UIAlertView(title: "Missing information", message: "Make sure you fill out all of the information!", delegate: nil, cancelButtonTitle: "OK").show()
        }
        
        return bInfoIsComplete
    }
    
    @IBAction func onUserLogoButton(sender: AnyObject)
    {
        PFUser.logOut()
        self.navigationController?.popViewControllerAnimated(true)
    }

}
