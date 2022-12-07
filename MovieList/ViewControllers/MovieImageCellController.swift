//
//  MovieImageCellController.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

final class MovieImageCellController {

    private let viewModel: MovieImageViewModel

    init(viewModel: MovieImageViewModel) {
        self.viewModel = viewModel
    }

    func preLoad() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
    
    private func binded(_ cell: MovieListCell) -> MovieListCell {
        cell.titleLabel.text = viewModel.title
        cell.releaseDateLabel.text = viewModel.releaseDate
        cell.overviewLabel.text = viewModel.overview

        viewModel.onImageLoad = { [weak cell] image in
            cell?.posterImgView.image = image
        }

        return cell
    }
}
