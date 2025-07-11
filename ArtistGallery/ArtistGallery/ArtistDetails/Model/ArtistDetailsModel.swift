//
//  ArtistDetailsModel.swift
//  ArtistGallery
//
//  Created by KaHa on 11/07/25.
//

struct ArtistDetailsModel: Codable {
    var data: ArtistDetails?
}

struct ArtistDetails: Codable {
    var title: String?
    var artist_title: String?
    var image_id: String?
    var short_description: String?
}
