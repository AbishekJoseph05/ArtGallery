//
//  ArtistListViewModel.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

import UIKit

class ArtistListViewModel {

    private let service: ServiceCallDelegate

    // Pagination state
    private var currentPage = 1
    private var totalPages = 1
    private var isPaginating = false

    var artists: [artistsListModel] = []
    var cellDataSource: Observable<[ArtistListTableViewModel]> = Observable(value: [])
    var onError: Observable<String?> = Observable(value: nil)

    init(service: ServiceCallDelegate) {
        self.service = service
    }

    func fetchUserList(reset: Bool = false) async {
        if isPaginating { return }

        if reset {
            currentPage = 1
            artists.removeAll()
        }

        isPaginating = true
        defer { isPaginating = false }

        let urlString = "https://api.artic.edu/api/v1/artworks?page=\(currentPage)"

        do {
            let response: artistsDataModel = try await service.fetchData(urlString: urlString)
            let newArtists = response.data ?? []
            print("pagiantion data: \(response.pagination?.current_page ?? 1)")
            self.totalPages = response.pagination?.total_pages ?? 1
            self.artists += newArtists
            self.cellDataSource.value = self.artists.compactMap { ArtistListTableViewModel(artistList: $0) }
            self.currentPage += 1
            print("list: \(artists)")
        } catch {
                if let errorResponse = error as? ErrorResponse {
                    switch errorResponse {
                    case .badURL:
                        self.onError.value = "Invalid request URL."
                    case .invalidResponse:
                        self.onError.value = "Server responded with an error."
                    case .decodingFailed:
                        self.onError.value = "Failed to decode server response."
                    case .NodataFound:
                        self.onError.value = "No data available."
                    }
                } else {
                    self.onError.value = "Something went wrong. Try again later."
                }
        }
    }

    func setupTableView(tableView: UITableView) {
        tableView.register(UINib(nibName: ArtistListTableViewCell.identifier, bundle: .main),
                           forCellReuseIdentifier: ArtistListTableViewCell.identifier)
    }

    func numberOfItems() -> Int {
        return cellDataSource.value.count
    }

    func shouldLoadNextPage(index: Int) -> Bool {
        return index == cellDataSource.value.count - 1 && currentPage <= totalPages
    }
}
