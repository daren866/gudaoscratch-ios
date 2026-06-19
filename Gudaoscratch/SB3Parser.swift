import Foundation
import Compression

struct SB3Project {
    var targets: [SB3Target]
    var monitors: [SB3Monitor]
    var extensions: [String]
    var meta: SB3Meta
}

struct SB3Target {
    var isStage: Bool
    var name: String
    var variables: [String: [Any]]
    var lists: [String: [Any]]
    var broadcasts: [String: String]
    var blocks: [String: Any]
    var costumes: [SB3Costume]
    var sounds: [SB3Sound]
    var currentCostume: Int
    var layerOrder: Int
    var volume: Int
    var visible: Bool?
    var x: Double?
    var y: Double?
    var size: Int?
    var direction: Double?
    var draggable: Bool?
    var rotationStyle: String?
    var tempo: Int?
    var videoTransparency: Int?
    var videoState: String?
    var textToSpeechLanguage: String?
}

struct SB3Costume {
    var name: String
    var bitmapResolution: Int
    var dataFormat: String
    var assetId: String
    var md5ext: String
    var rotationCenterX: Double
    var rotationCenterY: Double
}

struct SB3Sound {
    var name: String
    var assetId: String
    var dataFormat: String
    var format: String
    var rate: Int
    var sampleCount: Int
    var md5ext: String
}

struct SB3Monitor {
    var id: String
    var mode: String
    var opcode: String
    var params: [String: Any]
    var spriteName: String?
    var value: Any
    var width: Int
    var height: Int
    var x: Int
    var y: Int
    var visible: Bool
    var sliderMin: Int?
    var sliderMax: Int?
    var isDiscrete: Bool?
}

struct SB3Meta {
    var semver: String
    var vm: String
    var agent: String
    var origin: String?
}

struct SB3Block {
    var opcode: String
    var next: String?
    var parent: String?
    var inputs: [String: [[Any]]]?
    var fields: [String: [Any]]?
    var shadow: Bool
    var topLevel: Bool
    var x: Double?
    var y: Double?
    var mutation: [String: Any]?
}

class SB3Parser {
    
