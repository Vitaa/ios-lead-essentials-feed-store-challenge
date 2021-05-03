//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Vita Solomina on 2021-05-01.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
final class ManagedCache: NSManagedObject {}

extension ManagedCache {
	@nonobjc class func fetchRequest() -> NSFetchRequest<ManagedCache> {
		return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
	}

	@NSManaged var timestamp: Date
	@NSManaged var images: NSOrderedSet
}

extension ManagedCache {
	static func create(with feed: [LocalFeedImage], timestamp: Date, in context: NSManagedObjectContext) {
		let cache = ManagedCache(context: context)
		let images = feed.map { ManagedFeedImage.create(with: $0, in: context) }
		cache.images = NSOrderedSet(array: images)
		cache.timestamp = timestamp
	}

	static func find(in context: NSManagedObjectContext) throws -> [ManagedCache] {
		let cacheFetch: NSFetchRequest = ManagedCache.fetchRequest()
		return try context.fetch(cacheFetch)
	}

	static func delete(in context: NSManagedObjectContext) throws {
		try ManagedCache.find(in: context).forEach { context.delete($0) }
	}

	func feed() -> [LocalFeedImage] {
		images.compactMap { ($0 as? ManagedFeedImage)?.toLocalFeedImage() }
	}
}
