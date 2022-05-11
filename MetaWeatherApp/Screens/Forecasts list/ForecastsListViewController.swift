//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import UIKit

final class ForecastsListViewController: UICollectionViewController {
    typealias Dependencies = WeatherListCell.Dependencies
    private let dependencies: Dependencies
    private let viewModel: ForecastsListViewModelType
    
    private var forecastsViewModels: [ForecastViewModel] = [] {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            snapshot.appendSections([.main])
            snapshot.appendItems(forecastsViewModels.map { $0.locationId }, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    init(
        viewModel: ForecastsListViewModelType,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        super.init(
            collectionViewLayout: UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .plain))
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meta Weather"
        navigationItem.backButtonTitle = ""
        configureCollectionView()
        loadData()
    }
    
    private func configureCollectionView() {
        let cellRegistration = UICollectionView.CellRegistration<WeatherListCell, String> { (cell, indexPath, locationId) in
            guard let forecast = self.forecastsViewModels.first(where: { $0.locationId == locationId }) else { fatalError() }
            cell.dependencies = self.dependencies
            cell.forecast = forecast
        }
                
        dataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func loadData() {
        Task {
            let forecasts = try? await self.viewModel.loadForecasts()
            self.updateUi(forecasts ?? [])
        }
    }
    
    @MainActor
    @objc private func onPullToRefresh() {
        loadData()
    }
    
    @MainActor
    private func updateUi(_ forecasts: [ForecastViewModel]) {
        self.forecastsViewModels = forecasts.sorted(by: { lhs, rhs in lhs.locationId > rhs.locationId })
        collectionView.refreshControl?.endRefreshing()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        navigationController?.pushViewController(ForecastDetailsViewController(viewModel: forecastsViewModels[indexPath.item]), animated: true)
    }
}
