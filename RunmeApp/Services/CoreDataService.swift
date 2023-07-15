//
//  CoreDataService.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 14.07.2023.
//

import UIKit
import CoreData

final class CoreDataService {

    let appDelegate: AppDelegate
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext

    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.mainContext = appDelegate.persistentContainer.viewContext
        self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }


    // MARK: - Core Data Saving support

/// Сохраняет пост в БД (в бэкграунд контексте)
    func savePost(_ news: Article, completion: @escaping (Bool) -> Void) {

//        guard let entity = NSEntityDescription.entity(forEntityName: "PostCoreDataModel", in: mainContext) else { return }

        self.backgroundContext.perform {

            let newsCoreDataModel = NewsCoreDataModel(context: self.backgroundContext)

            newsCoreDataModel.author = news.author
            newsCoreDataModel.source = news.source
            newsCoreDataModel.title = news.title
            newsCoreDataModel.text = news.text
            newsCoreDataModel.url = news.url
            newsCoreDataModel.urlToImage = news.urlToImage
            newsCoreDataModel.publishedAt = news.publishedAt
//            newsCoreDataModel.image =

            if self.backgroundContext.hasChanges {
                do {
                    try self.backgroundContext.save()
                    self.mainContext.perform {
                        completion(true)
                    }
                } catch {
                    let nserror = error as NSError
                    print("✈️ Error \(nserror.localizedDescription)")
                    self.mainContext.perform {
                        completion(false)
                    }
                }
            } else {
                self.mainContext.perform {
                    completion(false)
                }
            }

        }
    }

/// Получает посты из БД согласно предикату (predicate = nil - получить всё)
    func fetching(predicate: NSPredicate?) -> [NewsCoreDataModel] {

        let fetchRequest = NewsCoreDataModel.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let storedPosts = try mainContext.fetch(fetchRequest)

            return storedPosts
        } catch {
            return []
        }
    }

/// Удаляет посты из БД согласно предикату (predicate = nil - удалить всё)
    func deletePost(predicate: NSPredicate?) {

        let posts = self.fetching(predicate: predicate)

        posts.forEach {
            self.mainContext.delete($0)
        }

        guard mainContext.hasChanges else {
            return
        }

        do {
            try mainContext.save()
            print("Save main context")
        } catch let error {
            print("AaAaaaaAAaAaAaa ", error)
        }

    }

}
