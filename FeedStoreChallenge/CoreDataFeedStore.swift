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
		context.perform { [self] in
			let cacheFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedCache")
			do {
				if let fetchedFeed = (try context.fetch(cacheFetch)).first as? ManagedCache {
					completion(.found(feed: fetchedFeed.feed()!, timestamp: fetchedFeed.timestamp!))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		deleteCachedFeed { [weak self] error in
			guard let self = self else { return }
			if let error = error {
				completion(error)
			} else {
				self.context.perform { [self] in
					ManagedCache.create(with: feed, timestamp: timestamp, in: self.context)
					try? self.context.save()
					completion(nil)
				}
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let cacheFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedCache")
		context.perform { [weak self] in
			guard let self = self else { return }
			do {
				let fetchedFeed = try self.context.fetch(cacheFetch) as? [ManagedCache]
				fetchedFeed?.forEach { self.context.delete($0) }
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
}
