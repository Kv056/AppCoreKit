import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(
            name: "Model"
        )

        container.loadPersistentStores {
            _, error in

            if let error = error {
                fatalError(error.localizedDescription)
            }
        }

        return container
    }()

    var context: NSManagedObjectContext {

        persistentContainer.viewContext
    }

    func save() throws {

        if context.hasChanges {
            try context.save()
        }
    }
}