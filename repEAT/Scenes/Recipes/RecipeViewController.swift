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
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setupTableView() {
        guard let image = recipe?.image else {
            return
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        imageView.image = image
        tableView.tableHeaderView = imageView
    }

    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipeController?.numberOfSections ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeController?.headerTitle(of: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeController?.numberOfRows(in: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch RecipeController.Section(rawValue: indexPath.section) {
        case .details:
            return detailsCell(forRowAt: indexPath)
        case .ingredients:
            return ingredientCell(forRowAt: indexPath)
        case.directions:
            return directionCell(forRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func detailsCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
        cell.textLabel?.text = recipe?.name
        return cell
    }
    
    private func ingredientCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = recipeController?.ingredient(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredient?.formattedQuantityWithUnit
        cell.detailTextLabel?.text = ingredient?.food?.name
        
        return cell
    }
    
    private func directionCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let direction = recipeController?.direction(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionCell", for: indexPath)
        cell.textLabel?.text = direction?.depiction
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
