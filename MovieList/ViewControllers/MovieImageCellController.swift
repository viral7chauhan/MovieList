//
//  MovieImageCellController.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

final class MovieImageCellController {

    let viewModel: MovieImageViewModel
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
//        viewModel.loadImageData()
    }

    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }

    private func binded(_ cell: MovieListCell) -> MovieListCell {
        cell.titleLabel.text = viewModel.title
        cell.releaseDateLabel.text = viewModel.releaseDate
        cell.overviewLabel.text = viewModel.overview
        cell.posterImgView.image = nil

        viewModel.onImageLoad = { [weak cell] image in
            DispatchQueue.main.async {
                cell?.posterImgView.image = image
            }
        }

        cell.addToWatchListButton.setImage(viewModel.isWatchListItem, for: .normal)

        return cell
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
