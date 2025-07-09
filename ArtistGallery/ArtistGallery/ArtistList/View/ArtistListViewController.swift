//
//  ArtistListViewController.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

import UIKit

class ArtistListViewController: UIViewController {

    @IBOutlet weak var artistListTableView: UITableView!
    
    var artistList: [ArtistListTableViewModel] = []
    var viewModel = ArtistListViewModel(service: ApiCaller())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.setupTableView(tableView: artistListTableView)
        artistListTableView.delegate = self
        artistListTableView.dataSource = self
        
        Task {
            await viewModel.fetchUserList()
        }
        bindViewModel()
        // Do any additional setup after loading the view.
    }
}

extension ArtistListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistListTableViewCell.identifier, for: indexPath) as? ArtistListTableViewCell else {return UITableViewCell()}
                cell.setupCell(artistList: self.artistList[indexPath.row])
                return cell
    }
}

extension ArtistListViewController: UITableViewDelegate {
    
}

extension ArtistListViewController {
    func bindViewModel(){
        viewModel.cellDataSource.bind { [weak self] result in
            guard let self = self else { return }
            self.artistList = result
            DispatchQueue.main.async {
                self.artistListTableView.reloadData()
            }
        }
    }
}

