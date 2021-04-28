//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		let context = self.context
		context.performAndWait {
			do {
				if let fetchedFeed = try ManagedCache.find(in: context)?.first,
				   let feed = fetchedFeed.feed(), let timestamp = fetchedFeed.timestamp {
					completion(.found(feed: feed, timestamp: timestamp))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = self.context
		context.performAndWait {
			do {
				try ManagedCache.delete(in: context)
				ManagedCache.create(with: feed, timestamp: timestamp, in: self.context)
				try context.save()
				completion(nil)
			} catch {
				context.rollback()
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let context = self.context
		context.performAndWait {
			do {
				try ManagedCache.delete(in: context)
				try context.save()
				completion(nil)
			} catch {
				context.rollback()
				completion(error)
			}
		}
	}
}
