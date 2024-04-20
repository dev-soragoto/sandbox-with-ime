# 添加中文
$UserLanguageList = New-WinUserLanguageList -Language "zh-Hans-CN"

# 删除默认输入法
$UserLanguageList[0].InputMethodTips.Clear()

# 添加微软五笔
$UserLanguageList[0].InputMethodTips.Add("0804:{6A498709-E00B-4C45-A018-8F9E4081AE40}{82590C13-F4DD-44F4-BA1D-8667246FDF8E}")

$LanguageList = Get-WinUserLanguageList

$LanguageList.Add($UserLanguageList[0])

# 写入语言配置
Set-WinUserLanguageList $LanguageList -Force

# 导入输入法配置
reg.exe import C:\scripts\ime_conf.reg

# 隐藏桌面回收站图标
New-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -PropertyType Dword -Value 1

# 自动隐藏任务栏
$p = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$v = (Get-ItemProperty -Path $p).Settings
$v[8] = 3
Set-ItemProperty -Path $p -Name Settings -Value $v

# 设置桌面纯黑
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name WallPaper -Value ""

# 重启explorer
Stop-Process -f -ProcessName explorer