//
//  MainView.swift
//  MacDemo
//
//  Created by 云淡风轻 on 2019/9/18.
//  Copyright © 2019 云淡风轻. All rights reserved.
//

import Cocoa

class MainView: NSView, NSTextFieldDelegate, NSComboBoxDelegate, NSComboBoxDataSource {

    
    // 左视图
    var leftView: NSView!
    
    /// 要生成的视图类
    var classNameView: NSView!
    var classText: NSTextField!
    var classBox: NSComboBox!
    
    /// 视图变量名
    var nameView: NSView!
    var nameTextField: NSTextField!
    
    /// 父视图名
    var superNameView: NSView!
    var superNameTextField: NSTextField!
    
    /// 位置和大小
    var frameView: NSView!
    var xTextField: NSTextField!
    var yTextField: NSTextField!
    var widthTextField: NSTextField!
    var heightTextField: NSTextField!
    
    /// 背景色
    var backgroundColorView: NSView!
    var backgroundBox: NSComboBox!
    
    /// 右视图
    var rightView: NSView!
    
    // 文本
    var textView: NSView!
    var textTextField: NSTextField!
    
    /// 文本颜色
    var textColorView: NSView!
    var textColorBox: NSComboBox!
    
    /// 字体大小
    var fontView: NSView!
    var fontTextField: NSTextField!
    
    /// 对齐方式
    var alignView: NSView!
    var alignBox: NSComboBox!
    
    /// 生成代码
    var startBtn: NSButton!
    
    /// 结果视图
    var textField: NSTextField!
    
    /// 当前第一响应者
    var selectedTextField: NSTextField?
    
    /// 全局字体大小
    let contentFont = NSFont.boldSystemFont(ofSize: 13)
    
