//
//  CategoryTableViewController.swift
//  Today
//
//  Created by Ugarsoft Orion on 18/03/2019.
//  Copyright © 2019 Ugarsoft Orion. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter new Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Category"
            textField = alertTextField
        }
        let alertAction = UIAlertAction(title: "Add", style: .default) { (button) in
            let category = Category(context: self.context)
            category.name = textField.text
            self.categories.append(category)
            self.save()
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Data source Methods
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch  {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController;
        if let selectedIndex = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[selectedIndex.row]
        }
    }
    
    //MARK: - Data manipulation Methods
    func save() {
        do {
            try context.save()
        } catch {
            print("Problem saving data: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}
