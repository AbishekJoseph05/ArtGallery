//
//  ArtistDetailsViewController.swift
//  ArtistGallery
//
//  Created by KaHa on 10/07/25.
//

import UIKit

class ArtistDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var id: Int?
    var viewModel = ArtistDetailViewModel(service: ApiCaller())
    private let spinner = LoadingSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        Task {
            spinner.show(in: self.view)
            await viewModel.fetchUserList(id: id ?? 0)
        }
        viewModel.onDataFetched = { [weak self] in
            self?.updateUI()
        }
    }
    
    func bindViewModel(){
        viewModel.onError.bind { [weak self] errorMessage in
            guard let self = self, let message = errorMessage else { return }
            DispatchQueue.main.async {
                self.spinner.hide()
                self.showErrorAlert(message: message)
            }
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateUI() {
        guard let artist = viewModel.artists else {
            DispatchQueue.main.async { self.spinner.hide() }
            return
        }
        
        DispatchQueue.main.async {
            self.titleLabel.text = artist.title ?? "No Title"
            self.artistNameLabel.text = "Artist Name: \(artist.artist_title ?? "Unknown Artist")"
            self.descriptionLabel.text = "Description: \(artist.short_description ?? "No Description")"
        }
        
        let defaultImage = UIImage(named: "placeholder")
        
        guard let imageID = artist.image_id,
              let url = URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/843,/0/default.jpg") else {
            DispatchQueue.main.async {
                self.imageView.image = defaultImage
                self.spinner.hide()
            }
            return
        }
        
        DispatchQueue.global().async {
            var loadedImage: UIImage? = nil
            if let data = try? Data(contentsOf: url) {
                loadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                self.imageView.image = loadedImage ?? defaultImage
                self.spinner.hide()
            }
        }
    }
}
