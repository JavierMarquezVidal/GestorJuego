//
//  JuegoTableViewCell.swift
//  GestorJuego
//
//  Created by dam on 6/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit

class JuegoTableViewCell: UITableViewCell {
    

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var puntuacionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    
    
    var juego: Juego! {
        didSet {
            tituloLabel.text = juego.titulo
            puntuacionLabel.numberOfLines = juego.puntuacion
            setImageURL(foto: juego.imagen!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setImageURL(foto: String){
        //let ruta = "https://gestor-juegos-jmarquez-1.c9users.io/sources/images/"+foto
        let ruta = "https://gestor-juegos-jmarquez-1.c9users.io/sources/images/"+foto
        if let url = NSURL(string: ruta) {
            if let data = NSData(contentsOf: url as URL) {
                imagenView.image = UIImage(data: data as Data)
            }
        }
    }
    
    
    /*
     //Create a method with a completion handler to get the image data from your url
     func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
     URLSession.shared.dataTask(with: url) {
     (data, response, error) in
     completion(data, response, error)
     }.resume()
     }
     //Create a method to download the image (start the task)
     func downloadImage(url: URL) {
     print("Download Started")
     getDataFromUrl(url: url) { (data, response, error)  in
     guard let data = data, error == nil else { return }
     print(response?.suggestedFilename ?? url.lastPathComponent)
     print("Download Finished")
     DispatchQueue.main.async() { () -> Void in
     self.imagenView.image = UIImage(data: data)
     }
     }
     }*/

}
