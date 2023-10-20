# Diana Farm Game

> !!! 注意
> 
> 注意升级项目的顺序：将自己开发所在的分支/提交向 4.x 升级时，**先拉取 test 远端以升级项目**，**然后再升级本地的 Godot 引擎版本打开项目**。
> 
> **切勿自己给分支做整体升级**，这样极有可能和主分支冲突。

## 运行环境

Godot v4.1.2.stable.official [399c9dc39]

## 格式/命名/文本约定

- 遵守 GDScript 的官方格式约定：[GDScript 风格指南 &mdash; Godot Engine (4.2) 简体中文文档](https://docs.godotengine.org/zh_CN/4.x/tutorials/scripting/gdscript/gdscript_styleguide.html)（尽量）

- 场景和资源尽量使用文本格式存储（即 `.tscn` 后缀和 `.tres` 格式），主题使用 `.theme`

- GDScript 内的命名按照官方约定，文件名也是按照官方建议全部使用 `snake_case`

- 注释或说明文档句尾不添加句号

- 尽量使用语言相符标点（英文用半角，中文用全角）

- 中英文间尽量用一个空格分隔

- 代码中的文本（注释）尽量使用手动换行而非自动换行

- GDScript 中的缩进使用 Tab（非空格）

- 脚本中的路径（打包场景的路径）尽量使用相对路径，需要返回上一级则使用绝对路径

- 对于脚本类中暴露在外的接口部分，尽量指定类型

- 尽量填写接口的注释（4.x 版本现已经支持自动生成的编辑器内嵌文档）

- 升级到 4.x 后，`project.godot` 现已不包含脚本类的注册，所以在提交时不用剔除

## 目录约定

已知的专用目录如下：

```
res://
 ├─ addons 所有编辑器插件
 ├─ dbs 所有的数据库资源文件
 ├─ types 所有的脚本类
 │   ├─ ui 用于UI的组件放于此文件夹内（不是所有的UI相关文件都在这里）
 │   ├─ some_class 如果类型有多个文件（资源/场景文件），则建一个同名的文件夹
 │   │   ├─ some_class.gd 主类脚本
 │   │   ├─ main.tscn 主场景（如果存在）
 │   │   ├─ main.gd 主场景脚本（如果存在）
 │   │   └─ ...<any-file>
 │   ├─ another_class.gd 如果类型只有单个文件，则直接一个脚本
 │   └─ ...<any-file>
 └─ ...<any-file>
```
