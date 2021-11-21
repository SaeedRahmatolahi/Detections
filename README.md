# Detections

Detecting Texts and Persons from Images 

Detections package will help you to get the texts from image and also recognize a person Image whihc should be only one person in the photo 


## Text Detection
to use text recognition you need to create a view controller and change the class to `DetectionViewController` , also you can pass the delegate to use the function when the texts recognized from the image 

```swift 

class DetectionVC: DetectionViewController , detectionProtocol {

    override func viewDidLoad() {
            super.viewDidLoad()
            self.detectionDelegate = self
    }

}
```

you can increase the detection level or language correction by using the code below

```swift
    self.fastRecognition = true
    self.autoCorrection = true
```

by adding the `detectionDelegate` you will have two functions which one of them is optional 

```swift 
    // required function 
    func scanResults(_ result: ScanResults) {
       
    }

    // optional function 
    func scanFailed() {
    
    }
```
this function will getting called when the image processed and the result contains `detectedTexts`, `scannedImage` and `error` which all of these are optional and can be `nil` based on the results 

## Face Detection 

The face Detection will detect that there is only one person in the photo so if there is more than one person or nobody in the photo or for any reasons there was an unknown erroe it will show error 

to use this oart for face recognition you need to create a view controller and change the class to `FaceDetectionViewController` , also you can pass the delegate to use the function when the texts recognized from the image 

```swift 

class FaceDetectionVC: FaceDetectionViewController , faceDetectionProtocol {

    override func viewDidLoad() {
            super.viewDidLoad()
            self.faceDetectionDelegate = self
    }

}
```

by adding the `faceDetectionDelegate` you will have two functions which one of them is optional 

```swift 
    // required function 
    func faceDetected(_ error : faceErrors?,_ image : UIImage?) {
       
    }

    // optional function 
    func scanFailed() {
    
    }
```
this function will getting called when the image processed and the result contains `faceErrors` and `image` which both of these are optional and can be `nil` based on the results 

if there was no error the `error` will be `nil` otherwise the error can be `noFace`,`moreThanOneFace` or `noCGImage` also if you want to show message to the alert for any of these you can use a function which name is `errorMessage()` which can be use for the error message or you can do it by your self and using your own error message 

```swift
func faceDetected(_ error : faceErrors?,_ image : UIImage?) {
    guard let error = error else {return}
    print(message: error.errorMessage())
}
```


