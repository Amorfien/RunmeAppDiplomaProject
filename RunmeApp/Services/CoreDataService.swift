//
//  CoreDataService.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 14.07.2023.
//

import UIKit
import CoreData

final class CoreDataService {

    static let shared = CoreDataService()

    let appDelegate: AppDelegate
    let mainContext: NSManagedObjectContext
//    let backgroundContext: NSManagedObjectContext

    private init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.mainContext = appDelegate.persistentContainer.viewContext
        self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }


    // MARK: - Core Data Saving support

/// Сохраняет пост в БД (в бэкграунд контексте)
    func savePost(_ news: Article, completion: @escaping (Bool) -> Void) {

        self.mainContext.perform {

            let newsCoreDataModel = NewsCoreDataModel(context: self.mainContext)

            newsCoreDataModel.author = news.author
            newsCoreDataModel.source = news.source
            newsCoreDataModel.title = news.title
            newsCoreDataModel.text = news.text
            newsCoreDataModel.url = news.url
            newsCoreDataModel.urlToImage = news.urlToImage
            newsCoreDataModel.publishedAt = news.publishedAt
            //            newsCoreDataModel.image =

            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                    completion(true)
                } catch {
                    let nserror = error as NSError
                    print("✈️ Error \(nserror.localizedDescription)")
                    completion(false)
                }
            } else {
                completion(false)
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
        print("news count", posts.count)
        posts.forEach {
            self.mainContext.delete($0)
        }

        guard mainContext.hasChanges else {
            return
        }

        do {
            try mainContext.save()
        } catch let error {
            print("AaAaaaaAAaAaAaa ", error)
        }

    }

}
