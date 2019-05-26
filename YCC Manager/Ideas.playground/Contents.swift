import Cocoa
import PlaygroundSupport

public class ImagesStackView: NSView {
    //MARK:- APIs to config Image layers
    public var angleSteps: Double = 15 {
        didSet {
            applyRotation()
        }
    }
    public var aspectRatio: Double = 1.3  {
        didSet {
            calculateFrames()
        }
    }
    
    public var imageBorderWidth: CGFloat = 1.0 {
        didSet {
            applyBorder()
        }
    }
    
    public var imageBorderColor: CGColor = NSColor.white.cgColor {
        didSet {
            applyBorder()
        }
    }
    
    public var imageShadowRadius: CGFloat = 5.0 {
        didSet {
            applyShadow()
        }
    }
    
    public var imageShadowOffset: CGSize = CGSize(width: 0.2, height: 0.2) {
        didSet {
            applyShadow()
        }
    }
    
    public var imageShadowOpacity: Float = 0.3 {
        didSet {
            applyShadow()
        }
    }
    public var imageShadowColor: CGColor = NSColor.black.cgColor {
        didSet {
            applyShadow()
        }
    }
    
    // APIs to change Content
    public var images: [NSImage] = [] {
        didSet {
            displayImages()
        }
    }
    
    private var imageLayers: [CALayer] = []
    private let maxImages = 3
    private let padding: CGFloat = 1.0
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configView()
    }
    
    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        configView()
    }
    
    public override func layoutSubtreeIfNeeded() {
        super.layoutSubtreeIfNeeded()
        
        configLayers()
    }
    
    private func makeLayers() {
        imageLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        imageLayers = []
        
        imageLayers = Array(1...maxImages).map { index -> CALayer in
            let l = CALayer()
            l.contentsGravity = .resizeAspectFill
            l.masksToBounds = true
            l.isHidden = true
            layer?.addSublayer(l)
            return l
        }
    }
    
    private func configLayers() {
        // Reset the transformation when applied already so
        // that the bounds can be calculated freshly
        imageLayers.forEach { imageLayer in
            imageLayer.transform = CATransform3DIdentity
        }
        
        calculateFrames()
        applyBorder()
        applyShadow()
        applyRotation()
        layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    private func calculateFrames() {
        let height = heightOfImages()
        let width = CGFloat(aspectRatio) * height
        
        let dh = bounds.height - height
        let dw = bounds.width - width
        
        let dx = dw/2.0 + padding
        let dy = dh/2.0 + padding
        
        imageLayers.forEach { layer in
            layer.frame = bounds.insetBy(dx: dx, dy: dy)
        }
    }
    
    private func applyBorder() {
        imageLayers.forEach { layer in
            layer.borderWidth = imageBorderWidth
            layer.borderColor = imageBorderColor
        }
    }
    
    private func applyShadow() {
        imageLayers.dropFirst().forEach { layer in
            layer.shadowRadius = imageShadowRadius
            layer.shadowOffset = imageShadowOffset
            layer.shadowColor = imageShadowColor
            layer.shadowOpacity = imageShadowOpacity
        }
    }
    
    private func applyRotation() {
        for (index, imageLayer) in imageLayers.dropFirst().enumerated() {
            imageLayer.transform = CATransform3DMakeRotation(angle(at: index + 1), 0, 0, 1.0)
        }
    }
    
    private func displayImages() {
        imageLayers.forEach{ layer in
            layer.isHidden = true
        }
        
        for (index, image) in images.prefix(3).enumerated() {
            imageLayers[index].contents = image
            imageLayers[index].isHidden = false
        }
    }
    
    private func configView() {
        wantsLayer = true
        
        makeLayers()
        configLayers()
        displayImages()
    }
    
    private func angle(at index: Int) -> CGFloat {
        let angleInDeg = self.angleSteps * Double(index)
        return CGFloat(self.angleInRad(angleInDeg))
    }
    
    /**
     * When a rectangle of length l and breadth b is inscribed
     * at an angle insided a rectangle of length L and breadth B
     * L = l * cos(theta) + h * sin(theta)
     *
     * ar (aspect ratio) = l/h
     * l = h * ar
     *
     * L = h * ar * cos(theta) + h * sin(theta)
     * L = h * (ar * cons(theta) + sin(theta))
     * h = L / (ar * cos(theta) + sin(theta))
     *
     * Here, L = View Width & H = View Height
     * And l = Image Width & h = Image Heigth
    */
    private func heightOfImages() -> CGFloat {
        let viewWidth = bounds.size.width
        let denominator = aspectRatio * cos(angleInRad(45)) + sin(angleInRad(45))
        
        return viewWidth / CGFloat(denominator)
    }
    
    private func angleInRad(_ deg: Double) -> Double {
        return deg * .pi / 180.0
    }
}

let dimensions = (width: 200, height: 240)
let imageStackView = ImagesStackView(
    frame: NSRect(
        x: dimensions.width/2,
        y: dimensions.height/2,
        width: dimensions.width,
        height: dimensions.height
    )
)
imageStackView.images = [#imageLiteral(resourceName: "jewel01.jpg"), #imageLiteral(resourceName: "jewel02.jpg"), #imageLiteral(resourceName: "jewel03.jpg")]

let containerView = NSView(
    frame: imageStackView.frame.insetBy(dx: -100, dy: -100)
)
containerView.wantsLayer = true
containerView.layer?.backgroundColor = NSColor.lightGray.cgColor
containerView.addSubview(imageStackView)

imageStackView.angleSteps = 15
containerView.frame = containerView.frame.insetBy(dx: -100, dy: -100)
imageStackView.frame = NSRect(x: 150, y: 150, width: 300, height: 300)

imageStackView.angleSteps = -22.5
imageStackView.aspectRatio = 0.75
imageStackView.imageBorderWidth = 2.0
containerView.frame = containerView.frame.insetBy(dx: -100, dy: -100)
imageStackView.frame = NSRect(x: 250, y: 250, width: 400, height: 400)

PlaygroundPage.current.liveView = containerView
