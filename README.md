## FlutterPrograms

基于 [Flutter 热更新思路](https://nuttalk.com)，实现的工具箱应用。

## 仓库说明

### 1. 约定俗称：
App 称为`主应用`
App 内部工具程序，称为`程序`

### 2. 项目仓库：

#### 2.1 主应用相关仓库：

##### 2.1.1 [FlutterPrograms](https://github.com/FlutterPrograms/FlutterPrograms)
`主应用`代码仓库。
##### 2.1.2 [AppSpec](https://github.com/FlutterPrograms/AppSpec)
`主应用`描述文件仓库，实现主应用的版本升级，以及相关描述修改。
##### 2.1.3 [AppAssert](https://github.com/FlutterPrograms/AppAssert)
`主应用`包资源仓库，存放`主应用`升级包。

#### 2.2 程序相关仓库：

##### 2.2.1 [SpecsURL](https://github.com/FlutterPrograms/SpecsURL)
`应用`描述文件资源地址仓库。由持续集成构建工具 `Travis CI` 处理仓库 `resource.txt` 文件中的 `Spec URL` 生成 [Specs](https://github.com/FlutterPrograms/Specs) `应用`描述列表数据。
当需要为主程序添加新的应用，在 [SpecsURL](https://github.com/FlutterPrograms/SpecsURL) 的 `resource.txt` 文件中指定 `Spec` 文件描述地址即可。 `Travis CI` 在仓库提交时，或每`24`小时构建一次，并提交更新 [Specs](https://github.com/FlutterPrograms/Specs) 仓库。

##### 2.2.2 [Specs](https://github.com/FlutterPrograms/Specs)
`应用`描述列表数据仓库。仓库中 `specs.json` 文件即`应用`描述列表数据，由 [SpecsURL](https://github.com/FlutterPrograms/SpecsURL) 自动生成。

##### 2.2.3 [SpecsFile](https://github.com/FlutterPrograms/SpecsFile)
FlutterPrograms 项目自己收集的 `程序` 描述文件。
