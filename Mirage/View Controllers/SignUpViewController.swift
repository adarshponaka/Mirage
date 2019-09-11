//
//  SignUpViewController.swift
//  Mirage
//
//  Created by Adarsh Ponaka on 9/7/19.
//  Copyright © 2019 Adarsh Ponaka. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0;
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton )

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //corrent returns nil, otherwise returns error message
    func validateFields() -> String?{
        
        //check if all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        //check password
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please make sure your password is atleast 8 characters, and has a special character and number"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            // there is an error this means
            
            showError(error!)
        }else{
            
            //create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    // there is an error if it comes in here
                    self.showError("Error creating user!")
                    
                }else{
                    //user was stored s ucessfuly
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName,"uid": result!.user.uid]) { (error) in
                        
                        if error != nil{
                            self.showError("Error saving user data")
                        }
                        
                    }
                    
                    //transition to home screen
                    self.transitionToHome()
                }
                
            }
            
        }
        
    }
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
         let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
