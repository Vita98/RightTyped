//
//  ScannerViewController2.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/04/24.
//

import UIKit
import AVFoundation

protocol ScannerViewControllerDelegate {
    func scannerViewControllerDidFound<T: QRCodable>(model: T)
}

class ScannerViewController<T: QRCodable>: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: Custom variables
    private var animationInitialized: Bool = false
    private var animationGoing: Bool = false
    private var innerView: InnerScannerView?
    
    //MARK: Scanner component
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let centralMaskPadding: CGFloat = 35
    
    //MARK: Public configurations
    public var delegate: ScannerViewControllerDelegate?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Start the animation
        animateBox(true)
        checkOrAskCameraPermission()
    }
    
    //MARK: Configuration
    private func configure() {
        self.view.backgroundColor = .black
        configureInnerView()
        innerView?.overlayView.backgroundColor = .black.withAlphaComponent(0.7)
        innerView?.closeButton.setTitle("", for: .normal)
        innerView?.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        innerView?.frameQrLabel.set(text: AppString.Share.frameQrCode, size: 25)
        innerView?.frameQrLabel.textColor = .componentColor
        innerView?.flashImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flashButtonPressed)))
        
        makeRoundedRectangularHole()
    }
    
    private func configureInnerView() {
        innerView = UIView.instanceFromNib()
        guard let innerView = innerView else { return }
        innerView.backgroundColor = .black
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(innerView)
        innerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        innerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        innerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        innerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    
    private func animateBox(_ animate: Bool) {
        if animate {
            if animationInitialized {
                if !animationGoing {
                    innerView?.qrCodeScanBoxImageView.resumeAnimation()
                    animationGoing = true
                }
            } else {
                animationInitialized = true
                animationGoing = true
                UIView.animate(withDuration: 1.8, delay: 0, options: [.repeat, .autoreverse]) {
                    self.innerView?.qrCodeScanBoxImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            }
        } else {
            if animationGoing {
                innerView?.qrCodeScanBoxImageView.pauseAnimation()
                animationGoing = false
            }
        }
    }
    
    private func calcRectOfInterest() -> CGRect {
        guard let innerView = self.innerView else { return .zero }
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let boxWidth = width - (innerView.leadingBoxImageViewConstraint.constant * 2) - (centralMaskPadding * 2)
        let xStart = innerView.leadingBoxImageViewConstraint.constant + centralMaskPadding
        let yStart = (height / 2) - (boxWidth / 2)
        let c = CGRect(x: xStart, y: yStart, width:boxWidth, height: boxWidth)
        return c
    }
    
    func makeRoundedRectangularHole() {
        guard let overlayView = innerView?.overlayView else { return }
        let entireViewPath = UIBezierPath(rect: overlayView.bounds)
        let roundedRect = calcRectOfInterest()
        let roundedRectPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners:.allCorners, cornerRadii: CGSize(width: 10, height: 10))
        entireViewPath.append(roundedRectPath)
        entireViewPath.usesEvenOddFillRule = true

        let maskLayer = CAShapeLayer()
        maskLayer.path = entireViewPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        innerView?.overlayView.layer.mask = maskLayer
    }
    
    private func checkOrAskCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            setCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.setCamera()
                } else {
                    //access denied
                    //Show permission not granted message
                    Task { @MainActor in self.showCameraNotPermitted() }
                }
            })
        }
    }
    
    private func setCamera() {
        Task { @MainActor in
            guard await configureSession() else {
                self.showGenericCameraError()
                return
            }
        }
    }
    
    @discardableResult
    private func configureSession() async -> Bool {
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return false }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)

        } catch { return false }
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = innerView?.layer.bounds ?? view.layer.bounds
        
        innerView?.layer.insertSublayer(videoPreviewLayer!, at: 0)
        videoPreviewLayer?.opacity = 0
        captureSession.commitConfiguration()
        let rectOfInterest = calcRectOfInterest()
        DispatchQueue.global(qos: .background).async {[captureSession, videoPreviewLayer] in
            captureSession.startRunning()
            if let rectOfInterest = videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: rectOfInterest) {
                captureMetadataOutput.rectOfInterest = rectOfInterest
            }
            Task {@MainActor in self.runningStarted() }
        }
        return true
    }
    
    private func runningStarted() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        videoPreviewLayer?.opacity = 1.0
        videoPreviewLayer?.add(animation, forKey: "fade")
    }
    
    private func scanForQr(_ scan: Bool) {
        if scan {
            if !captureSession.isRunning {
                animateBox(true)
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.startRunning()
                }
            }
        } else {
            animateBox(false)
            captureSession.stopRunning()
        }
    }
    
    //MARK: Flash
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                self.innerView?.flashImageView.imageAnimated = UIImage(named: "flash")
            } else {
                try device.setTorchModeOn(level: 1.0)
                self.innerView?.flashImageView.imageAnimated = UIImage(named: "flash-filled")
            }
            device.unlockForConfiguration()
        } catch { }
    }
    
    //MARK: Events
    @objc private func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc private func flashButtonPressed() {
        toggleFlash()
    }
    
    //MARK: Popup
    @MainActor
    private func showGenericCameraError() {
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Premium.Popup.Failure.title, description: AppString.Share.genericCameraError)
        alert.addButton(withText: AppString.General.close){[weak self] in
            alert.dismiss(animated: true) {
                self?.dismiss(animated: true)
            }
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showInvalidQrCode() {
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.Share.invalidQrCodeTitle, description: AppString.Share.invalidQrCodeDesc)
        alert.addButton(withText: AppString.General.close){ [weak self] in
            alert.dismiss(animated: true) {
                self?.scanForQr(true)
            }
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func showCameraNotPermitted(){
        let alert : GenericResultViewController = UIStoryboard.main().instantiate()
        alert.configure(image: UIImage(named: "warningIcon"), title: AppString.General.warning, description: AppString.Share.cameraNotGrantedDesc)
        alert.addButton(withText: AppString.EnableKeyboardViewController.goToSettings){
            Task { @MainActor in self.goToSettings() }
        }
        alert.addButton(withText: AppString.General.close){[weak self] in
            alert.dismiss(animated: true) {
                self?.dismiss(animated: true)
            }
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
    }
    
    private func goToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: {_ in})
        }
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //Disable scanning
        scanForQr(false)
        
        //Get qrcode read
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let data = readableObject.binaryValue, let categoryScanned = QRCodeHelper.readQRCode(data: data, type: T.self) else {
                showInvalidQrCode()
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.dismiss(animated: true) { [weak self] in
                self?.delegate?.scannerViewControllerDidFound(model: categoryScanned)
            }
        }
    }
}


