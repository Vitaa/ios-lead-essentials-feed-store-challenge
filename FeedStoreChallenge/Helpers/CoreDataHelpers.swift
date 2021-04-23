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

extension NSManagedObject {
	static func create(in context: NSManagedObjectContext) -> NSManagedObject {
		return NSEntityDescription.insertNewObject(forEntityName: Self.className(), into: context)
	}
}

extension ManagedFeedImage {
	static func create(with feedImage: LocalFeedImage, in context: NSManagedObjectContext) -> ManagedFeedImage {
		let image = ManagedFeedImage.create(in: context) as! ManagedFeedImage
		image.id = feedImage.id
		image.location = feedImage.location
		image.url = feedImage.url
		image.desc = feedImage.description
		return image
	}

	func toLocalFeedImage() -> LocalFeedImage {
		return LocalFeedImage(id: id!, description: desc, location: location, url: url!)
	}
}

extension ManagedCache {
	@discardableResult
	static func create(with feed: [LocalFeedImage], timestamp: Date, in context: NSManagedObjectContext) -> ManagedCache {
		let cache = ManagedCache.create(in: context) as! ManagedCache
		let images = feed.map { ManagedFeedImage.create(with: $0, in: context) }
		cache.images = NSOrderedSet(array: images)
		cache.timestamp = timestamp
		return cache
	}

	func feed() -> [LocalFeedImage]? {
		(images?.array as? [ManagedFeedImage])?.map { $0.toLocalFeedImage() }
	}
}
