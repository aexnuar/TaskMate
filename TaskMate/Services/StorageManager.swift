//
//  StorageManager.swift
//  TaskMate
//
//  Created by aex on 01.11.2025.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskMate")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
}

// MARK: - CRUD methods
extension StorageManager {
    func createTodo(_ todo: Todo) {
        let todoCD = TodoCD(context: viewContext)
        todoCD.update(from: todo)
        saveContext()
    }
    
    func fetchTodos(completion: (Result<[Todo], Error>) -> Void) {
        let fetchRequest = TodoCD.fetchRequest()
        
        do {
            let todosCD = try self.viewContext.fetch(fetchRequest)
            let todos = todosCD.map { Todo(managedObject: $0) }
            completion(.success(todos))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func updateTodo(_ todo: Todo) {
        let fetchRequest = TodoCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            if let todoCD = results.first {
                todoCD.update(from: todo)
                saveContext()
            } else {
                print("Todo \(todo.id) is not found")
            }
        } catch {
            print("Update todo error \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        let fetchRequest = TodoCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            for todoCD in results {
                self.viewContext.delete(todoCD)
            }
            saveContext()
        } catch {
            print("Delete todo error: \(error.localizedDescription)")
        }
    }
    
    func deleteAllTodos() {
        let fetchRequest = TodoCD.fetchRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            for todoCD in results {
                viewContext.delete(todoCD)
            }
            saveContext()
        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }
}

// MARK: - CoreData saving support
extension StorageManager {
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// Преобразовать из CoreData в модель
extension Todo {
    init(managedObject: TodoCD) {
        self.id = Int(managedObject.id)
        self.todo = managedObject.todo ?? ""
        self.todoDescription = managedObject.todoDescription
        self.completed = managedObject.completed
        self.userID = Int(managedObject.userID)
        self.date = managedObject.date ?? Date()
    }
}

// Преобразовать из модели в CoreData
extension TodoCD {
    func update(from todo: Todo) {
        self.id = Int64(todo.id)
        self.todo = todo.todo
        self.todoDescription = todo.todoDescription
        self.completed = todo.completed
        self.userID = Int64(todo.userID ?? 0)
        self.date = todo.date
    }
}














