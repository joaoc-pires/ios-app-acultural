//
//  ExtensionCGImage.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 06/05/2023.
//

import Foundation
import Vision

public extension CGImage {

    func faceCrop(margin: CGFloat = 200, completion: @escaping (FaceCropResult) -> Void) {
        let req = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = request.results, !results.isEmpty else {
                completion(.notFound)
                return
            }
            
            var faces: [VNFaceObservation] = []
            for result in results {
                guard let face = result as? VNFaceObservation else { continue }
                faces.append(face)
            }
            
            // 1
            let croppingRect = self.getCroppingRect(for: faces, margin: margin)
                                                 
            // 10
            let faceImage = self.cropping(to: croppingRect)
            
            // 11
            guard let result = faceImage else {
                completion(.notFound)
                return
            }
            
            // 12
            completion(.success(result))
        }
        #if targetEnvironment(simulator)
        req.usesCPUOnly = true
        #endif
        do {
            try VNImageRequestHandler(cgImage: self, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
        
    private func getCroppingRect(for faces: [VNFaceObservation], margin: CGFloat) -> CGRect {
        
        // 2
        var totalX = CGFloat(0)
        var totalY = CGFloat(0)
        var totalW = CGFloat(0)
        var totalH = CGFloat(0)
        
        // 3
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        let numFaces = CGFloat(faces.count)
        
        // 4
        for face in faces {
            
            // 5
            let w = face.boundingBox.width * CGFloat(width)
            let h = face.boundingBox.height * CGFloat(height)
            let x = face.boundingBox.origin.x * CGFloat(width)
            
            // 6
            let y = (1 - face.boundingBox.origin.y) * CGFloat(height) - h
            
            totalX += x
            totalY += y
            totalW += w
            totalH += h
            minX = .minimum(minX, x)
            minY = .minimum(minY, y)
        }
        
        // 7
        let avgX = totalX / numFaces
        let avgY = totalY / numFaces
        let avgW = totalW / numFaces
        let avgH = totalH / numFaces
        
        // 8
        let offset = margin + avgX - minX
        
        // 9
        return CGRect(x: avgX - offset, y: avgY - offset, width: avgW + (offset * 2), height: avgH + (offset * 2))
    }
}

public enum FaceCropResult {
    case success(CGImage)
    case notFound
    case failure(Error)
}
