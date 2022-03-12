//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Manu on 12/03/2022.
//

import Foundation
import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitlecollectionViewCell"
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterView.frame = contentView.bounds
    }
    
    func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterView.sd_setImage(with: url)
    }
}
