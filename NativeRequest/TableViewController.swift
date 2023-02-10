//
//  TableViewController.swift
//  NativeRequest
//
//  Created by Jorge Armando Avila Estrada on 04/02/23.
//

import UIKit

class TableViewController: UITableViewController {

    var objects = [Result]()
    var selectedPersonaje: Result?
    let ad = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Se consulta el API y serializa el JSON
        let url = "https://rickandmortyapi.com/api/character"
        
        if(ad.internetStatus){
            //Se utiliza la URLSession
            if let laURLApi = URL(string:url) {
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let request = URLRequest(url: laURLApi)
                let task = session.dataTask(with: request){ bytes, response, error in
                    if error == nil {
                        do{
                            let bytes = try Data(contentsOf: laURLApi)
                            let rickAndMorty = try? JSONDecoder().decode(RickAndMorty.self, from: bytes)
                            self.objects = rickAndMorty!.results
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }catch{
                            print ("Error al descargar el JSON")
                        }
                    }
                }
                task.resume()
            }
        }else{
            let mensaje = "No hay conexión a internet"
            //Se avisa al usuario que no hay internet
            let ac = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default){
                alertaAction in
                    //Se ejecuta la accion deseada
                }
            ac.addAction(action)
            present(ac, animated: true)
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        let personaje = objects[indexPath.row]
        cell.textLabel?.text = personaje.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail"){
            let destination = segue.destination as! ViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            selectedPersonaje = objects[indexPath.row]
            destination.recivedPersonaje = selectedPersonaje
        }
    }
}
