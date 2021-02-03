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
    
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    //MARK: crateing the variable if for selected note
    
    var selectedNotes : Note?{
        didSet{
            editNote = true
        }
    }
    
    
    // boolean value to check if the note is editable or the new note
    var editNote: Bool = false
    
    var locationBool: Bool = false
    
    // creating an instance of NoteTVC - noteTVCInstance
    
    weak var noteTVCInstance : NoteTVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        // adding tap gesture to the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        tapGesture.numberOfTapsRequired = 1
        self.noteImage.isUserInteractionEnabled = true
        self.noteImage.addGestureRecognizer(tapGesture)

        
        showImg()
        titleTextField.text = selectedNotes?.noteTitle
        noteTextView.text = selectedNotes?.noteMessage
        
        
        
        // set the test of the button to show location if editNote is true
        if editNote == true{
            showLocationBtn.setTitle("Show Location", for: [])
            locationBool = true
        }else{
            showLocationBtn.setTitle("Save Location", for: [])
            locationBool = false
        }
        
        
        
        
        // location manager things
        
        
        // we give the delegate of locationManager to this class
        locManager.delegate = self
        
        // accuracy of the location
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // request the user for the location access
        locManager.requestWhenInUseAuthorization()
        
        // start updating the location of the user
        locManager.startUpdatingLocation()
        
        
        
    }
    
    
    
    //MARK: view Will disaapear
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
         if editNote{
            noteTVCInstance.deleteNote(note: selectedNotes)
        }
         
          guard noteTextView.text != "" else {return}
        noteTVCInstance.updateNote(title: selectedNotes?.noteTitle, message: selectedNotes?.noteMessage, img: selectedNotes?.noteImage, address: selectedNotes?.noteLocAddress, lat: selectedNotes?.noteLat, long: selectedNotes?.noteLong)
         
         
         // let it be commented for the time being we will check n the debug time
         
         if let png = self.getImage.image?.pngData(){
             saveImage(at: png)
         }
*/
 
 }
    
    
    
   //MARK: Show location button clicked
    
    @IBAction func showLocationPressed(_ sender: Any) {
        if locationBool ==  true {
            performSegue(withIdentifier: "mapSegue", sender: self)
        
        }else{
    

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
                            
                            var address = ""
                            
                            if placemark.subThoroughfare != nil {
                                address += placemark.subThoroughfare! + " "
                            }
                            
                            if placemark.thoroughfare != nil {
                                address += placemark.thoroughfare! + "\n"
                            }
                            
                            if placemark.subLocality != nil {
                                address += placemark.subLocality! + "\n"
                            }
                            
                            if placemark.subAdministrativeArea != nil {
                                address += placemark.subAdministrativeArea! + "\n"
                            }
                            
                            if placemark.postalCode != nil {
                                address += placemark.postalCode! + "\n"
                            }
                            
                            if placemark.country != nil {
                                address += placemark.country! + "\n"
                            }
                            
                            self.addressLbl.text = address
                        }
                    }
                }
                
                
            }
            
  
        }
        
        
    }
    
    
    //MARK: Function to save location of the user and show that in the note pad
    
    func getLocation(){
        
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        //MARK: MAke Changes here in CLLocation 
        
        let destination = segue.destination as? MapVC
       // destination?.latitude = selectedNotes?.noteLat
       // destination?.longitude =  selectedNotes?.noteLong
        
    }
    
    
    
    
    //MARK: showing image on load
    
    func showImg(){
          
        let arr = selectedNotes?.noteImage
              
        if let img = arr {
              self.noteImage.image = UIImage(data: img)
              }
    }
    
    
    // geting image from the core data
    func getSavedImage() -> [Note]{
        var arryOFimage = [Note]()
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        do{
            arryOFimage = try context.fetch(request)
        }
        catch{
            print(error.localizedDescription)
        }
        
        return arryOFimage
        
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
