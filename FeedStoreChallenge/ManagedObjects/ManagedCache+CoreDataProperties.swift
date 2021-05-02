//
//  ManagedCache+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Vita Solomina on 2021-05-01.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

extension ManagedCache {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCache> {
		return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
	}

	@NSManaged public var timestamp: Date
	@NSManaged public var images: NSOrderedSet
}

// MARK: Generated accessors for images
extension ManagedCache {
	@objc(insertObject:inImagesAtIndex:)
	@NSManaged public func insertIntoImages(_ value: ManagedFeedImage, at idx: Int)

	@objc(removeObjectFromImagesAtIndex:)
	@NSManaged public func removeFromImages(at idx: Int)

	@objc(insertImages:atIndexes:)
	@NSManaged public func insertIntoImages(_ values: [ManagedFeedImage], at indexes: NSIndexSet)

	@objc(removeImagesAtIndexes:)
	@NSManaged public func removeFromImages(at indexes: NSIndexSet)

	@objc(replaceObjectInImagesAtIndex:withObject:)
	@NSManaged public func replaceImages(at idx: Int, with value: ManagedFeedImage)

	@objc(replaceImagesAtIndexes:withImages:)
	@NSManaged public func replaceImages(at indexes: NSIndexSet, with values: [ManagedFeedImage])

	@objc(addImagesObject:)
	@NSManaged public func addToImages(_ value: ManagedFeedImage)

	@objc(removeImagesObject:)
	@NSManaged public func removeFromImages(_ value: ManagedFeedImage)

	@objc(addImages:)
	@NSManaged public func addToImages(_ values: NSOrderedSet)

	@objc(removeImages:)
	@NSManaged public func removeFromImages(_ values: NSOrderedSet)
}

extension ManagedCache: Identifiable {}
