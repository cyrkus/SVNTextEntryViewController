//
//  ViewController.swift
//  Tester
//
//  Created by Aaron Dean Bikis on 4/10/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit

import SVNMaterialButton
import SVNModalViewController
import SVNTheme

public protocol SVNTextEntryViewControllerDelegate: class {
    func SVNTextEntryVC(didSubmit text: String)
}

open class SVNTextEntryViewController: SVNModalViewController {
    
    public weak var delegate:  SVNTextEntryViewControllerDelegate!
    
    public var yPadding: CGFloat = 35.0
    
    private lazy var header: UILabel = {
        let label = UILabel(frame: CGRect(
            x: 15,
            y: self.dismissButton.frame.origin.y + self.dismissButton.frame.size.height + self.yPadding,
            width: self.view.frame.width - 15 * 2,
            height: 55))
        label.textColor = self.theme.stanardButtonTintColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = self.theme.largeHeading
        label.text = self.model.headerTitle
        return label
    }()
    
    private lazy var seperator: CALayer = {
        let divider = CAShapeLayer()
        divider.strokeColor = self.model.seperatorColor.cgColor
        divider.fillColor = UIColor.clear.cgColor
        divider.lineWidth = 1.0
        let line = UIBezierPath()
        line.lineWidth = 1.0
        let y = self.header.frame.size.height + self.header.frame.origin.y + self.yPadding
        line.move(to: CGPoint(x: 45, y: y))
        line.addLine(to: CGPoint(x: self.view.bounds.width - 45, y: y))
        divider.path = line.cgPath
        return divider
    }()
    
    private lazy var acceptButton: SVNMaterialButton = {
        let button = SVNMaterialButton(frame: CGRect(
            x: 45,
            y: self.view.frame.height - (self.yPadding + 65),
            width: self.view.frame.width - 45 * 2,
            height: 65), color: self.theme.primaryDialogColor)
        button.titleLabel?.font = self.theme.body
        button.setTitle(self.model.confirmButtonTitle, for: .normal)
        return button
    }()
    
    private lazy var textEditor: UITextView = {
        let y = self.header.frame.origin.y + self.header.frame.size.height + self.yPadding + 25
        let tv = UITextView(frame: CGRect(
            x: 65,
            y: y,
            width: self.view.frame.width - 65 * 2,
            height: self.acceptButton.frame.origin.y - (y + self.yPadding)))
        tv.backgroundColor = UIColor.clear
        tv.font = self.theme.textField
        tv.textColor = UIColor.white
        tv.tintColor = UIColor.white
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.borderWidth = 0.5
        return tv
    }()
    
    public var model: SVNTextEntryViewModel!
    
    
    //MARK: Init
    public init(theme:SVNTheme?, model: SVNTextEntryViewModel?, delegate: SVNTextEntryViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme == nil ? SVNTheme_DefaultDark() : theme!
        self.model = model == nil ? SVNTextEntryVM() : model!
        self.delegate = delegate
    }
    
    public init(theme: SVNTheme?, model: SVNTextEntryViewModel?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: SVNTextEntryViewControllerDelegate) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.theme = theme == nil ? SVNTheme_DefaultDark() : theme!
        self.model = model == nil ? SVNTextEntryVM() : model!
        self.delegate = delegate
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported us init(theme: model) or init(theme: model: nibNamed: bundleNamed:)")
    }
    
    
    //Mark: LifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.stylizeView()
    }
    
     override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addEditingGesture(true)
        self.layoutView()
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.addEditingGesture(false)
    }
    
    private func stylizeView(){
        self.view.backgroundColor = theme.tertiaryDialogColor
        self.acceptButton.addTarget(self, action: #selector(shouldSubmit), for: .touchUpInside)
    }
    
    private func addEditingGesture(_ shouldAdd: Bool){
        if shouldAdd {
            let tgr = UITapGestureRecognizer(target: self,
                                             action: #selector(SVNTextEntryViewController.shouldEndEditing))
            view.addGestureRecognizer(tgr)
        } else {
            self.view.gestureRecognizers?.forEach({
                self.view.removeGestureRecognizer($0)
            })
        }
    }
    
    /**
     be careful when editing this as layers and subviews are dependent upon eachother
     */
    private func layoutView(){
        self.addModalSubviews()
        self.view.addSubview(self.acceptButton)
        self.view.addSubview(self.header)
        self.view.addSubview(self.textEditor)
        self.view.layer.addSublayer(seperator)
    }
    
    //MARK: Actions
    public func shouldEndEditing(){
        self.view.endEditing(true)
    }
    
    public func shouldSubmit(){
        guard textEditor.text != nil && textEditor.text != "" else { return }
        self.delegate.SVNTextEntryVC(didSubmit: self.textEditor.text!)
    }
}
