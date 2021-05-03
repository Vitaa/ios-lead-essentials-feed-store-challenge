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
public class ManagedCache: NSManagedObject {}

extension ManagedCache {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCache> {
		return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
	}

	@NSManaged public var timestamp: Date
	@NSManaged public var images: NSOrderedSet
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
