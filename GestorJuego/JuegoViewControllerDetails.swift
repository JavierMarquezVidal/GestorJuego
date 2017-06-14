//
//  ViewControllerCrear.swift
//  GestorJuego
//
//  Created by dam on 8/5/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit


class JuegoViewControllerDetails: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var juegoNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var puntuacionTextField: UITextField!
    @IBOutlet weak var fechacreacionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var juego:Juego?
    var entradasO:Entradas?
    var imagen = "default"
    var id = 0
    var puntuacion = 0
    
    var entradas:String = "Entradas" {
        didSet {
            //verEntradasLabel.text? = entradas
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeJuego()
        // Handle the text field’s user input through delegate callbacks.
        tituloTextField.delegate = self
        updateSaveButtonState()
        tituloTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: UIControlEvents.editingChanged)
        puntuacionTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                       for: UIControlEvents.editingChanged)
        fechacreacionTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                 for: UIControlEvents.editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit PlayerDetailsViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Controlar boton save
    func textFieldDidBeginEditing(_ textField: UITextField) {
     // Disable the Save button while editing.
     saveButton.isEnabled = false
     }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let flagT = tituloTextField.text ?? ""
        let flagD = fechacreacionTextField.text ?? ""
        let flagL = puntuacionTextField.text ?? ""
        let flagP = entradas != "Entradas"

        saveButton.isEnabled = !flagT.isEmpty && !flagD.isEmpty /*&& !flagL.isEmpty*/ && flagP
    }
    
    //MARK: - Guardar Actividad
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveJuegoDetail" {
            juego = Juego(id,
                        tituloTextField.text!,
                        imagen,
                        fechacreacionTextField.text!,
                        //puntuacionTextField.text!,
                        entradasO
            );
        }
    }
    
    
    
        
    // MARK: - Imagen
    @IBAction func boton(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        tituloTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }


    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        imageTo64()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imageTo64() {
        //Codificamos la imagen en base64
        //let imageData:Data = UIImagePNGRepresentation(photoImageView.image!)!
        let imageData:Data = UIImageJPEGRepresentation(photoImageView.image!, 0.4)!
        imagen = imageData.base64EncodedString()
    }
    
    
    func writeJuego() {
        if(juego?.id != nil){
            id = (juego?.id)!
            entradasO = juego?.entradas
            tituloTextField.text = juego?.titulo
            tituloTextField.textColor = UIColor.red
            tituloTextField.isUserInteractionEnabled = false
            //puntuacionTextField.text = (juego?.puntuacion)
            setImageURL(foto: (juego?.imagen)!)
            saveButton.isEnabled = true
        }else{
            tituloTextField.isUserInteractionEnabled = true
            tituloTextField.textColor = UIColor.black
        }
    }
    
    func setImageURL(foto: String){
        //let ruta = "http://192.168.208.9:80/swift-rest/sources/images/"+foto
        let ruta = "https://gestor-juegos-jmarquez-1.c9users.io/sources/images/"+foto
        if let url = NSURL(string: ruta) {
            if let data = NSData(contentsOf: url as URL) {
                photoImageView.image = UIImage(data: data as Data)
            }
        }
    }
    
}

