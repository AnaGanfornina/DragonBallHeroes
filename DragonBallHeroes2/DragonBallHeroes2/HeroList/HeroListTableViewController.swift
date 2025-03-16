//
//  HeroListTableViewController.swift
//  DragonBallHeroes
//
//  Created by Ana on 11/3/25.
//

import UIKit

enum HeroSection {
    case Heros
}

final class HeroListTableViewController: UITableViewController {
    
    // MARK: - Table View DataSource
    
    typealias DataSource = UITableViewDiffableDataSource<HeroSection, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HeroSection, Hero>
    
    // MARK: - Data
    
    private var dataSource: DataSource?
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registramos celda
        
        tableView.register(
            UINib(nibName: HeroListTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: HeroListTableViewCell.identifier)
        
        // Configuramos el datasource
        
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, hero in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HeroListTableViewCell.identifier,
                for: indexPath
            )as? HeroListTableViewCell else {
                return UITableViewCell()
            }
            
            // Añadir el data source al table view
            
            tableView.dataSource = self?.dataSource
            
            cell.configure(whith: hero)
            return cell
            }
        
        let networkModel = NetworkModel.shared
        
        networkModel.getHeroes {[weak self] result in
            switch result {
            case let .success(heroes):
                // Crear un snapshot con los bojetos que vamos a representar
               
                var snapshot = Snapshot()
                snapshot.appendSections([.Heros])
                snapshot.appendItems(heroes)
                self?.dataSource?.apply(snapshot)
                
            case let.failure(error):
                print(error)
            }
            
        }
    }
}

// MARK: - UITableViewDelegate

extension HeroListTableViewController {
    
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
        guard let heroSelected = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        // Presentamos nuestro DetailHeroVC
        DispatchQueue.main.async {
            let detailHeroViewController = DetailHeroViewController(hero: heroSelected)
            self.navigationController?.show(detailHeroViewController, sender: self)
        }    
    }
}
