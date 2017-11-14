//
//  CheckoutVC.swift
//  hyggely
//
//  Created by Shamsheer on 2017-10-24.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import UIKit
import Stripe
import SVProgressHUD
import Alamofire
import FirebaseAuth

class CheckoutVC: UIViewController, STPPaymentContextDelegate, STPPaymentCardTextFieldDelegate {
    
 
    
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var payNow: UIButton!
    var userID = ""
    var service = ""
    var hostName = ""
    

    @IBAction func payNow(_ sender: Any) {
        let card = paymentTextField.cardParams
        STPAPIClient.shared().createToken(withCard: card, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                print(token)
                self.chargeUsingToken(token: token)
            }
        })
        
        /*SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        //send card information to stripe to get back a token
        getStripeToken(card: card)*/
    }
    
    
    
    func chargeUsingToken(token:STPToken) {
        
        //with response handler:
        print("DO WE EVEN MAKE IT HERE")
       
        
        var charges: Dictionary<String, Any> = ["charges" : "", "sources" : ""] //this is $3
        
        //here we add payment source
       // '/stripe_customers/{userId}/sources/{pushId}/token')
        var token : Dictionary <String, Any> = ["token" : token.tokenId]
        let tokenKey =  DBProvider.Instance.usersRef.child(self.userID + "/sources").childByAutoId()
        tokenKey.updateChildValues(token)
      
        //this will execute create stripe charge  //'/stripe_customers/{userId}/charges/{id}')
     DBProvider.Instance.usersRef.child(self.userID).updateChildValues(charges)
        let num = 300 as Int
        let amount : Dictionary <String, Any> = ["amount" : num]//, "source" : token.]
    
       let chargeKey = DBProvider.Instance.usersRef.child(self.userID + "/charges").childByAutoId()
        
        chargeKey.updateChildValues(amount)
        
        
        if (chargeKey.value(forKey: "paid") as! Bool == true)
        {
            //payment complete
            //write to db what was bought
            let purchase : Dictionary <String, Any> = ["hostName" : hostName, "service" : service, "paid" : true]
            DBProvider.Instance.ridersRef.child(self.userID).updateChildValues(purchase)
            
            let alertController = UIAlertController(title: "Payment Complete", message:
                "Your payment has been processed. Access your host from the chat or meetup navigation items.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            let storyboardd : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboardd.instantiateViewController(withIdentifier: "Home") as! FirstViewController
            self.present(nextVC, animated: false, completion: nil)

            
        }

        
        print ("charges code has been executed")
        
       
    }
    
    var paymentTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        // add stripe built-in text field to fill card information in the middle of the view
        super.viewDidLoad()
        userID = (Auth.auth().currentUser?.uid)!

        paymentTextField.frame = CGRect(x:15, y:199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
      /*  let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
       
        
        paymentTextField = STPPaymentCardTextField(frame: frame1)
        paymentTextField.center = view.center
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        //disable payButton if there is no card information*/
        payNow.isEnabled = false
        
    }
   
   
    let paymentContext: STPPaymentContext = STPPaymentContext()
    
    //let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
   
    let myAPIClient = MyAPIClient()
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        if textField.isValid {
            payNow.isEnabled = true;
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.payNow.isEnabled = paymentContext.selectedPaymentMethod != nil
        self.paymentLabel.text = paymentContext.selectedPaymentMethod?.label
    }
    
    func getStripeToken(card:STPCardParams) {
        // get stripe token for current card
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                print(token)
                SVProgressHUD.showSuccess(withStatus: "Stripe token successfully received: \(token)")
                self.postStripeToken(token: token)
            } else {
                print(error)
                //SVProgressHUD.showError(errorwithStatus: ?.localizedDescription)
            }
        }
    }
    
    
    func postStripeToken(token: STPToken) {
        //Set up these params as your backend require
        let params: [String: NSObject] = ["stripeToken": token.tokenId as NSObject, "amount": 10 as NSObject]
        
        //TODO: Send params to your backend to process payment
        
    }
 
    
    func choosePaymentButtonTapped() {
        self.paymentContext.presentPaymentMethodsViewController()
    }

    
    func payButtonTapped() {
        self.paymentContext.requestPayment()
    }
    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
       
    }
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFailToLoadWithError error: Error) {
        self.navigationController?.popViewController(animated: true)
        // Show the error to your user, etc.
    }
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Your payment has been completed!"
        case .userCancellation:
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
  
   


}
