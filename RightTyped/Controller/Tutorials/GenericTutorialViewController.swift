//
//  GenericTutorialViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/08/23.
//

import UIKit

class GenericTutorialViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var gifShadowView: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gifTopSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var gifWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gifHeightConstraint: NSLayoutConstraint!
    var gifHeightValue: Double?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: TutorialPageModel?{
        didSet{
            configureModel()
        }
    }
    var tutTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        configureModel()
        configureGifConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {[weak self] in
            self?.configureGif()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gifHeightValue = self.view.frame.height * gifHeightConstraint.multiplier
        
        gifImageView.clipsToBounds = true
        gifImageView.layer.cornerRadius = model?.gifViewCornerRadius ?? 30
        gifShadowView.dropShadow(shadowType: .tutorialGifShadow)
        gifShadowView.layer.cornerRadius = model?.gifViewCornerRadius ?? 30
    }
    
    //MARK: - Configuration
    private func configureModel(){
        guard let model = self.model else { return }
        configureContainerView(items: model.stackContent)
        if let titleLabel = titleLabel{
            titleLabel.text = tutTitle
        }
    }
    
    private func configureGifConstraint(){
        gifHeightValue = self.view.frame.height * gifHeightConstraint.multiplier
        if let bundleURL = Bundle.main.url(forResource: model?.gifPath, withExtension: "gif"), let size = bundleURL.sizeOfImage, let gifHeightValue = gifHeightValue{
            let aspR = UIImage.getAspectRatio(size: size)
            
            if UIImage.isDominant(size: size, .height){
                gifWidthConstraint.constant = (gifHeightValue / aspR)
            }else if UIImage.isDominant(size: size,.width){
                gifTopSpacingConstraint.constant = UIDevice.current.isSmall() ? 10 : 50
                gifWidthConstraint.constant = self.view.frame.width - (UIDevice.current.isSmall() ? 50 : 30)
                gifHeightConstraint.isActive = false
                gifHeightConstraint = gifShadowView.heightAnchor.constraint(equalToConstant: gifWidthConstraint.constant / aspR)
                gifHeightConstraint.isActive = true
            }
        }
    }
    
    private func configureGif(){
        guard let model = self.model else { return }
        gifImageView.layer.cornerRadius = model.gifViewCornerRadius
        gifShadowView.layer.cornerRadius = model.gifViewCornerRadius
        if let gifImageView = gifImageView{
            var img: UIImage?
            if let image = UIImage.gifImageWithName(model.gifPath){
                img = image
            }else if let image = UIImage.loadFromBundle(model.gifPath){
                img = image
            }
            
            guard let img = img else { return }
            let aspR = img.getAspectRatio()
            
            if img.isDominant(.height), let gifHeightValue = gifHeightValue{
                gifWidthConstraint.constant = (gifHeightValue / aspR)
            }else if img.isDominant(.width){
                gifTopSpacingConstraint.constant = UIDevice.current.isSmall() ? 10 : 50
                gifWidthConstraint.constant = self.view.frame.width - (UIDevice.current.isSmall() ? 50 : 30)
                gifHeightConstraint.isActive = false
                gifHeightConstraint = gifShadowView.heightAnchor.constraint(equalToConstant: gifWidthConstraint.constant / aspR)
                gifHeightConstraint.isActive = true
            }
            
            
            UIView.transition(with: gifImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                gifImageView.image = img
            })
        }
        activityIndicator.stopAnimating()
    }
    
    private func configureContainerView(items: [StackContentItem]){
        guard let containerView = containerView else { return }
        
        var topPadding: CGFloat = 10
        if UIDevice.current.isSmall() {
            topPadding = 0
        }
        
        if items.count < 3{
            gifHeightValue = self.view.frame.height * 0.55
            let newC = gifHeightConstraint.constraintWithMultiplier(0.55)
            gifHeightConstraint.isActive = false
            newC.isActive = true
            gifShadowView.layoutIfNeeded()
            gifHeightConstraint = newC
            topPadding = 20
        }
        
        if let mul = model?.gifHeightMultiplierOnSmallDevices, UIDevice.current.isSmall(){
            gifHeightValue = self.view.frame.height * mul
            let newC = gifHeightConstraint.constraintWithMultiplier(mul)
            gifHeightConstraint.isActive = false
            newC.isActive = true
            gifShadowView.layoutIfNeeded()
            gifHeightConstraint = newC
            topPadding = 20
        }
        
        let middleView = UIView()
        var lastView: UIView?
        var i = -1
        var lastIsImage = false
        
        for item in items {
            i = i + 1
            var newV: UIView?
            switch item.type{
            case .text:
                newV = configureText(text: item.content.first ?? "")
            case .image:
                newV = configureImage(imagePath: item.content.first ?? "", size: item.size?.first)
            case .images:
                newV = configureImages(imagesPaths: item.content, sizes: item.size)
            }
            
            guard let newV = newV else { return }
            if lastView == nil{
                lastView = newV
                newV.translatesAutoresizingMaskIntoConstraints = false
                middleView.addSubview(newV)
                newV.topAnchor.constraint(equalTo: middleView.topAnchor).isActive = true
                newV.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0).isActive = true
                newV.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0).isActive = true
                
                //if the first is also the last
                if i == items.count - 1{
                    newV.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
                }
            }else if i == items.count - 1{
                newV.translatesAutoresizingMaskIntoConstraints = false
                middleView.addSubview(newV)
                newV.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: topPadding + (lastIsImage ? 5 : 0)).isActive = true
                newV.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
                newV.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0).isActive = true
                newV.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0).isActive = true
                lastView = newV
            }else{
                newV.translatesAutoresizingMaskIntoConstraints = false
                middleView.addSubview(newV)
                newV.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: topPadding + (item.type == .image ? 5 : 0)).isActive = true
                newV.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0).isActive = true
                newV.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0).isActive = true
                lastView = newV
            }
            lastIsImage = item.type == .image
        }
        
        containerView.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        middleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        middleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    private func configureImage(imagePath: String, size: CGSize? = nil) -> UIView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: imagePath)?.withTintColor(.componentColor)
        imageView.contentMode = .scaleAspectFit
        if let size = size{
            imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        return imageView
    }
    
    private func configureImages(imagesPaths: [String], sizes: [CGSize?]? = nil) -> UIView{
        let view = UIView()
        let contView = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contView)
        
        contView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 0).isActive = true
        contView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 0).isActive = true
        contView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        contView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
        var lastImageView: UIImageView? = nil
        
        for i in 0..<imagesPaths.count{
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: imagesPaths[i])?.withTintColor(.componentColor)
            imageView.contentMode = .scaleAspectFit
            if let size = sizes?[i]{
                imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            
            contView.addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: contView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: contView.bottomAnchor).isActive = true
            
            if lastImageView == nil{
                lastImageView = imageView
                imageView.leadingAnchor.constraint(equalTo: contView.leadingAnchor).isActive = true
            }else if i == imagesPaths.count - 1{
                //If last
                imageView.leadingAnchor.constraint(equalTo: lastImageView!.trailingAnchor, constant: 20).isActive = true
                imageView.trailingAnchor.constraint(equalTo: contView.trailingAnchor).isActive = true
            }else{
                imageView.leadingAnchor.constraint(equalTo: lastImageView!.trailingAnchor, constant: 20).isActive = true
                lastImageView = imageView
            }
        }
        return view
    }
    
    private func configureText(text: String) -> UIView{
        let label = UILabel()
        label.text = text
        label.font = UIFont.customFont(.normal, size: 21)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        
        let view = UIView()
        let cView = UIView()
        cView.enableComponentButtonMode()
        cView.layer.cornerRadius = 10
        view.addSubview(cView)
        cView.addSubview(label)
        
        cView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 0).isActive = true
        cView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 0).isActive = true
        cView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        cView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
        label.topAnchor.constraint(equalTo: cView.topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: cView.bottomAnchor, constant: -5).isActive = true
        label.trailingAnchor.constraint(equalTo: cView.trailingAnchor, constant: -20).isActive = true
        label.leadingAnchor.constraint(equalTo: cView.leadingAnchor, constant: 20).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cView.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowView = UIView()
        shadowView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        
        shadowView.layer.cornerRadius = 7
        shadowView.dropShadow(shadowType: .tutorialGifShadow)
        
        return shadowView
    }

}
