//
//  NotesVC.swift
//  note_MohaliAle_ios
//
//  Created by Ranjeet Singh on 02/02/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class NotesVC: UIViewController, CLLocationManagerDelegate {
    
    
    // location variables
    var locManager = CLLocationManager()
    
    
    
    
    @IBOutlet weak var showDetail: UIBarButtonItem!
    
    
    
    
    
    
    @IBOutlet weak var detailBtn: UIBarButtonItem!
    
    //MARK: - outlets of ther view controller
    @IBOutlet weak var showLocationBtn: UIButton!
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    

    // MARK: Context and Array created
    
    var notes = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var latitude:Double!
    var longitude:Double!
    
    //MARK: crateing the variable if for selected note
    
    var selectedNotes : Note?{
        didSet{
            editNote = true
        }
    }
    
    
    // boolean value to check if the note is editable or the new note
    var editNote: Bool = false
    
    var locationBool: Bool = false
    
    var address = ""
    // creating an instance of NoteTVC - noteTVCInstance
    
    weak var noteTVCInstance : NoteTVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        // adding tap gesture to the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        tapGesture.numberOfTapsRequired = 1
        self.noteImage.isUserInteractionEnabled = true
        self.noteImage.addGestureRecognizer(tapGesture)

        let anothertap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(anothertap)
        
        showImg()
        titleTextField.text = selectedNotes?.noteTitle
        noteTextView.text = selectedNotes?.noteMessage
        
        
        
        // set the test of the button to show location if editNote is true
        if editNote == true{
            locationBool = true
            detailBtn.isEnabled = true
        
        }else{
            locationBool = false
            detailBtn.isEnabled = false
        }
        
        

        // we give the delegate of locationManager to this class
        locManager.delegate = self
        
        // accuracy of the location
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // request the user for the location access
        locManager.requestWhenInUseAuthorization()
        
        // start updating the location of the user
        locManager.startUpdatingLocation()

    }
    
    
    
    @objc func dismissKey(gesture:UITapGestureRecognizer){
        gesture.numberOfTapsRequired = 1
        noteTextView.resignFirstResponder()
    }
    

    //MARK: Location maanager function
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let placemark = placemarks?[0] {
                    
                    
                    
                    if placemark.subThoroughfare != nil {
                        self.address += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        self.address += placemark.thoroughfare! + "\n"
                    }
                    
                    if placemark.subLocality != nil {
                        self.address += placemark.subLocality! + "\n"
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                        self.address += placemark.subAdministrativeArea! + "\n"
                    }
                    
                    if placemark.postalCode != nil {
                        self.address += placemark.postalCode! + "\n"
                    }
                    
                    if placemark.country != nil {
                        self.address += placemark.country! + "\n"
                    }
                    
                    self.addressLbl.text = self.address
                }
            }
        }
        
        
    }
    
    
    
    
    
    @IBAction func showDetail(_ sender: Any) {
        let alert = UIAlertController(title: "Detail ", message: address , preferredStyle: .alert)
        let OkBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(OkBtn)
        present(alert, animated: true , completion: nil)
    }
    
    
    
    
    //MARK: view Will disaapear
    
    override func viewWillDisappear(_ animated: Bool) {
        
         if editNote{
            noteTVCInstance!.deleteNote(note: selectedNotes!)
        }
         
          guard noteTextView.text != "" else {return}
        guard let png = self.noteImage.image?.pngData() else {return}

        noteTVCInstance!.updateNote(title: titleTextField.text! , message: noteTextView.text, img: png, address: address, lat: latitude, long: longitude)
         
      
 
 }
    
    

    
    //MARK: showing image on load
    
    func showImg(){
          
        let arr = selectedNotes?.noteImage
              
        if let img = arr {
              self.noteImage.image = UIImage(data: img)
              }
    }
    

    @objc func selectImage(gesture: UITapGestureRecognizer)
    {
        // function called form the extension
        self.openImagePicker()
        
    }


}

extension NotesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.isEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            self.noteImage.image = img
        }
    }
    
    
    
}
