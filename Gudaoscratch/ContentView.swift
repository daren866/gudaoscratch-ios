import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedFile: URL?
    @State private var project: SB3Project?
    @State private var parsedInfo = ""
    @State private var showingPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Scratch解析器")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        showingPicker = true
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
        .sheet(isPresented: $showingPicker) {
            DocumentPicker(onPick: { url in
                self.selectedFile = url
                parseSB3File(url: url)
            })
        }
    }
    
    private func parseSB3File(url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        
        DispatchQueue.global(qos: .background).async {
            var parseResult: String?
            
            if let project = SB3Parser.parse(from: url) {
                self.project = project
                parseResult = formatProjectInfo(project: project)
            } else {
                parseResult = "无法解析该sb3文件"
            }
            
            if accessed {
                url.stopAccessingSecurityScopedResource()
            }
            
            DispatchQueue.main.async {
                if let result = parseResult {
                    self.parsedInfo = result
                }
            }
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

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let sb3Type = UTType(importedAs: "com.scratch.sb3")
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [sb3Type])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        picker.shouldShowFileExtensions = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void
        
        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                DispatchQueue.main.async {
                    onPick(url)
                }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // 用户取消选择，不需要额外处理
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