    static func parse(from url: URL) -> SB3Project? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return parse(from: data)
    }
    
    static func parse(from data: Data) -> SB3Project? {
        guard let jsonData = ZipHelper.extractFile(named: "project.json", from: data) else {
            return nil
        }
        
        return parseProjectJSON(jsonData: jsonData)
    }
    
    static func parseProjectJSON(jsonData: Data) -> SB3Project? {
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            return nil
        }
        
        let targets = parseTargets(from: json["targets"] as? [[String: Any]] ?? [])
        let monitors = parseMonitors(from: json["monitors"] as? [[String: Any]] ?? [])
        let extensions = json["extensions"] as? [String] ?? []
        let meta = parseMeta(from: json["meta"] as? [String: Any] ?? [:])
        
        return SB3Project(
            targets: targets,
            monitors: monitors,
            extensions: extensions,
            meta: meta
        )
    }
    
    static func parseTargets(from array: [[String: Any]]) -> [SB3Target] {
        var targets: [SB3Target] = []
        
        for item in array {
            let isStage = item["isStage"] as? Bool ?? false
            let name = item["name"] as? String ?? ""
            let variables = item["variables"] as? [String: [Any]] ?? [:]
            let lists = item["lists"] as? [String: [Any]] ?? [:]
            let broadcasts = item["broadcasts"] as? [String: String] ?? [:]
            let blocks = item["blocks"] as? [String: Any] ?? [:]
            
            let costumes = parseCostumes(from: item["costumes"] as? [[String: Any]] ?? [])
            let sounds = parseSounds(from: item["sounds"] as? [[String: Any]] ?? [])
            
            let currentCostume = item["currentCostume"] as? Int ?? 0
            let layerOrder = item["layerOrder"] as? Int ?? 0
            let volume = item["volume"] as? Int ?? 100
            
            let visible = item["visible"] as? Bool
            let x = item["x"] as? Double
            let y = item["y"] as? Double
            let size = item["size"] as? Int
            let direction = item["direction"] as? Double
            let draggable = item["draggable"] as? Bool
            let rotationStyle = item["rotationStyle"] as? String
            
            let tempo = item["tempo"] as? Int
            let videoTransparency = item["videoTransparency"] as? Int
            let videoState = item["videoState"] as? String
            let textToSpeechLanguage = item["textToSpeechLanguage"] as? String
            
            targets.append(SB3Target(
                isStage: isStage,
                name: name,
                variables: variables,
                lists: lists,
                broadcasts: broadcasts,
                blocks: blocks,
                costumes: costumes,
                sounds: sounds,
                currentCostume: currentCostume,
                layerOrder: layerOrder,
                volume: volume,
                visible: visible,
                x: x,
                y: y,
                size: size,
                direction: direction,
                draggable: draggable,
                rotationStyle: rotationStyle,
                tempo: tempo,
                videoTransparency: videoTransparency,
                videoState: videoState,
                textToSpeechLanguage: textToSpeechLanguage
            ))
        }
        
        return targets
    }
    
    static func parseCostumes(from array: [[String: Any]]) -> [SB3Costume] {
        var costumes: [SB3Costume] = []
        
        for item in array {
            let name = item["name"] as? String ?? ""
            let bitmapResolution = item["bitmapResolution"] as? Int ?? 1
            let dataFormat = item["dataFormat"] as? String ?? ""
            let assetId = item["assetId"] as? String ?? ""
            let md5ext = item["md5ext"] as? String ?? ""
            let rotationCenterX = item["rotationCenterX"] as? Double ?? 0
            let rotationCenterY = item["rotationCenterY"] as? Double ?? 0
            
            costumes.append(SB3Costume(
                name: name,
                bitmapResolution: bitmapResolution,
                dataFormat: dataFormat,
                assetId: assetId,
                md5ext: md5ext,
                rotationCenterX: rotationCenterX,
                rotationCenterY: rotationCenterY
            ))
        }
        
        return costumes
    }
    
    static func parseSounds(from array: [[String: Any]]) -> [SB3Sound] {
        var sounds: [SB3Sound] = []
        
        for item in array {
            let name = item["name"] as? String ?? ""
            let assetId = item["assetId"] as? String ?? ""
            let dataFormat = item["dataFormat"] as? String ?? ""
            let format = item["format"] as? String ?? ""
            let rate = item["rate"] as? Int ?? 0
            let sampleCount = item["sampleCount"] as? Int ?? 0
            let md5ext = item["md5ext"] as? String ?? ""
            
            sounds.append(SB3Sound(
                name: name,
                assetId: assetId,
                dataFormat: dataFormat,
                format: format,
                rate: rate,
                sampleCount: sampleCount,
                md5ext: md5ext
            ))
        }
        
        return sounds
    }
    
    static func parseMonitors(from array: [[String: Any]]) -> [SB3Monitor] {
        var monitors: [SB3Monitor] = []
        
        for item in array {
            let id = item["id"] as? String ?? ""
            let mode = item["mode"] as? String ?? ""
            let opcode = item["opcode"] as? String ?? ""
            let params = item["params"] as? [String: Any] ?? [:]
            let spriteName = item["spriteName"] as? String
            let value = item["value"] ?? 0
            let width = item["width"] as? Int ?? 0
            let height = item["height"] as? Int ?? 0
            let x = item["x"] as? Int ?? 0
            let y = item["y"] as? Int ?? 0
            let visible = item["visible"] as? Bool ?? true
            let sliderMin = item["sliderMin"] as? Int
            let sliderMax = item["sliderMax"] as? Int
            let isDiscrete = item["isDiscrete"] as? Bool
            
            monitors.append(SB3Monitor(
                id: id,
                mode: mode,
                opcode: opcode,
                params: params,
                spriteName: spriteName,
                value: value,
                width: width,
                height: height,
                x: x,
                y: y,
                visible: visible,
                sliderMin: sliderMin,
                sliderMax: sliderMax,
                isDiscrete: isDiscrete
            ))
        }
        
        return monitors
    }
    
    static func parseMeta(from dict: [String: Any]) -> SB3Meta {
        let semver = dict["semver"] as? String ?? ""
        let vm = dict["vm"] as? String ?? ""
        let agent = dict["agent"] as? String ?? ""
        let origin = dict["origin"] as? String
        
        return SB3Meta(
            semver: semver,
            vm: vm,
            agent: agent,
            origin: origin
        )
    }
    
    static func parseBlock(from dict: [String: Any], id: String) -> SB3Block {
        let opcode = dict["opcode"] as? String ?? ""
        let next = dict["next"] as? String
        let parent = dict["parent"] as? String
        let inputs = dict["inputs"] as? [String: [[Any]]]
        let fields = dict["fields"] as? [String: [Any]]
        let shadow = dict["shadow"] as? Bool ?? false
        let topLevel = dict["topLevel"] as? Bool ?? false
        let x = dict["x"] as? Double
        let y = dict["y"] as? Double
        let mutation = dict["mutation"] as? [String: Any]
        
        return SB3Block(
            opcode: opcode,
            next: next,
            parent: parent,
            inputs: inputs,
            fields: fields,
            shadow: shadow,
            topLevel: topLevel,
            x: x,
            y: y,
            mutation: mutation
        )
    }
    
    static func getTopLevelBlocks(from blocks: [String: Any]) -> [SB3Block] {
        var topLevelBlocks: [SB3Block] = []
        
        for (id, value) in blocks {
            if let dict = value as? [String: Any] {
                let block = parseBlock(from: dict, id: id)
                if block.topLevel && !block.shadow {
                    topLevelBlocks.append(block)
                }
            }
        }
        
        return topLevelBlocks.sorted { ($0.y ?? 0) < ($1.y ?? 0) }
    }
    
    static func getBlockChain(startBlock: SB3Block, allBlocks: [String: Any]) -> [SB3Block] {
        var chain: [SB3Block] = [startBlock]
        var currentId = startBlock.next
        
        while let id = currentId, let value = allBlocks[id], let dict = value as? [String: Any] {
            let block = parseBlock(from: dict, id: id)
            chain.append(block)
            currentId = block.next
        }
        
        return chain
    }
}

