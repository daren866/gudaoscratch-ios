import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedFile: URL?
    @State private var project: SB3Project?
    @State private var showFilePicker = false
    @State private var parsedInfo = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Scratch解析器")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        showFilePicker = true
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
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [UTType(filenameExtension: "sb3")!],
                allowsMultipleSelection: false
            ) { result in
                do {
                    let urls = try result.get()
                    if let url = urls.first {
                        selectedFile = url
                        parseSB3File(url: url)
                    }
                } catch {
                    print("文件选择错误: \(error)")
                }
            }
        }
    }
    
    private func parseSB3File(url: URL) {
        // 获取安全作用域资源访问权限
        let accessed = url.startAccessingSecurityScopedResource()
        
        DispatchQueue.global(qos: .background).async {
            var parseResult: String?
            
            if let project = SB3Parser.parse(from: url) {
                self.project = project
                parseResult = formatProjectInfo(project: project)
            } else {
                parseResult = "无法解析该sb3文件"
            }
            
            // 释放安全作用域资源访问权限
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
