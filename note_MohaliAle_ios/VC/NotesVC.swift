//
//  NotesVC.swift
//  note_MohaliAle_ios
//
//  Created by Ranjeet Singh on 02/02/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit
import CoreData

class NotesVC: UIViewController {
    
    //MARK: - outlets of ther view controller
    @IBOutlet weak var showLocationBtn: UIButton!
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!

    
    let imagePicker = UIImagePickerController()
    

    // MARK: Context and Array created
    
    var notes = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        
        
        
        
    }
    
    //MARK: view Will disaapear
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
         if editNote{
            noteTVCInstance.deleteNote(note: selectedNotes)
        }
        noteTVCInstance.updateNote(title: selectedNotes?.noteTitle, message: selectedNotes?.noteMessage, img: selectedNotes?.noteImage)
         
         
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
            
        }
        
        
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        
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
