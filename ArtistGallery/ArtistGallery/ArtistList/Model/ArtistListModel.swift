//
//  ArtistListModel.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

struct artistsDataModel: Codable {
    var data: [artistsListModel]?
    let pagination: Pagination?
}

struct artistsListModel: Codable {
    var id: Int?
    var title: String?
    var artist_display: String?
}

struct Pagination: Codable {
    let total: Int?
    let limit: Int?
    let offset: Int?
    let total_pages: Int?
    let current_page: Int?
    let prev_url: String?
    let next_url: String?
}
