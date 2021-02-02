//
//  MoveToTVC.swift
//  note_MohaliAle_ios
//
//  Created by Ranjeet Singh on 02/02/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//
import UIKit
import CoreData

class MoveToTVC: UIViewController {

    var folders = [Category]()
    var selectedNotes: [Note]? {
        didSet {
            loadFolders()
        }
    }
     
    // context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - core data interaction methods
    func loadFolders() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        // predicate
        let folderPredicate = NSPredicate(format: "NOT name MATCHES %@", selectedNotes?[0].parentCategory?.catName ?? "")
        request.predicate = folderPredicate
        
        do {
            folders = try context.fetch(request)
        } catch {
            print("Error fetching data \(error.localizedDescription)")
        }
    }
    
   
    
    
    




//extension MoveToTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = folders[indexPath.row].catName
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .lightGray
        cell.textLabel?.tintColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Move to \(folders[indexPath.row].catName!)", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
            for note in self.selectedNotes! {
                note.parentCategory? = self.folders[indexPath.row]
            }
            // dismiss the vc
            self.performSegue(withIdentifier: "dismissMoveToVC", sender: self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.orange, forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}
//}
