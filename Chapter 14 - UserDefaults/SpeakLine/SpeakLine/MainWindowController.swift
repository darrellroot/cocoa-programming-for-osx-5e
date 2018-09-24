//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {

    override var windowNibName: NSNib.Name? {
        return NSNib.Name("MainWindowController")
    }

    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let preferenceManager = PreferenceManager()
    let speechSynth: NSSpeechSynthesizer = NSSpeechSynthesizer()
    
    let voices = NSSpeechSynthesizer.availableVoices
    var voicesIdentifiers: [String] = []

    var isStarted: Bool = false {
        didSet {
        updateButtons()
        }
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateButtons()
        speechSynth.delegate = self
        
        for voice in voices {
            voicesIdentifiers.append(NSSpeechSynthesizer.attributes(forVoice: voice)[.identifier] as! String)
            //voiceIdentifiers.append(voice.identifier)
        }

        let defaultVoice = preferenceManager.activeVoice!
        if let defaultRow = voicesIdentifiers.index(of: defaultVoice) {
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices as IndexSet, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
            speechSynth.setVoice(voices[defaultRow])
        }
        textField.stringValue = preferenceManager.activeText!
    }
    
    
    // MARK: Action methods
    @IBAction func speakIt(sender: NSButton) {
            
        // Get typed-in text as a string
        let string = textField.stringValue
        if string.isEmpty {
            print("string from \(String(describing: textField)) is empty")
        } else {
            speechSynth.startSpeaking(string)
            isStarted = true
        }
    }
    
    
    @IBAction func stopIt(sender: NSButton) {
        speechSynth.stopSpeaking()
        //isStarted = false
    }
    
    
    func updateButtons() {
        if isStarted {
            speakButton.isEnabled = false
            stopButton.isEnabled = true
        } else {
            stopButton.isEnabled = false
            speakButton.isEnabled = true
        }
    }
    
    func voiceNameForIdentifier(identifier: String) -> String? {
        let attributes = NSSpeechSynthesizer.attributes(forVoice: NSSpeechSynthesizer.VoiceName(rawValue: identifier))
        return attributes[NSSpeechSynthesizer.VoiceAttributeKey.name] as? String
    }

    
    // MARK: NSSpeechSynthesizerDelegate
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
        print("finishedSpeaking=\(finishedSpeaking)")
    }
    
    
    // MARK: NSWindowDelegate
    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
    

    // MARK: NSTableViewDataSource
    func numberOfRows(in: NSTableView) -> Int {
        return voices.count
    }
    
 
    func tableView(_ tableView: NSTableView, objectValueFor: NSTableColumn?, row: Int) -> Any? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(identifier: voice.rawValue)
        return voiceName
    }
    
    
    // MARK: NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
            
        // Set the voice back to the default if the user has deselected all rows
        if row == -1 {
            speechSynth.setVoice(nil)
        return
        }
        let voice = voices[row]
        speechSynth.setVoice(voice)
        preferenceManager.activeVoice = voice.rawValue
    }
    
    
    // MARK: - NSTextFieldDelegate
    func controlTextDidChange(_ obj: Notification) {
        preferenceManager.activeText = textField.stringValue
    }
    
}
