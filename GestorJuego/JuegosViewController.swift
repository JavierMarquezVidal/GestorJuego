//
//  JuegosViewController.swift
//  GestorJuego
//
//  Created by dam on 18/5/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit

class JuegosViewController: UITableViewController, ResponseReceiver{
    
    var arrayJuegos:[Juego] = [];
    var filteredJuegos = [Juego]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        getJuegos();
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["All", "Juegos", "Entradas", "Fecha"]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredJuegos.count
        }
        return arrayJuegos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JuegoCell", for: indexPath) as! JuegoCell
        let juego: Juego
        if searchController.isActive && searchController.searchBar.text != "" {
            juego = filteredJuegos[indexPath.row]
        } else {
            juego = arrayJuegos[indexPath.row]
        }
        cell.juego = juego
        return cell
    }
    
    
    @IBAction func cancelToJuegosViewController(_ segue:UIStoryboardSegue) {
    }
    
    //Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteJuegos(id: arrayJuegos[indexPath.row].id)
            arrayJuegos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //save
    @IBAction func saveJuegoDetail(_ segue:UIStoryboardSegue) {
        if let JuegoViewControllerDetails = segue.source as? JuegoViewControllerDetails {
            //añadir el juego nuevo al array juegos 
            if let juego = JuegoViewControllerDetails.juego {
                if juego.id == 0 {
                    //añadir juego al array
                    arrayJuegos.append(juego)
                    //añadir juego al servidor
                    doJuegos(juego: juego, metodo: "POST")
                }else{
                    doJuegos(juego: juego, metodo: "PUT")
                }
                
                //update the tableView
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing meal.
                    arrayJuegos[selectedIndexPath.row] = juego
                    self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.arrayJuegos = []
                        self.getJuegos()
                    }
                }
                else {
                    // Add a new meal.
                    /*let indexPath = IndexPath(row: self.arrayActividades.count-1, section: 0)
                     self.tableView.insertRows(at: [indexPath], with: .automatic)
                     DispatchQueue.main.async{
                     self.tableView.reloadData()
                     }*/
                    
                    let when = DispatchTime.now() + 0.7 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.arrayJuegos = []
                        self.getJuegos()
                    }
                }
            }
        }
    }
    
    //edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowDetail" {
            guard let JuegoViewControllerDetails = segue.destination as? JuegoViewControllerDetails else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let juegoCell = sender as? JuegoCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: juegoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedJuego = arrayJuegos[indexPath.row]
            JuegoViewControllerDetails.juego = selectedJuego
        }
    }
    
    func doJuegos(juego: Juego, metodo: String){
        let dict : [String : Any?] = juego.juegoToDict(juego: juego)
        
        guard let cliente = Cliente(destino: "juego", respuesta: self, metodo, dict) else {
            return
        }
        
        if cliente.request(){
            print("todo bien")
        }
    }
    
    func getJuegos(){
        
        guard let cliente = Cliente(destino: "juego", respuesta: self, "GET") else {
            return
        }
        
        if cliente.request(){
            print("Recibido Get")
        }
        
    }
    

    
    func deleteJuegos(id: Int){
        
        guard let cliente = Cliente(destino: "juego?id="+String(id), respuesta: self, "DELETE") else {
            return
        }
        
        if cliente.request(){
            print("Borrado")
        }
        
    }
    
    
    func onDataReceived(data: Data){
        let json = JSON(data: data)
        let array = json.arrayValue
        
        for juego in array {
            
            let entradas = Entradas(juego["entradas"]["id"].intValue,
                                    juego["entradas"]["tipo"].stringValue,
                                    juego["entradas"]["descripcion"].stringValue,
                                    juego["entradas"]["imagen"].stringValue,
                                    juego["entradas"]["fechacreacion"].stringValue,
                                    juego["entradas"]["fechamodificacion"].stringValue
                                    
            );
            
            let jue = Juego(
                juego["id"].intValue,
                juego["titulo"].stringValue,
                juego["imagen"].stringValue,
                juego["fecha_creacion"].stringValue,
                //juego["puntuacion"].intValue,
                entradas
            )
            arrayJuegos.append(jue)
        }
        
        self.tableView.reloadData()
    }
    
    func onErrorReceivingData(message: String){
        print("NO");
    }
    
    //search
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredJuegos = arrayJuegos.filter({( juego : Juego) -> Bool in
            if(scope == "All"){
                return true && (juego.entradas!.tipo!.lowercased().contains(searchText.lowercased()))
                    || (juego.titulo!.lowercased().contains(searchText.lowercased()))
                    || (juego.fecha_creacion!.lowercased().contains(searchText.lowercased()))
                    //|| (juego.lanzador!.lowercased().contains(searchText.lowercased()))
                    //|| (juego.puntuacion!.nombre.lowercased().contains(search.lowercased()))
            }
            else if(scope == "Entradas"){
                return true && (juego.entradas!.tipo!.lowercased().contains(searchText.lowercased()))
            }
            else if(scope == "Fecha"){
                return true && (juego.fecha_creacion!.lowercased().contains(searchText.lowercased()))
            }else{
                return false
            }
        })
        tableView.reloadData()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
     clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
     super.viewWillAppear(animated)
     }*/
}

extension JuegosViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension JuegosViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
