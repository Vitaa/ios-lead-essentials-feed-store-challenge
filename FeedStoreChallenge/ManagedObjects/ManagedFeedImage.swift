//
//  ManagedFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Vita Solomina on 2021-05-01.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
public class ManagedFeedImage: NSManagedObject {}

extension ManagedFeedImage {
	@NSManaged public var desc: String?
	@NSManaged public var id: UUID
	@NSManaged public var location: String?
	@NSManaged public var url: URL
	@NSManaged public var cache: ManagedCache
}

extension ManagedFeedImage {
	static func create(with feedImage: LocalFeedImage, in context: NSManagedObjectContext) -> ManagedFeedImage {
		let image = ManagedFeedImage(context: context)
		image.id = feedImage.id
		image.location = feedImage.location
		image.url = feedImage.url
		image.desc = feedImage.description
		return image
	}

	func toLocalFeedImage() -> LocalFeedImage {
		return LocalFeedImage(id: id, description: desc, location: location, url: url)
	}
}
