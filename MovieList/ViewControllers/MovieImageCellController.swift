//
//  MovieImageCellController.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

final class MovieImageCellController {

    private let viewModel: MovieImageViewModel
    var cell: MovieListCell?

    init(viewModel: MovieImageViewModel) {
        self.viewModel = viewModel
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        viewModel.loadImageData()
        return binded(cell!)
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
            DispatchQueue.main.async {
                cell?.posterImgView.image = image
            }
        }
        return cell
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
