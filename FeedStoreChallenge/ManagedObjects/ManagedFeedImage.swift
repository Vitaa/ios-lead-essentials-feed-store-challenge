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
final class ManagedFeedImage: NSManagedObject {}

extension ManagedFeedImage {
	@NSManaged var desc: String?
	@NSManaged var id: UUID
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: ManagedCache
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
