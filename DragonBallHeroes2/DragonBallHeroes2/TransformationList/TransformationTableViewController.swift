//
//  TransformationListTableViewController.swift
//  DragonBallHeroes
//
//  Created by Ana on 13/3/25.
//

import UIKit

enum TransformationSection {
    case Transformation
}

final class TransformationListTableViewController: UITableViewController {
     
    // MARK: - Table View DataSource
    
    typealias DataSource = UITableViewDiffableDataSource<TransformationSection, Transformation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TransformationSection, Transformation>
    
    // MARK: - Data
    
    private var dataSource: DataSource?
    private var heroSelected: Hero
    
    // MARK: - Initalizer
    
    init(hero: Hero){
        heroSelected = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // Registramos la celda
        tableView.register(UINib(nibName: TransformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HeroListTableViewCell.identifier)
        
        // Configuramos el datsource
        
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, transformation in
            
            guard let cell =  tableView.dequeueReusableCell(
                withIdentifier: HeroListTableViewCell.identifier,
                for: indexPath
            )as? TransformationTableViewCell else {
                return UITableViewCell()
            }
            
            // Añadir el datasource al table View
            
            tableView.dataSource = self?.dataSource
            
            cell.configure(whith: transformation)
            return cell
        }
        
        // Hacemos la peticion de las transformaciones
        let networkModel = NetworkModel.shared
        
        networkModel.getTransformations(for: heroSelected) {[weak self] result in
            switch result {
            case let .success(transformation):
                // Crear un snapshot con los bojetos que vamos a representar
               
                var snapshot = Snapshot()
                snapshot.appendSections([.Transformation])
                snapshot.appendItems(transformation)
                self?.dataSource?.apply(snapshot)
                
            case let.failure(error):
                print(error)

            }
        }
    }
}

// MARK: - UITableViewDelegate

extension TransformationListTableViewController {
    
    /// Función sobreescrita para dar un tamaño a la celda
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        100
    }
    
    ///Función sobreescrita para dar información sobre la celda seleccionaa
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let transformationSelected = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        // Presentamos nuestro DetailHeroVC
        DispatchQueue.main.async {
            let detailTransformationViewController = DetailTransformationViewController(transformation: transformationSelected)
            self.navigationController?.show(detailTransformationViewController, sender: self)
        }
    }
}
