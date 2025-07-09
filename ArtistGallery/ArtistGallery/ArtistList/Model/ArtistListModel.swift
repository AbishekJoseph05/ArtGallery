//
//  ArtistListModel.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

struct artistsDataModel: Codable {
    var data: [artistsListModel]?
}

struct artistsListModel: Codable {
    var id: Int?
    var title: String?
    var artist_display: String?
}
