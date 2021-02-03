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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

  

}
