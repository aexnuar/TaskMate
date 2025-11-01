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
    
    //    private let viewContext: NSManagedObjectContext
    
    //    private var backgroundContext: NSManagedObjectContext {
    //        persistentContainer.newBackgroundContext()
    //    }
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    //    private init() {
    //        viewContext = persistentContainer.viewContext
    //    }
}

// MARK: - CRUD methods
extension StorageManager {
    //    func createTodo(_ todo: Todo) {
    //        let context = backgroundContext
    //
    //        context.perform {
    //            let todoCD = TodoCD(context: context)
    //            todoCD.update(from: todo)
    //            self.saveContext(context)
    //        }
    //    }
    
    func createTodo(_ todo: Todo) {
        backgroundContext.perform {
            let todoCD = TodoCD(context: self.backgroundContext)
            todoCD.update(from: todo)
            self.saveContext(self.backgroundContext)
        }
    }
    
    func fetchTodos(completion: (Result<[Todo], Error>) -> Void) {
        let fetchRequest = TodoCD.fetchRequest()
        
        do {
            let todosCD = try self.backgroundContext.fetch(fetchRequest)
            let todos = todosCD.map { Todo(managedObject: $0) }
            completion(.success(todos))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    //    func updateTodo(_ todo: Todo) {
    //        let fetchRequest = TodoCD.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
    //
    //        do {
    //            let results = try self.viewContext.fetch(fetchRequest)
    //            if let todoCD = results.first {
    //                todoCD.update(from: todo)
    //                saveContext()
    //            } else {
    //                print("Todo \(todo.id) is not found")
    //            }
    //        } catch {
    //            print("Update todo error \(error.localizedDescription)")
    //        }
    //    }
    
    func updateTodo(_ todo: Todo) {
        backgroundContext.perform {
            let fetchRequest = TodoCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let todoCD = results.first {
                    todoCD.update(from: todo)
                    self.saveContext(self.backgroundContext)
                } else {
                    print("Todo \(todo.id) is not found")
                }
            } catch {
                print("Update todo error \(error.localizedDescription)")
            }
        }
    }
    
    //    func deleteTodo(_ todo: Todo) {
    //        let fetchRequest = TodoCD.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
    //
    //        do {
    //            let results = try self.viewContext.fetch(fetchRequest)
    //            for todoCD in results {
    //                self.viewContext.delete(todoCD)
    //            }
    //            saveContext()
    //        } catch {
    //            print("Delete todo error: \(error.localizedDescription)")
    //        }
    //    }
    
    func deleteTodo(_ todo: Todo) {
        backgroundContext.perform {
            let fetchRequest = TodoCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                for todoCD in results {
                    self.backgroundContext.delete(todoCD)
                }
                self.saveContext(self.backgroundContext)
            } catch {
                print("Delete todo error: \(error.localizedDescription)")
            }
        }
    }
    
    //    func deleteAllTodos() {
    //        let fetchRequest = TodoCD.fetchRequest()
    //        do {
    //            let results = try viewContext.fetch(fetchRequest)
    //            for todoCD in results {
    //                viewContext.delete(todoCD)
    //            }
    //            saveContext()
    //        } catch {
    //            print("Delete error: \(error.localizedDescription)")
    //        }
    //    }
    
    func deleteAllTodos() {
        backgroundContext.perform {
            let fetchRequest = TodoCD.fetchRequest()
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                for todoCD in results {
                    self.backgroundContext.delete(todoCD)
                }
                self.saveContext(self.backgroundContext)
            } catch {
                print("Delete error: \(error.localizedDescription)")
            }
        }
    }
    
}

// MARK: - CoreData saving support
extension StorageManager {
    func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
            // Не крашим приложение, просто логируем ошибку
        }
    }
    
        func saveContext() {
            let context = persistentContainer.viewContext
            saveContext(context)
        }
    
    //    func saveContext() {
    //        if viewContext.hasChanges {
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //    }
}

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














