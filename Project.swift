import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("15.0")

let project = Project(
    name: "Gudaoscratch",
    organizationName: "Example",
    packages: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "<YOUR_DEVELOPMENT_TEAM_ID>",
            "CODE_SIGN_STYLE": "Automatic",
            "CODE_SIGN_IDENTITY": "Apple Development",
            "TARGETED_DEVICE_FAMILY": "1",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "Gudaoscratch",
            destinations: .iOS,
            product: .app,
            bundleId: "com.gudao.scratch",
            deploymentTargets: deploymentTargets,
            infoPlist: .file(path: "Gudaoscratch/Info.plist"),
            sources: ["Gudaoscratch/**/*.swift"],
            resources: ["Gudaoscratch/Assets.xcassets"],
            dependencies: [
                .external(name: "ZIPFoundation")
            ]
        )
    ]
)
