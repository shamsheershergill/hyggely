//
//  UserPrefVC.swift
//  hyggely
//
//  Created by Shamsheer on 2017-10-11.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import AssetsLibrary

class UserPrefVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    // let photoHelper = PhotoHelper()
    var profImage : UIImage!
    @IBOutlet weak var name: UITextField!
    
   // @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var desc: UITextField!
    var userID = ""
    var isHost = true
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        userID = (Auth.auth().currentUser?.uid)!
       imagePickerController.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("WE ARE PICKING AN IMAGE")
        profImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.contentMode = .scaleAspectFit //3
        
        profileImage.image = profImage //4
        imagePickerController.dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func profilePhotoSelect(_ sender: Any) {
        
        
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.modalPresentationStyle = .popover
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
        
}
 
    @IBAction func LocalSelected(_ sender: Any) {
        
        DBProvider.Instance.contactsRef.child(self.userID).updateChildValues(["isHost" : "false"])
        isHost = false
        performSegue(withIdentifier: "selectActivities", sender: nil)
    }
    
    @IBAction func HostSelected(_ sender: Any) {
        isHost = true
       performSegue(withIdentifier: "selectActivities", sender: nil)
    }
    
    @IBAction func setTravelerHost(_ sender: Any) {

        let imageData = UIImagePNGRepresentation(profImage)! as? NSData
        // guard let imageURL: NSURL = UIImagePickerControllerPHAsset as? NSURL else { return }
        
        // Get a reference to the location where we'll store our photos
        let photosRef = Storage.storage().reference() //DBProvider.Instance.contactsRef.child(userID)
        var URL = ""
        // Get a reference to store the file at chat_photos/<FILENAME>
       let photoRef = photosRef.child(userID + ".png")
      print ("TRYING TO STORE")
        print (photoRef)
        // Upload file to Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        photoRef.putData(imageData! as Data, metadata: nil, completion: { (metadata, error) in if error != nil { print (error) }
        else{
            let text = (metadata?.downloadURL()?.absoluteString)!
            //DBProvider.Instance.contactsRef.child(self.userID).updateChildValues(["URL" : text])
            let data: Dictionary<String, Any> = [Constants.NAME: self.name.text!, Constants.DESCRIPTION: self.desc.text!, "URL" : text];
            if (self.isHost){
                print( "host selected")
                DBProvider.Instance.driversRef.child(self.userID).setValue(data);
            }
            else{
                DBProvider.Instance.ridersRef.child(self.userID).setValue(data);
            }
            }
            
        })
        
        // Clean up picker
      
        
        performSegue(withIdentifier: "prefSegue", sender: nil)
    }

    
}


    
 /*   lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "HostorTravel"),
                self.newVC(viewController: "Preferences")]
    }()
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
        else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
            else {
                return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else{
            return orderedViewControllers.first
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let firstViewController = orderedViewControllers.first
        setViewControllers([firstViewController!], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main",
                            bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
*/


