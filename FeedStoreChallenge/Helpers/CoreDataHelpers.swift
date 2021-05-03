//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
	static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
		let description = NSPersistentStoreDescription(url: url)
		let container = NSPersistentContainer(name: name, managedObjectModel: model)
		container.persistentStoreDescriptions = [description]

		var loadError: Swift.Error?
		container.loadPersistentStores { loadError = $1 }
		try loadError.map { throw $0 }

		return container
	}
}

extension NSManagedObjectModel {
	convenience init?(name: String, in bundle: Bundle) {
		guard let momd = bundle.url(forResource: name, withExtension: "momd") else {
			return nil
		}
		self.init(contentsOf: momd)
	}
}

extension ManagedCache {
	@discardableResult
	static func create(with feed: [LocalFeedImage], timestamp: Date, in context: NSManagedObjectContext) -> ManagedCache {
		let cache = ManagedCache(context: context)
		let images = feed.map { ManagedFeedImage.create(with: $0, in: context) }
		cache.images = NSOrderedSet(array: images)
		cache.timestamp = timestamp
		return cache
	}

	static func find(in context: NSManagedObjectContext) throws -> [ManagedCache]? {
		let cacheFetch: NSFetchRequest = ManagedCache.fetchRequest()
		return try context.fetch(cacheFetch)
	}

	static func delete(in context: NSManagedObjectContext) throws {
		try ManagedCache.find(in: context)?.forEach { context.delete($0) }
	}

	func feed() -> [LocalFeedImage] {
		images.compactMap { ($0 as? ManagedFeedImage)?.toLocalFeedImage() }
	}
}
