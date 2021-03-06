//
//  PWSwitch.swift
//  Pods
//
//  Created by Nikita on 30/08/16.
//
//

import Foundation
import UIKit

@IBDesignable
open class PWSwitch: UIControl {
    
    var backLayer: CALayer!
    var thumbLayer: CALayer!
    
    private var _isOn: Bool = false
    
    private var _trackOffBorderColor: UIColor? = UIColor(0xB1BBC3)
    private var _trackOffFillColor: UIColor? = .clear
    private var _trackOnBorderColor: UIColor? = UIColor(0xFFB831)
    private var _trackOnFillColor: UIColor? = .clear
    private var _thumbOffBorderColor: UIColor? = UIColor(0xFFB831)
    private var _thumbOffFillColor: UIColor? = .white
    private var _thumbOnBorderColor: UIColor? = UIColor(0xF0AA26)
    private var _thumbOnFillColor: UIColor? = .white
    private var _thumbShadowColor: UIColor? = UIColor(0x919CA6).withAlphaComponent(0.26)
    private var _thumbDiameter: CGFloat = 14
    private var _cornerRadius: CGFloat = 13
    private var _thumbCornerRadius: CGFloat = 7
    private var _shouldFillOnPush: Bool = true
    private var _trackInset: CGFloat = 0
    private var _shadowStrength: CGFloat = 1
    
