//
//  Created by Marat Nazirov on 26.11.2024.
//

import UIKit

final class ViewController: UIViewController {
    typealias DataSourse = UICollectionViewDiffableDataSource<Int, UIColor>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, UIColor>
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width / 1.5,
            height: UIScreen.main.bounds.height / 2
        )
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.sectionInset = .init(top: 40, left: 16, bottom: 40, right: 16)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSourse = DataSourse(collectionView: collectionView) { [weak self] collectionView, indexPath, color in
        guard let self else { return .init() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = color
        cell.layer.cornerRadius = 15
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

// MARK: - UICollectionViewDelegate & UIScrollViewDelegate

extension ViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        let newXPoint = (cellWidthIncludingSpacing * roundedIndex) - scrollView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: newXPoint, y: offset.y)
    }
}

// MARK: - Private methods

private extension ViewController {
    func commonInit() {
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
        
        let colors = getColors()
        configure(colors)
    }
    
    func setupSubviews() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func setupNavigationBar() {
        title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configure(_ color: [UIColor]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.zero])
        snapshot.appendItems(color)
        dataSourse.apply(snapshot)
    }
    
    func getColors() -> [UIColor] {
        [
            UIColor.systemBlue,
            UIColor.systemGreen,
            UIColor.systemRed,
            UIColor.systemYellow,
            UIColor.systemCyan,
            UIColor.systemFill,
            UIColor.systemMint,
            UIColor.systemPink
        ]
    }
}