class ZipHelper {
    
    static func extractFile(named fileName: String, from zipData: Data) -> Data? {
        var index = 0
        
        while index < zipData.count {
            guard let localHeader = LocalFileHeader(data: zipData, index: &index) else {
                break
            }
            
            if localHeader.fileName == fileName {
                let compressedData = zipData.subdata(in: index..<index + localHeader.compressedSize)
                return decompress(data: compressedData, method: localHeader.compressionMethod)
            }
            
            index += localHeader.compressedSize
            
            if localHeader.dataDescriptorExists {
                index += 16
            }
        }
        
        return nil
    }
    
    private static func decompress(data: Data, method: UInt16) -> Data? {
        guard method == 0 || method == 8 else {
            return nil
        }
        
        if method == 0 {
            return data
        }
        
        let algorithm = compression_algorithm(rawValue: COMPRESSION_ZLIB)
        let bufferSize = data.count * 2
        
        return data.withUnsafeBytes { sourceBuffer in
            var destination = [UInt8](repeating: 0, count: bufferSize)
            
            return destination.withUnsafeMutableBytes { destinationBuffer in
                let status = compression_decode_buffer(
                    destinationBuffer.baseAddress!,
                    destinationBuffer.count,
                    sourceBuffer.baseAddress!,
                    sourceBuffer.count,
                    nil,
                    algorithm
                )
                
                guard status != 0 else {
                    return nil
                }
                
                return Data(destination[0..<status])
            }
        }
    }
}

struct LocalFileHeader {
    let fileName: String
    let compressedSize: Int
    let compressionMethod: UInt16
    let dataDescriptorExists: Bool
    
    init?(data: Data, index: inout Int) {
        guard index + 30 <= data.count else {
            return nil
        }
        
        let signature = data[index..<index+4]
        guard signature == Data([0x50, 0x4B, 0x03, 0x04]) else {
            return nil
        }
        index += 4
        
        let version = data[index..<index+2].uint16
        index += 2
        
        let flags = data[index..<index+2].uint16
        index += 2
        
        compressionMethod = data[index..<index+2].uint16
        index += 2
        
        index += 4
        index += 4
        
        compressedSize = Int(data[index..<index+4].uint32)
        index += 4
        
        index += 4
        
        let fileNameLength = Int(data[index..<index+2].uint16)
        index += 2
        
        let extraFieldLength = Int(data[index..<index+2].uint16)
        index += 2
        
        guard index + fileNameLength <= data.count else {
            return nil
        }
        
        fileName = String(data: data[index..<index+fileNameLength], encoding: .utf8) ?? ""
        index += fileNameLength
        index += extraFieldLength
        
        dataDescriptorExists = (flags & 0x08) != 0
    }
}

extension Data {
    var uint16: UInt16 {
        return self.withUnsafeBytes { $0.load(as: UInt16.self) }.bigEndian
    }
    
    var uint32: UInt32 {
        return self.withUnsafeBytes { $0.load(as: UInt32.self) }.bigEndian
    }
}
