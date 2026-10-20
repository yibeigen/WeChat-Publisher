; ============================================================
;  博萃 · 微信公众号文章出版归档 — Windows 安装包脚本
;  用途：把 dist\WeChat-Publisher 打包成双击安装的 setup.exe
;  重新打包新版本时：只需改下面的 MyAppVersion 一处，然后运行：
;  "C:\Program Files\Inno Setup 7\ISCC.exe" WeChat-Publisher-setup.iss
; ============================================================

#define MyAppName "WeChat-Publisher"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "艺杯羹 (@yibeigen)"
#define MyAppURL "https://github.com/yibeigen/WeChat-Publisher"
#define MyAppExeName "WeChat-Publisher.exe"

[Setup]
; AppId 是本软件的唯一标识（GUID），发布后永远不要改，
; 否则新版本安装时无法识别已安装的旧版本
AppId={{8C15B6A2-4E9D-4F3A-9B7C-1D2E3F4A5B6C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
; 默认安装目录：C:\Users\当前用户\AppData\Local\Programs\WeChat-Publisher
; PrivilegesRequired=lowest 表示不需要管理员权限，安装全程免 UAC 弹窗
PrivilegesRequired=lowest
DefaultDirName={autopf}\{#MyAppName}
; 卸载程序也放在安装目录里
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
; 安装包图标（由官方横幅 Logo 左侧图标裁剪生成）
SetupIconFile=logo.ico
; 输出位置与文件名：dist\WeChat-Publisher-Setup-v1.0.1.exe
OutputDir=dist
OutputBaseFilename=WeChat-Publisher-Setup-v{#MyAppVersion}
; 固实压缩 + LZMA2 最高压缩率，把 300 多个运行时文件压到最小
Compression=lzma2/max
SolidCompression=yes
; exe 的版本信息（右键属性里显示）
VersionInfoVersion={#MyAppVersion}.0
VersionInfoTextVersion={#MyAppVersion}
; 向导标题栏显示「安装程序 - WeChat-Publisher v1.0.1」
WizardStyle=modern
; 关闭「安装完成后是否启动程序」以外的多余确认页，保持向导简短
DisableProgramGroupPage=yes

[Languages]
; 使用 Inno Setup 7 官方自带的简体中文向导界面
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
; 可选任务：是否创建桌面快捷方式（默认勾选）
Name: "desktopicon"; Description: "创建桌面快捷方式(&D)"; GroupDescription: "附加任务："

[Files]
; 把 PyInstaller 打包产物整个复制到安装目录
; Excludes 排除 data：数据目录属于用户运行时数据，安装/升级时绝不能动
; ignoreversion：升级安装时无条件覆盖旧文件（这正是「双击安装即升级」的关键）
Source: "dist\WeChat-Publisher\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "data"

[Icons]
; 开始菜单快捷方式
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
; 桌面快捷方式（可选任务）
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
; 安装完成页提供「立即运行」勾选（默认勾选）
Filename: "{app}\{#MyAppExeName}"; Description: "立即运行 {#MyAppName}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; 卸载前先结束正在运行的主程序，避免文件占用导致卸载残留
Filename: "{cmd}"; Parameters: "/C taskkill /IM {#MyAppExeName} /F"; Flags: runhidden; RunOnceId: "KillApp"

[UninstallDelete]
; 说明：data 目录（文章数据、凭证、CA 证书）故意不在这里列出，
; 卸载时它会保留在安装目录中，用户重装后数据仍在
