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

    var viewModel: MovieImageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        viewModel?.loadImageData(with: .high)
        overviewLabel.text = viewModel?.overview
        titleLabel.text = viewModel?.title

        viewModel?.onImageLoad = { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
}
