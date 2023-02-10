//
//  ViewController.swift
//  NativeRequest
//
//  Created by Jorge Armando Avila Estrada on 04/02/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ImagePersonaje: UIImageView!
    var recivedPersonaje: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlImage = recivedPersonaje?.image else {return}
        // Do any additional setup after loading the view.
        if let laURLImage = URL(string:urlImage) {
            name.text = recivedPersonaje?.name
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config)
            let request = URLRequest(url: laURLImage)
            let task = session.dataTask(with: request){ bytes, response, error in
                if error == nil {
                    guard let data = bytes else {return}
                    DispatchQueue.main.async {
                        self.ImagePersonaje.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    


}