    /// UITextField数组
    var textFieldArr: [NSTextField] = []
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown) { (event) -> NSEvent? in
            self.keyDown(with: event)
            return event
        }
        self.setupLeftView()
        self.setupRightView()
        
        // 结果输出框
        let textField = NSTextField.init()
        textField.font = self.contentFont
        textField.placeholderString = "生成的代码在这里展示, 并自动加入剪切板"
        self.addSubview(textField)
        self.textField = textField
        
        // 生成
        let startBtn = NSButton.init(title: "生成代码", target: self, action: #selector(click))
        startBtn.layer?.backgroundColor = NSColor.white.cgColor
        self.addSubview(startBtn)
        self.startBtn = startBtn
        
        self.windowDidResize()
        self.selectedTextField = self.nameTextField
        self.changeLayoutSubview()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 键盘监听
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 48 {
            if self.selectedTextField != nil {
                
                var index = self.textFieldArr.firstIndex(of: self.selectedTextField!)
                if (index! + 1) == self.textFieldArr.count {
                    index = 0
                } else {
                    index = index! + 1
                }
                let tf = self.textFieldArr[index!]
                tf.becomeFirstResponder()
                self.selectedTextField = tf
            }
        }
    }

    // MARK: - 窗口大小变化
    func windowDidResize() {
        let width = self.frame.width
        let height = self.frame.height
        let leftWidth = width - 100
        
        // 生成代码的结果展示
        self.textField.frame = CGRect(x: 0, y: 0, width: width - 100, height: 150)
        
        // 左视图布局
        self.leftView.frame = CGRect(x: 0, y: 150, width: width / 2, height: height)
        
        self.classNameView.frame = NSRect(x: 0, y: height - 150 - 20 - 40, width: leftWidth, height: 40)
        self.nameView.frame = NSRect(x: 0, y: self.classNameView.frame.minY - 40, width: leftWidth, height: 40)
        self.superNameView.frame = NSRect(x: 0, y: self.nameView.frame.minY - 40, width: leftWidth, height: 40)
        self.frameView.frame = NSRect(x: 0, y: self.superNameView.frame.minY - 40, width: leftWidth, height: 40)
        self.backgroundColorView.frame = NSRect(x: 0, y: self.frameView.frame.minY - 40, width: leftWidth, height: 40)
        
        
        // 右视图布局
        self.rightView.frame = CGRect(x: width / 2, y: 150, width: width / 2, height: height - 150)
        self.textView.frame = NSRect(x: 10, y: height - 150 - 20 - 40, width: 200, height: 40)
        self.textColorView.frame = NSRect(x: 10, y: self.textView.frame.minY - 40, width: 200, height: 40)
        self.fontView.frame = NSRect(x: 10, y: self.textColorView.frame.minY - 40, width: 200, height: 40)
        self.alignView.frame = NSRect(x: 10, y: self.fontView.frame.minY - 40, width: 200, height: 40)
        
        // 生成代码
        self.startBtn.frame = NSRect(x: width - 100, y: 60, width: 100, height: 40)
    }
    
    // MARK: - 开始生成代码
    @objc func click() {
        var code: String = ""
        
        var name = self.nameTextField.stringValue
        if name.count == 0 {
            name = "viewName"
        }
        
        var superName = self.superNameTextField.stringValue
        if superName.count == 0 {
            superName = "superView"
        }
        
        var font = self.fontTextField.stringValue
        if font.count == 0 {
            font = "15"
        }
        
        code.append("let \(name) = \(self.classBox.stringValue)()\n")
        code.append("\(name).frame = CGRect(x: \(self.xTextField.stringValue), y: \(self.yTextField.stringValue), width: \(self.widthTextField.stringValue), height: \(self.heightTextField.stringValue))\n")
        code.append("\(name).backgroundColor = .\(self.backgroundBox.stringValue)\n")
        
        let lowerName = self.classBox.stringValue.lowercased()
        if lowerName.contains("uilabel") || lowerName.contains("uitextfield") || lowerName.contains("uitextview") {
            code.append("\(name).text = \"\(self.textTextField.stringValue)\"\n")
            code.append("\(name).textColor = .\(self.textColorBox.stringValue)\n")
            code.append("\(name).font = .systemFont(ofSize:\(font))\n")
            code.append("\(name).textAlignment = .\(self.alignBox.stringValue)\n")
        }
        code.append("\(superName).addSubview(\(name))\n")
        
        self.textField.stringValue = code
        
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(code, forType: NSPasteboard.PasteboardType.string)
    }
    
    // MARK: - NSComboBoxDelegate
    func comboBoxWillDismiss(_ notification: Notification) {
        perform(#selector(changeLayoutSubview), with: nil, afterDelay: 0.5)
    }
    
    // MARK: - 根据Class名, 更新视图
    @objc func changeLayoutSubview() {
        let lowerName = self.classBox.stringValue.lowercased()
        self.textFieldArr.removeAll()
        self.textFieldArr.append(self.nameTextField)
        self.textFieldArr.append(self.superNameTextField)
        self.textFieldArr.append(self.xTextField)
        self.textFieldArr.append(self.yTextField)
        self.textFieldArr.append(self.widthTextField)
        self.textFieldArr.append(self.heightTextField)

        if lowerName.contains("uilabel") || lowerName.contains("uitextfield") || lowerName.contains("uitextview") {
            self.rightView.addSubview(self.textView)
            self.rightView.addSubview(self.textColorView)
            self.rightView.addSubview(self.fontView)
            self.rightView.addSubview(self.alignView)
            
            self.textFieldArr.append(self.textTextField)
            self.textFieldArr.append(self.fontTextField)
        } else {
            self.textView.removeFromSuperview()
            self.textColorView.removeFromSuperview()
            self.fontView.removeFromSuperview()
            self.alignView.removeFromSuperview()
        }
    }
    
    // MARK: - 左视图
    func setupLeftView() {
        // 新建视图
        let leftView = NSView()
        leftView.wantsLayer = true
        leftView.layer?.backgroundColor = NSColor.white.cgColor
        self.addSubview(leftView)
        self.leftView = leftView
        
        // 要生成的视图类
        self.setupClassNameView()
        
        // 视图变量名
        self.setupNameView()
        
        // 父视图名
        self.setupSuperNameView()
        
        // 视图的位置和大小, 默认0, 0, 50, 50
        self.setupFrameView()
        
        // 背景色
        self.setupBackgroundColorView()
    }
    
    // MARK: 要生成的类
    func setupClassNameView() {
        // 要生成的类
        let classNameView = NSView()
        leftView.addSubview(classNameView)
        self.classNameView = classNameView
        
        let classText = NSTextField()
        classText.frame = NSRect(x: 0, y: 10.5, width: 100, height: 21.5)
        classText.alignment = .center
        classText.layer?.backgroundColor = NSColor.clear.cgColor
        classText.stringValue = "UI控件"
        classText.isEditable = false
        classNameView.addSubview(classText)
        
        let classBox = NSComboBox()
        classBox.frame = NSRect(x: 100, y: 7.5, width: 100, height: 25)
        classBox.usesDataSource = false
        classBox.addItems(withObjectValues: ["UIView", "UIButton", "UILabel", "UITextField", "UITextView"])
        classBox.selectItem(at: 0)
        classBox.font = self.contentFont
        classBox.isEditable = true
        classBox.alignment = .center
        classBox.delegate = self
        classNameView.addSubview(classBox)
        self.classBox = classBox
    }
    
    // MARK: 视图变量名
    func setupNameView() {
        // 位置和大小
        let nameView = NSView()
        leftView.addSubview(nameView)
        self.nameView = nameView
        
        let nameText = NSTextField()
        nameText.frame = NSRect(x: 0, y: 10, width: 100, height: 20)
        nameText.alignment = .center
        nameText.layer?.backgroundColor = NSColor.clear.cgColor
        nameText.stringValue = "变量名"
        nameText.isEditable = false
        nameView.addSubview(nameText)
        
        let nameTextField = NSTextField()
        nameTextField.frame = NSRect(x: nameText.frame.maxX, y: 10, width: 100, height: 20)
        nameTextField.font = self.contentFont
        nameTextField.placeholderString = "viewName"
        nameView.addSubview(nameTextField)
        self.nameTextField = nameTextField
    }
    
    // MARK: 视图变量名
    func setupSuperNameView() {
        // 位置和大小
        let superNameView = NSView()
        leftView.addSubview(superNameView)
        self.superNameView = superNameView
        
        let nameText = NSTextField()
        nameText.frame = NSRect(x: 0, y: 10, width: 100, height: 20)
        nameText.alignment = .center
        nameText.layer?.backgroundColor = NSColor.clear.cgColor
        nameText.stringValue = "父视图"
        nameText.isEditable = false
        superNameView.addSubview(nameText)
        
        let superNameTextField = NSTextField()
        superNameTextField.frame = NSRect(x: nameText.frame.maxX, y: 10, width: 100, height: 20)
        superNameTextField.font = self.contentFont
        superNameTextField.placeholderString = "superView"
        superNameView.addSubview(superNameTextField)
        self.superNameTextField = superNameTextField
    }
    
    // MARK: 位置和大小
    func setupFrameView() {
        // 位置和大小
        let frameView = NSView()
        leftView.addSubview(frameView)
        self.frameView = frameView
        
        let xText = NSTextField()
        xText.frame = NSRect(x: 0, y: 10, width: 20, height: 20)
        xText.alignment = .center
        xText.layer?.backgroundColor = NSColor.clear.cgColor
        xText.stringValue = "x"
        xText.isEditable = false
        frameView.addSubview(xText)
        
        let xTextField = NSTextField()
        xTextField.frame = NSRect(x: xText.frame.maxX, y: 10, width: 40, height: 20)
        xTextField.stringValue = "0"
        xTextField.font = contentFont
        frameView.addSubview(xTextField)
        self.xTextField = xTextField
        
        // y
        let yText = NSTextField()
        yText.frame = NSRect(x: xTextField.frame.maxX + 10, y: 10, width: 20, height: 20)
        yText.alignment = .center
        yText.layer?.backgroundColor = NSColor.clear.cgColor
        yText.stringValue = "y"
        yText.isEditable = false
        frameView.addSubview(yText)
        
        let yTextField = NSTextField()
        yTextField.frame = NSRect(x: yText.frame.maxX, y: 10, width: 44, height: 20)
        yTextField.stringValue = "0"
        yTextField.font = contentFont
        frameView.addSubview(yTextField)
        self.yTextField = yTextField
        
        // width
        let widthText = NSTextField()
        widthText.frame = NSRect(x: yTextField.frame.maxX + 10, y: 10, width: 44, height: 20)
        widthText.alignment = .center
        widthText.layer?.backgroundColor = NSColor.clear.cgColor
        widthText.stringValue = "width"
        widthText.isEditable = false
        frameView.addSubview(widthText)
        
        let widthTextField = NSTextField()
        widthTextField.frame = NSRect(x: widthText.frame.maxX, y: 10, width: 44, height: 20)
        widthTextField.stringValue = "100"
        widthTextField.font = contentFont
        frameView.addSubview(widthTextField)
        self.widthTextField = widthTextField
        
        let heightText = NSTextField()
        heightText.frame = NSRect(x: widthTextField.frame.maxX + 10, y: 10, width: 50, height: 20)
        heightText.alignment = .center
        heightText.layer?.backgroundColor = NSColor.clear.cgColor
        heightText.stringValue = "height"
        heightText.isEditable = false
        frameView.addSubview(heightText)
        
        let heightTextField = NSTextField()
        heightTextField.frame = NSRect(x: heightText.frame.maxX, y: 10, width: 44, height: 20)
        heightTextField.stringValue = "40"
        heightTextField.font = contentFont
        frameView.addSubview(heightTextField)
        self.heightTextField = heightTextField
    }
    
    // MARK: 对齐方式
    func setupBackgroundColorView() {
        // 对齐方式
        let backgroundColorView = NSView()
        leftView.addSubview(backgroundColorView)
        self.backgroundColorView = backgroundColorView
        
        let alignText = NSTextField()
        alignText.frame = NSRect(x: 0, y: 10.5, width: 100, height: 21.5)
        alignText.alignment = .center
        alignText.layer?.backgroundColor = NSColor.clear.cgColor
        alignText.stringValue = "背景色"
        alignText.isEditable = false
        backgroundColorView.addSubview(alignText)
        
        let box = NSComboBox()
        box.frame = NSRect(x: 100, y: 7.5, width: 100, height: 25)
        box.usesDataSource = false
        box.addItems(withObjectValues: ["clear", "black", "white", "red", "orange", "yellow", "green", "cyan", "blue", "purple"])
        box.selectItem(at: 0)
        box.isEditable = false
        box.alignment = .center
        box.font = self.contentFont
        backgroundColorView.addSubview(box)
        self.backgroundBox = box
    }
    
    // MARK: - 右视图
    func setupRightView() {
        // 右侧功能视图
        let rightView = NSView()
        rightView.wantsLayer = true
        rightView.layer?.backgroundColor = NSColor.white.cgColor
        rightView.needsDisplay = true
        self.addSubview(rightView)
        self.rightView = rightView
        
        // 文本
        self.setupTextView()
        
        // 文本颜色
        self.setupTextColorView()
        
        // 字体大小
        self.setupFontView()
        
        // 对齐方式
        self.setupAlignView()
    }
    
    // MARK: 文本
    func setupTextView() {
        let view = NSView()
        self.rightView.addSubview(view)
        self.textView = view
        
        let text = NSTextField()
        text.frame = NSRect(x: 0, y: 10, width: 100, height: 20)
        text.alignment = .center
        text.layer?.backgroundColor = NSColor.clear.cgColor
        text.stringValue = "文本"
        text.isEditable = false
        view.addSubview(text)
        
        let textField = NSTextField()
        textField.frame = NSRect(x: text.frame.maxX, y: 10, width: 100, height: 20)
        textField.font = self.contentFont
        textField.placeholderString = "要展示的内容"
        textField.alignment = .center
        view.addSubview(textField)
        self.textTextField = textField
    }
    
    // MARK: 文本颜色
    func setupTextColorView() {
        let view = NSView()
        self.rightView.addSubview(view)
        self.textColorView = view
        
        let text = NSTextField()
        text.frame = NSRect(x: 0, y: 10, width: 100, height: 20)
        text.alignment = .center
        text.layer?.backgroundColor = NSColor.clear.cgColor
        text.stringValue = "文本颜色"
        text.isEditable = false
        view.addSubview(text)
        
        let box = NSComboBox()
        box.frame = NSRect(x: 100, y: 7.5, width: 100, height: 25)
        box.usesDataSource = false
        box.addItems(withObjectValues: ["black", "white", "red", "orange", "yellow", "green", "cyan", "blue", "purple"])
        box.selectItem(at: 0)
        box.isEditable = false
        box.alignment = .center
        box.font = self.contentFont
        view.addSubview(box)
        self.textColorBox = box
    }
    
    // MARK: 字体大小
    func setupFontView() {
        let view = NSView()
        self.rightView.addSubview(view)
        self.fontView = view
        
        let text = NSTextField()
        text.frame = NSRect(x: 0, y: 10, width: 100, height: 20)
        text.alignment = .center
        text.layer?.backgroundColor = NSColor.clear.cgColor
        text.stringValue = "字体大小"
        text.isEditable = false
        view.addSubview(text)
        
        let textField = NSTextField()
        textField.frame = NSRect(x: text.frame.maxX, y: 10, width: 100, height: 20)
        textField.font = self.contentFont
        textField.placeholderString = "15"
        textField.alignment = .center
        view.addSubview(textField)
        self.fontTextField = textField
    }
    
    // MARK: 对齐方式
    func setupAlignView() {
        // 对齐方式
        let view = NSView()
        self.rightView.addSubview(view)
        self.alignView = view
        
        let text = NSTextField()
        text.frame = NSRect(x: 0, y: 10.5, width: 100, height: 21.5)
        text.alignment = .center
        text.layer?.backgroundColor = NSColor.clear.cgColor
        text.stringValue = "对齐方式"
        text.isEditable = false
        view.addSubview(text)
        
        let box = NSComboBox()
        box.frame = NSRect(x: 100, y: 7.5, width: 100, height: 25)
        box.usesDataSource = false
        box.addItems(withObjectValues: ["left", "center", "right"])
        box.selectItem(at: 0)
        box.isEditable = false
        box.alignment = .center
        box.font = self.contentFont
        view.addSubview(box)
        self.alignBox = box
    }
}
