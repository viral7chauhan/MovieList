//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var watchItemButton: UIButton!
    var viewModel: MovieImageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    @IBAction func onWatchItemClicked(_ sender: UIButton) {
        viewModel?.onWatchListChange()
    }

    private func bind() {
        viewModel?.loadImageData(with: .high)
        overviewLabel.text = viewModel?.overview
        titleLabel.text = viewModel?.title

        updateWatchItem()
        viewModel?.onWatchItemUpdate = { [weak self] _ in
            self?.updateWatchItem()
        }

        viewModel?.onImageLoad = { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }

    private func updateWatchItem() {
        guard let viewModel else { return }
        watchItemButton.setImage(viewModel.isWatchListItem, for: .normal)
    }
}
