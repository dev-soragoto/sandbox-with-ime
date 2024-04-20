# sandbox-with-ime

使用 [Windows sandbox](https://learn.microsoft.com/zh-cn/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview)  创建包含输入法的沙箱

一些需要在沙箱中运行的应用可能也需要有输入法支持，本着最少引入依赖的原则，可以创建一个带有微软五笔或者拼音输入法的沙箱

## 使用

1. 参考[文档](https://learn.microsoft.com/zh-cn/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview)配置sandbox

2. cloen 项目到本地
    ```sh
    git clone https://github.com/dev-soragoto/sandbox-with-ime.git
    ```
3. 按需修改配置，可参考[文档](https://learn.microsoft.com/zh-cn/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-configure-using-wsb-file)

4. 运行sandbox_with_ime.wsb


## 配置

默认初始化微软五笔，并挂载用户自定义词库，当前配置为四码上屏，纯五笔，候选词数量3

默认共享了download文件夹方便在sandbox中下载文件到宿主机


### 输入法选择

- 需要使用微软五笔不需要更改文件

- 需要使用微软拼音可以删除`scripts\init.ps1`中以下内容

    ```powershell
    # 删除默认输入法
    $UserLanguageList[0].InputMethodTips.Clear()

    # 添加微软五笔
    $UserLanguageList[0].InputMethodTips.Add("0804:{6A498709-E00B-4C45-A018-8F9E4081AE40}{82590C13-F4DD-44F4-BA1D-8667246FDF8E}")
    ```

### 用户词库
 
- 需要挂载用户次库可以复制

    `C:\Windows\InputMethod\CHS`到`.\ime\chs_sys`

    `%appdata%\Microsoft\InputMethod\Chs\`到`.\ime\Chs_User`

- 不需要挂载用户词库可以删除`tencent.wsb`中以下内容

    ```xml
    <!-- 输入法词库 -->
    <MappedFolder>
        <HostFolder>\your\path\tencent-sandbox\ime\chs_sys</HostFolder>
        <SandboxFolder>C:\Windows\InputMethod\CHS</SandboxFolder>
        <ReadOnly>false</ReadOnly>
    </MappedFolder>
    <MappedFolder>
        <HostFolder>\your\path\tencent-sandbox\ime\Chs_user</HostFolder>
        <SandboxFolder>C:\Users\WDAGUtilityAccount\AppData\Roaming\Microsoft\InputMethod\Chs</SandboxFolder>
        <ReadOnly>false</ReadOnly>
    </MappedFolder>
    ```

### 输入法配置

微软输入法的配置存储在注册表中,位置为

```
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputMethod\CandidateWindow\CHS\]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputMethod\Settings\CHS]
```

如果需要自定义配置，可以在sandbox中更改好输入法配置，`win+R`输入`regedit`后找到上述位置，导出注册表项

把导出的reg文件使用文本编辑器合并，并复制到`scripts\ime_conf.reg`

### 其他环境配置

阅读`scripts\init.ps1`