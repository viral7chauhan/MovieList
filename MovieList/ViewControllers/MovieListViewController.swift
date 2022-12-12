//
//  MovieListViewController.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

class MovieListViewController: UITableViewController {

    var tableModel = [MovieImageCellController]() {
        didSet {
            print("TableModel count \(tableModel.count)")
            DispatchQueue.main.async { [weak viewModel] in
                if let index = viewModel?.updatedIndex {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    viewModel?.updatedIndex = nil
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }

    var viewModel: MovieListViewModel? {
        didSet {
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 230
        viewModel?.loadMovies()
    }

    private func cellController(
        forRowAt indexPath: IndexPath) -> MovieImageCellController {
        return tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

// MARK: - Table view data source

extension MovieListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableModel.count - 1 { // last cell
            viewModel?.loadNextPage()
        }
        return cellController(forRowAt: indexPath).view(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath.row)
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preLoad()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
}
