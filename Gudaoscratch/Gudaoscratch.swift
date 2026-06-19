import SwiftUI

@main
struct GudaoscratchApp: App {
    var body: some Scene {
        WindowGroup {
            MainViewController().view
        }
    }
}

class MainViewController: UIViewController {
    var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Scratch解析器"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let button = UIButton(type: .system)
        button.setTitle("选择sb3文件", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(selectFile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        resultLabel = UILabel()
        resultLabel.numberOfLines = 0
        resultLabel.font = .systemFont(ofSize: 16)
        resultLabel.lineBreakMode = .byWordWrapping
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 44),
            
            resultLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func selectFile() {
        let documentTypes = ["com.scratch.sb3", "public.zip", "public.data"]
        let picker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        picker.allowsMultipleSelection = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func parseSB3File(url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        
        do {
            let data = try Data(contentsOf: url)
            if accessed {
                url.stopAccessingSecurityScopedResource()
            }
            
            if let project = SB3Parser.parse(from: data) {
                resultLabel.text = formatProjectInfo(project: project)
            } else {
                resultLabel.text = "无法解析该sb3文件"
            }
        } catch {
            if accessed {
                url.stopAccessingSecurityScopedResource()
            }
            resultLabel.text = "读取文件失败: \(error.localizedDescription)"
        }
    }
    
    func formatProjectInfo(project: SB3Project) -> String {
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

extension MainViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        dismiss(animated: true) {
            if let url = urls.first {
                self.parseSB3File(url: url)
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true)
    }
}

extension MainViewController {
    var view: UIViewControllerRepresentable {
        MainViewControllerRep(viewController: self)
    }
}

struct MainViewControllerRep: UIViewControllerRepresentable {
    let viewController: MainViewController
    
    func makeUIViewController(context: Context) -> MainViewController {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {}
}