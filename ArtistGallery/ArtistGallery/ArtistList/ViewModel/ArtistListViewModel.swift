//
//  ArtistListViewModel.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

import UIKit

class ArtistListViewModel {
    
    var artists: [artistsListModel] = []
    
    private let service: ServiceCallDelegate
    init(service: ServiceCallDelegate) {
        self.service = service
    }
    var cellDataSource: Observable<[ArtistListTableViewModel]> =  Observable(value: [])
    func fetchUserList() async{
        do {
            let response: artistsDataModel = try await service.fetchData()
            self.artists = response.data ?? []
            self.cellDataSource.value = self.artists.compactMap({ArtistListTableViewModel(artistList: $0)})
        }catch {
            print("found error while assinging the data to the user list")
        }
    }
    
    func setupTableView(tableView: UITableView){
        tableView.register(UINib(nibName: ArtistListTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: ArtistListTableViewCell.identifier)
    }
    
    
    
    func numberOfItems() -> Int {
        return artists.count
    }
}

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

class Observable<T> {
    
    private var valueChanged: ((T)-> Void)?
    
    var value: T {
        didSet {
            valueChanged?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ lister: @escaping (T) -> Void){
        lister(value)
        valueChanged = lister
    }
}
