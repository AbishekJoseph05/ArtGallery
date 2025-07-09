//
//  ArtistListTableViewCell.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

import UIKit

class ArtistListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistIdLabel: UILabel!
    @IBOutlet weak var artistTitleLabel: UILabel!
    @IBOutlet weak var ArtistDisplayInfoLabel: UILabel!
    
    static let identifier: String = "ArtistListTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(artistList: ArtistListTableViewModel){
        self.ArtistDisplayInfoLabel.text = artistList.artistDisplayInfo
        self.artistIdLabel.text = "id: \(artistList.id ?? 0000)"
        self.artistTitleLabel.text = artistList.title
    }
}
