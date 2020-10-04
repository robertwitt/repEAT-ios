//
//  RecipeViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit
import CoreData

class RecipeViewController: UITableViewController {
    
    var recipe: Recipe? {
        get {
            return recipeController?.recipe
        }
        set {
            if let recipe = newValue {
                recipeController = RecipeController(with: recipe)
            }
        }
    }
    
    private var recipeController: RecipeController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        title = recipe?.name
    }
    
    private func setupTableView() {
        guard let image = recipe?.image else {
            return
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        imageView.image = image
        tableView.tableHeaderView = imageView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipeController?.numberOfSections ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeController?.headerTitle(of: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    @IBAction func editItemPressed(_ sender: Any) {
    }
    
}
