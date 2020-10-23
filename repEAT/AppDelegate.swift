//
//  AppDelegate.swift
//  repEAT
//
//  Created by Witt, Robert on 03.10.20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast
    static let singleton = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "repEAT")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            // TODO: Remove this after full database was setup
            self.seedSampleData(context: container.viewContext)
        })
        return container
    }()
    
    // swiftlint:disable function_body_length
    private func seedSampleData(context: NSManagedObjectContext) {
        // swiftlint:disable line_length
        let userDefaultsKey = "SampleDBInitializedKey"
        guard !UserDefaults.standard.bool(forKey: userDefaultsKey) else {
            return
        }
        
        var uoms = [UnitOfMeasure]()
        do {
            let plist = try UnitOfMeasurePlist()
            uoms = plist.units.map { (unit) -> UnitOfMeasure in
                let uom = UnitOfMeasure(context: context)
                uom.code = unit.code
                uom.name = unit.name
                return uom
            }
        } catch {
        }
        
        let recipe = Recipe(context: context)
        recipe.name = "Spaghetti Carbonara"
        recipe.image = UIImage(named: "spaghetti-carbonara")
        
        for uom in uoms {
            switch uom.code {
            case "oz":
                addIngredient(Food("Spaghetti", baseUnit: uom, into: context), quantity: 8.0, to: recipe)
            case "pc":
                addIngredient(Food("Eggs", baseUnit: uom, into: context), quantity: 2.0, to: recipe)
            case "cups":
                addIngredient(Food("Parmesan", baseUnit: uom, into: context), quantity: 0.5, to: recipe)
            case "slices":
                addIngredient(Food("Bacon", baseUnit: uom, into: context), quantity: 4.0, to: recipe)
            default:
                break
            }
        }
        addIngredient(Food("Salt", baseUnit: nil, into: context), to: recipe)
        
        _ = recipe.createDirection("In a large pot of boiling salted water, cook pasta according to package instructions; reserve 1/2 cup water and drain well.")
        _ = recipe.createDirection("In a small bowl, whisk together eggs and Parmesan; set aside.")
        _ = recipe.createDirection("Heat a large skillet over medium high heat. Add bacon and cook until brown and crispy, about 6-8 minutes; reserve excess fat.")
        _ = recipe.createDirection("Stir in garlic until fragrant, about 1 minute. Reduce heat to low.")
        _ = recipe.createDirection("Working quickly, stir in pasta and egg mixture, and gently toss to combine; season with salt and pepper, to taste. Add reserved pasta water, one tablespoon at a time, until desired consistency is reached.")
        _ = recipe.createDirection("Serve immediately, garnished with parsley, if desired.")
        
        let emptyRecipe = Recipe(context: context)
        emptyRecipe.name = "Vitamin Shake"
        emptyRecipe.image = UIImage(named: "vitamin-shake")
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        } catch {
        }
        // swiftlint:enable line_length
    }
    // swiftlint:enable function_body_length
    
    private func addIngredient(_ food: Food, quantity: Ingredient.Quantity = 0.0, to recipe: Recipe) {
        let ingredient = Ingredient(context: recipe.managedObjectContext!)
        ingredient.food = food
        ingredient.quantity = quantity
        recipe.addToIngredients(ingredient)
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