    /// UIAppearance compatible property
    @IBInspectable open dynamic var trackOffBorderColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._trackOffBorderColor }
        set {
            self._trackOffBorderColor = newValue
            self.backLayer.borderColor = _trackOffBorderColor?.cgColor
        }
    }
    
    @IBInspectable open dynamic var trackOffFillColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._trackOffFillColor }
        set {
            self._trackOffFillColor = newValue
            self.backLayer.backgroundColor = _trackOffFillColor?.cgColor
        }
    }

    @IBInspectable open dynamic var thumbOffBorderColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._thumbOffBorderColor }
        set {
            self._thumbOffBorderColor = newValue
            self.thumbLayer.borderColor = _thumbOffBorderColor?.cgColor
        }
    }
    
    @IBInspectable open dynamic var thumbOffFillColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._thumbOffFillColor }
        set {
            self._thumbOffFillColor = newValue
            self.thumbLayer.backgroundColor = _thumbOffFillColor?.cgColor
        }
    }
    
    @IBInspectable open dynamic var trackOnFillColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._trackOnFillColor }
        set {
            self._trackOnFillColor = newValue
        }
    }
    
    @IBInspectable open dynamic var trackOnBorderColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._trackOnBorderColor }
        set {
            self._trackOnBorderColor = newValue
        }
    }
    
    @IBInspectable open dynamic var thumbOnBorderColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._thumbOnBorderColor }
        set {
            self._thumbOnBorderColor = newValue
        }
    }
    
    @IBInspectable open dynamic var thumbOnFillColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._thumbOnFillColor }
        set {
            self._thumbOnFillColor = newValue
        }
    }
    
    @IBInspectable open dynamic var thumbDiameter: CGFloat { // UI_APPEARANCE_SELECTOR
        get { return self._thumbDiameter }
        set {
            self._thumbDiameter = newValue
            self.thumbLayer.frame = getThumbOffRect()
            self.thumbLayer.cornerRadius = thumbDiameter / 2
        }
    }
    
    @IBInspectable open dynamic var cornerRadius: CGFloat { // UI_APPEARANCE_SELECTOR
        get { return self._cornerRadius }
        set {
            self._cornerRadius = newValue
            self.backLayer.cornerRadius = _cornerRadius
        }
    }
    
    @IBInspectable open dynamic var thumbCornerRadius: CGFloat { // UI_APPEARANCE_SELECTOR
        get { return self._thumbCornerRadius }
        set {
            self._thumbCornerRadius = newValue
            self.thumbLayer.cornerRadius = _thumbCornerRadius
        }
    }
    
    @IBInspectable open dynamic var shouldFillOnPush: Bool { // UI_APPEARANCE_SELECTOR
        get { return self._shouldFillOnPush }
        set {
            self._shouldFillOnPush = newValue
        }
    }
    
    @IBInspectable open dynamic var trackInset: CGFloat { // UI_APPEARANCE_SELECTOR
        get { return self._trackInset }
        set {
            self._trackInset = newValue
        }
    }
    
    @IBInspectable open dynamic var thumbShadowColor: UIColor? { // UI_APPEARANCE_SELECTOR
        get { return self._thumbShadowColor }
        set {
            self._thumbShadowColor = newValue
            self.thumbLayer.shadowColor = _thumbShadowColor?.cgColor
        }
    }
    
    @IBInspectable open dynamic var shadowStrength: CGFloat { // UI_APPEARANCE_SELECTOR
        get { return self._shadowStrength }
        set {
            self._shadowStrength = newValue
            self.thumbLayer.shadowOffset = CGSize(width: 0, height: 1.5 * _shadowStrength)
            self.thumbLayer.shadowRadius = 0.6 * (_shadowStrength * 2)
        }
    }
    
    let thumbDelta: CGFloat = 6
    
    let scale = UIScreen.main.scale
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    fileprivate func commonInit() {
        clipsToBounds = false
        
        backLayer = CALayer()
        backLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 26)
        backLayer.cornerRadius = _cornerRadius
        backLayer.borderWidth = 1
        backLayer.borderColor = _trackOffBorderColor?.cgColor
        backLayer.backgroundColor = _trackOffFillColor?.cgColor
        layer.addSublayer(backLayer)
        
        thumbLayer = CALayer()
        thumbLayer.frame = getThumbOffRect()
        thumbLayer.cornerRadius = _thumbCornerRadius
        thumbLayer.backgroundColor = _thumbOffFillColor?.cgColor
        thumbLayer.borderWidth = 1
        thumbLayer.shadowOffset = CGSize(width: 0, height: 1.5 * _shadowStrength)
        thumbLayer.shadowRadius = 0.6 * (_shadowStrength * 2)
        thumbLayer.shadowColor = _thumbShadowColor?.cgColor
        thumbLayer.shadowOpacity = 1
        thumbLayer.borderColor = _thumbOffBorderColor?.cgColor
        
        layer.addSublayer(thumbLayer)
    }
    
    // MARK: - Layout
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: 50, height: 26)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: trackInset, left: trackInset, bottom: trackInset, right: trackInset)
        backLayer.frame = UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    fileprivate func getThumbOffRect() -> CGRect {
        return CGRect(x: (frame.height - thumbDiameter)/2.0, y: (frame.height - thumbDiameter)/2.0, width: thumbDiameter, height: thumbDiameter)
    }
    
    fileprivate func getThumbPushRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: thumbDiameter + thumbDelta, height: thumbDiameter)
    }
    
    fileprivate func getThumbOnRect() -> CGRect {
        return CGRect(x: frame.width - thumbDiameter - ((frame.height - thumbDiameter)/2.0), y: (frame.height - thumbDiameter)/2.0, width: thumbDiameter, height: thumbDiameter)
    }
    
    fileprivate func getThumbOffPos() -> CGPoint {
        return CGPoint(x: frame.height/2.0, y: frame.height/2.0)
    }
    
    fileprivate func getThumbOffPushPos() -> CGPoint {
        return CGPoint(x: frame.height/2.0 + thumbDelta - 3, y: frame.height/2.0)
    }
    
    fileprivate func getThumbOnPos() -> CGPoint {
        return CGPoint(x: frame.width - frame.height/2.0, y: frame.height/2.0)
    }
    
    fileprivate func getThumbOnPushPos() -> CGPoint {
        return CGPoint(x: (frame.width - frame.height/2.0) - thumbDelta + 3, y: frame.height/2.0)
    }
    
    
    // MARK: - Set On/Off
    
    open var isOn: Bool {
        get {
            return _isOn
        }
        set {
            setOn(newValue, animated: false)
        }
    }
    
    open func setOn(_ on: Bool, animated: Bool) {
        _isOn = on
        
        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        if (on) {
            if (shouldFillOnPush) {
                backLayer.borderWidth = frame.height / 2
            }
            backLayer.borderColor = trackOnBorderColor?.cgColor
            backLayer.backgroundColor = trackOnFillColor?.cgColor
            thumbLayer.bounds = getThumbOnRect()
            thumbLayer.position = getThumbOnPos()
            thumbLayer.borderColor = thumbOnBorderColor?.cgColor
            thumbLayer.backgroundColor = thumbOnFillColor?.cgColor
        } else {
            if (shouldFillOnPush) {
                backLayer.borderWidth = 1
            }
            backLayer.borderColor = trackOffBorderColor?.cgColor
            backLayer.backgroundColor = trackOffFillColor?.cgColor
            thumbLayer.bounds = getThumbOffRect()
            thumbLayer.position = getThumbOffPos()
            thumbLayer.borderColor = thumbOffBorderColor?.cgColor
            thumbLayer.backgroundColor = thumbOffFillColor?.cgColor
        }
        CATransaction.commit()
    }
    
    open func toggle(animated: Bool = false) {
        setOn(!isOn, animated: animated)
    }
    
    // MARK: - Touches
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        CATransaction.begin()
        if isOn {
            thumbLayer.bounds = getThumbPushRect()
            thumbLayer.position = getThumbOnPushPos()
        } else {
            thumbLayer.bounds = getThumbPushRect()
            thumbLayer.position = getThumbOffPushPos()
        }
        CATransaction.commit()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if (bounds.contains(touchPoint)) {
            setOn(!isOn, animated: true)
            sendActions(for: .valueChanged)
        } else {
            setOn(isOn, animated: true)
        }
    }
}

extension UIColor {
    convenience init(_ hexValue: UInt) {
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hexValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
}
