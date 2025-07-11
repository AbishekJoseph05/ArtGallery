//
//  ArtistList.swift
//  ArtistGallery
//
//  Created by KaHa on 11/07/25.
//

class ArtistListTableViewModel {
    
    var artistDisplayInfo: String?
    var title: String?
    var id: Int?
    
    init(artistList: artistsListModel) {
        self.artistDisplayInfo = artistList.artist_display
        self.title = artistList.title
        self.id = artistList.id
    }
}
