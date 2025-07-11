//
//  ArtistListViewController.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

import UIKit

class ArtistListViewController: UIViewController {

    @IBOutlet weak var artistListTableView: UITableView!

    private var artistList: [ArtistListTableViewModel] = []
    private var viewModel = ArtistListViewModel(service: ApiCaller())
    private let spinner = LoadingSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.setupTableView(tableView: artistListTableView)
        artistListTableView.delegate = self
        artistListTableView.dataSource = self
        bindViewModel()

        Task {
            spinner.show(in: self.view)
            await viewModel.fetchUserList(reset: true)
        }
    }

    private func bindViewModel() {
        
        viewModel.cellDataSource.bind { [weak self] result in
            guard let self = self else { return }
            self.artistList = result
            DispatchQueue.main.async {
                self.artistListTableView.reloadData()
                self.spinner.hide()
            }
        }
        
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
}

extension ArtistListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistListTableViewCell.identifier, for: indexPath) as? ArtistListTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(artistList: artistList[indexPath.row])

        if indexPath.row == artistList.count - 1, viewModel.shouldLoadNextPage(index: indexPath.row) {
            Task {
                spinner.show(in: self.view)
                await viewModel.fetchUserList()
            }
        }

        return cell
    }
}

extension ArtistListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVC = UIStoryboard(name: "ArtistList", bundle: .main).instantiateViewController(identifier: "ArtistDetailsViewController") as? ArtistDetailsViewController else {
            return
        }
        detailsVC.id = artistList[indexPath.row].id
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
