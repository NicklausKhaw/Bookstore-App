//
//  ListViewController.swift
//  Bookstore App
//
//  Created by Nicklaus Khaw on 05/10/2021.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var bookArray = ["book1", "book2"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var books:[Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchBooks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchBooks()
    }
    
    func fetchBooks(){
        do {
            self.books = try context.fetch(Book.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookItemCell", for: indexPath) as! BookTableViewCell
        
        let image = UIImage(data: self.books![indexPath.row].picture!)
        
        cell.nameLabel.text = self.books![indexPath.row].name
        cell.bookImageView.image = image
        
        let author = self.books![indexPath.row].author
        cell.authorLabel.text = "By \(author!)"
        
        let date = self.books![indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        cell.dateLabel.text = dateFormatter.string(from: date!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()

        let alert = UIAlertController(title: books![indexPath.row].name! + " has been deleted", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            print("Deleted")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        let bookToRemove = self.books![indexPath.row]
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        self.context.delete(bookToRemove)
        
        do {
            try self.context.save()
        } catch {
            
        }
        
        self.fetchBooks()
        
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController,
              let index = tableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.row = index
    }
    

}
