//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Manu on 26/03/2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitle(model: Result) async throws {
        guard let delegate = await UIApplication.shared.delegate as? AppDelegate else { return }
        let context = await delegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.id = Int64(model.id)
        item.overview = model.overview
        item.originalName = model.originalName
        item.originalTitle = model.originalTitle
        item.posterPath = model.posterPath
        item.mediaType = model.mediaType?.rawValue
        item.releaseDate = model.releaseDate
        item.voteAverage = model.voteAverage
        item.voteCount = Int64(model.voteCount)
        
        try context.save()
    }
    
    func fetchTitlesFromDatabase() async throws -> [TitleItem]? {
        guard let delegate = await UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = await delegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        return try context.fetch(request)
    }
    
    func deleteTitle(with model: TitleItem) async throws {
        guard let delegate = await UIApplication.shared.delegate as? AppDelegate else { return }
        let context = await delegate.persistentContainer.viewContext
        context.delete(model)
        
        try context.save()
    }
}
