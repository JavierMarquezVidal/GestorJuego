//
//  EntradasViewControllerDetails.swift
//  GestorJuego
//
//  Created by dam on 9/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit


class EntradasViewControllerDetails: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    /*@IBOutlet weak var juegoNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var puntuacionTextField: UITextField!
    @IBOutlet weak var fechacreacionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    */
    
    @IBOutlet weak var TipoTextField: UITextField!
    @IBOutlet weak var DescripcionTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fechamodificacion: UITextField!
    @IBOutlet weak var fechacreacion: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    var entradas:Entradas?
    var juego:Juego?
    var imagen = "default"
    var id = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeEntradas()
        // Handle the text field’s user input through delegate callbacks.
       TipoTextField.delegate = self
        updateSaveButtonState()
        TipoTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: UIControlEvents.editingChanged)
        DescripcionTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
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
        let flagT = TipoTextField.text ?? ""
        let flagD = DescripcionTextField.text ?? ""
        let flagL = fechamodificacion.text ?? ""

        
        saveButton.isEnabled = !flagT.isEmpty && !flagD.isEmpty && !flagL.isEmpty
    }
    
    
    
    /*//MARK: - Guardar Actividad
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveEntradasDetail" {
            entradas = Entradas(id,
                          TipoTextField.text!,
                          DescripcionTextField.text!,
                          imagen,
                          fechacreacion.text!,
                          fechamodificacion.text!,
                juego
                
            )
        }
    }
    
    
    */
    // MARK: - Imagen
    @IBAction func boton(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        TipoTextField.resignFirstResponder()
        
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
    
    
    func writeEntradas() {
        if(entradas?.id != nil){
            id = (entradas?.id)!
            TipoTextField.text = juego?.titulo
            TipoTextField.textColor = UIColor.red
            TipoTextField.isUserInteractionEnabled = false
            //puntuacionTextField.text = (juego?.puntuacion)
            setImageURL(foto: (entradas?.imagen)!)
            saveButton.isEnabled = true
        }else{
            TipoTextField.isUserInteractionEnabled = true
            TipoTextField.textColor = UIColor.black
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


