//
//  ArtistDetailViewModel.swift
//  ArtistGallery
//
//  Created by KaHa on 10/07/25.
//

class ArtistDetailViewModel {
    
    var artists: ArtistDetails?
    var onDataFetched: (() -> Void)?
    
    private let service: ServiceCallDelegate
    var onError: Observable<String?> = Observable(value: nil)
    
    init(service: ServiceCallDelegate) {
        self.service = service
    }
    
    func fetchUserList(id: Int) async{
        do {
            let response: ArtistDetailsModel = try await service.fetchData(urlString: "https://api.artic.edu/api/v1/artworks/\(id)")
            guard let details = response.data else { return }
            print("details: \(details)")
            self.artists = details
            self.onDataFetched?()
        }catch {
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
}
