import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedFile: URL?
    @State private var project: SB3Project?
    @State private var parsedInfo = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Scratch解析器")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        selectFile()
                    }) {
                        Text("选择sb3文件")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(22)
                            .font(.headline)
                    }
                    .buttonStyle(.plain)
                    
                    if selectedFile != nil {
                        Text("您已选择sb3文件")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if !parsedInfo.isEmpty {
                        Text(parsedInfo)
                            .font(.body)
                            .lineSpacing(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Scratch解析器")
        }
    }
    
    private func selectFile() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false
        picker.delegate = DocumentPickerDelegate(onPick: { url in
            handleFileSelection(url: url)
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(picker, animated: true)
        }
    }
    
    private func handleFileSelection(url: URL) {
        selectedFile = url
        
        let accessed = url.startAccessingSecurityScopedResource()
        
        do {
            let data = try Data(contentsOf: url)
            if accessed {
                url.stopAccessingSecurityScopedResource()
            }
            
            if let project = SB3Parser.parse(from: data) {
                self.project = project
                parsedInfo = formatProjectInfo(project: project)
            } else {
                parsedInfo = "无法解析该sb3文件"
            }
        } catch {
            if accessed {
                url.stopAccessingSecurityScopedResource()
            }
            parsedInfo = "读取文件失败: \(error.localizedDescription)"
        }
    }
    
    private func formatProjectInfo(project: SB3Project) -> String {
        var info = "作品信息：\n"
        
        let sprites = project.targets.filter { !$0.isStage }
        
        for (index, sprite) in sprites.enumerated() {
            info += "角色\(index + 1)：\n"
            
            if let size = sprite.size {
                info += "大小：\(size)\n"
            }
            if let x = sprite.x {
                info += "x：\(Int(x))\n"
            }
            if let y = sprite.y {
                info += "y：\(Int(y))\n"
            }
            if let direction = sprite.direction {
                info += "方向：\(Int(direction))\n"
            }
            
            let topBlocks = SB3Parser.getTopLevelBlocks(from: sprite.blocks)
            
            if !topBlocks.isEmpty {
                info += "block：\n"
                
                for topBlock in topBlocks {
                    let chain = SB3Parser.getBlockChain(startBlock: topBlock, allBlocks: sprite.blocks)
                    let blockNames = BlockMapper.shared.parseBlockChain(blocks: chain)
                    
                    for (i, blockName) in blockNames.enumerated() {
                        let prefix = i == 0 ? "" : "    "
                        info += "\(prefix)\(blockName)\n"
                    }
                }
            }
            
            info += "\n"
        }
        
        if sprites.isEmpty {
            info += "无角色信息\n"
        }
        
        return info
    }
}

class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    let onPick: (URL) -> Void
    
    init(onPick: @escaping (URL) -> Void) {
        self.onPick = onPick
        super.init()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        onPick(url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // 用户取消
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}