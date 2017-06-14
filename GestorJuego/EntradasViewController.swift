//
//  EntradasViewController.swift
//  GestorJuego
//
//  Created by dam on 9/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit
class EntradasViewController: UITableViewController, ResponseReceiver{
    
    var arrayEntradas:[Entradas] = [];
    var filteredEntradas = [Entradas]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        getEntradas();
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
            return filteredEntradas.count
        }
        return arrayEntradas.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntradasCell", for: indexPath) as! EntradasCell
        let entradas: Entradas
        if searchController.isActive && searchController.searchBar.text != "" {
            entradas = filteredEntradas[indexPath.row]
        } else {
            entradas = arrayEntradas[indexPath.row]
        }
        cell.entradas = entradas
        return cell
    }
    
    
    @IBAction func cancelToEntradasViewController(_ segue:UIStoryboardSegue) {
    }
    
    //Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteEntradas(id: arrayEntradas[indexPath.row].id)
            arrayEntradas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //save
    @IBAction func saveEntradasDetail(_ segue:UIStoryboardSegue) {
        if let EntradasViewControllerDetails = segue.source as? EntradasViewControllerDetails {
            //add the new player to the players array
            if let entradas = EntradasViewControllerDetails.entradas {
                if entradas.id == 0 {
                    //añadir actividad al array
                    arrayEntradas.append(entradas)
                    //añadir actividad al servidor
                    doEntradas(entradas: entradas, metodo: "POST")
                }else{
                    doEntradas(entradas: entradas, metodo: "PUT")
                }
                
                //update the tableView
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing meal.
                    arrayEntradas[selectedIndexPath.row] = entradas
                    self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.arrayEntradas = []
                        self.getEntradas()
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
                        self.arrayEntradas = []
                        self.getEntradas()
                    }
                }
            }
        }
    }
    
    //edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowDetail" {
            guard let EntradasViewControllerDetails = segue.destination as? EntradasViewControllerDetails else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let entradasCell = sender as? EntradasCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: entradasCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedEntradas = arrayEntradas[indexPath.row]
            EntradasViewControllerDetails.entradas = selectedEntradas
        }
    }
    
    func doEntradas(entradas: Entradas, metodo: String){
        let dict : [String : Any?] = entradas.entradasToDict(entradas: entradas)
        
        guard let cliente = Cliente(destino: "entradas", respuesta: self, metodo, dict) else {
            return
        }
        
        if cliente.request(){
            print("todo bien")
        }
    }
    
    func getEntradas(){
        
        guard let cliente = Cliente(destino: "entradas", respuesta: self, "GET") else {
            return
        }
        
        if cliente.request(){
            print("Recibido Get")
        }
        
    }
    
    
    func deleteEntradas(id: Int){
        
        guard let cliente = Cliente(destino: "entradas?id="+String(id), respuesta: self, "DELETE") else {
            return
        }
        
        if cliente.request(){
            print("Borrado")
        }
        
    }
    
    
    func onDataReceived(data: Data){
        let json = JSON(data: data)
        let array = json.arrayValue
        
        for entradas in array {
            
                let ent = Entradas(
                entradas["id"].intValue,
                entradas["tipo"].stringValue,
                entradas["descripcion"].stringValue,
                entradas["imagen"].stringValue,
                entradas["fechacreacion"].stringValue,
                entradas["fechamodificacion"].stringValue
                
            )
            arrayEntradas.append(ent)
        }
        
        self.tableView.reloadData()
    }
    
    func onErrorReceivingData(message: String){
        print("NO");
    }
    
    //search
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredEntradas = arrayEntradas.filter({( entradas : Entradas) -> Bool in
            if(scope == "All"){
                return true && (entradas.tipo!.lowercased().contains(searchText.lowercased()))
                    || (entradas.descripcion!.lowercased().contains(searchText.lowercased()))
                    || (entradas.fechacreacion!.lowercased().contains(searchText.lowercased()))
                    || (entradas.fechamodificacion!.lowercased().contains(searchText.lowercased()))
            }
            else if(scope == "Fecha"){
                return true && (entradas.fechacreacion!.lowercased().contains(searchText.lowercased()))
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

extension EntradasViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension EntradasViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
