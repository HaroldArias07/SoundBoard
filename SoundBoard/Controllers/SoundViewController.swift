//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by mbtec22 on 22/04/21.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var recordLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder?
    var audioURL : URL?
    var audioPlayer : AVAudioPlayer?
    let myImage = UIImage(named: "stop")
    let myImage2 = UIImage(named: "record")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //Detener la grabación
            audioRecorder?.stop()
            //Cambiar el texto del boton grabar
            recordButton.setTitle("Record", for: .normal)
            //Activar el boton de play
            playButton.isEnabled = true
            //Activar el boton de add
            addButton.isEnabled = true
            //Cambiar icono
            recordButton.setImage(myImage2, for: .normal)
            //Cambiar palabra Stop a Record
            recordLabel.text = "Record"
        } else {
            //Empezar a grabar
            audioRecorder?.record()
            //Cambiar el titulo del boton a detener
            recordButton.setTitle("Stop", for: .normal)
            //Cambiar icono
            recordButton.setImage(myImage, for: .normal)
            //Cambiar palabra Record a Stop
            recordLabel.text = "Stop"
        }
    }
    
    @IBAction func platTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func setupRecorder(){
        do {
            //creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando una dirección para el archivo de audio
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //Dirección donde se guardan los audios
            print("RUTA DE ALMACENAMIENTO DEL AUDIO")
            print(audioURL!)
            
            //Crear opciones para el grabador de audio
            var settings : [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabaciones de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        }catch let error as NSError {
            print(error)
        }
    }

    @IBAction func addTaped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
}
