# CPN SysUpDn & LogOnOff Script
## 📌 專案簡介
此專案提供一組 Windows 批次檔，在 **系統啟動 / 關機 / 使用者登入 / 登出** 時自動執行，備份與還原**RAMDISK**中的設定檔。  

---

## 📂 專案結構
```
CPN-SysUpDn-LogOnOff/
├── README.md              # 專案說明文件
├── CPN_SysUp.bat          # 系統開機批次檔
├── CPN_LogOn.bat          # 使用者登入批次檔
├── CPN_LogOff.bat         # 使用者登出批次檔
├── CPN_SysDn.bat          # 系統關機批次檔
└── LICENSE                # 授權條款 (MIT)
```

---

## 🔑重點說明
+ 🖥️ 系統啟動 [`CPN_SysUp.bat`](/CPN_SysUp.bat)
	- 啟動時檢查並等待 U:\ RamDisk 是否掛載成功（最多 60 秒）。
	- 建立 !LOCK 避免後續檔案執行錯誤。
	- 若失敗則記錄錯誤並建立 !RD-Error。
	- 成功後建立 U:\TEMP 目錄。
	
+ 👤 使用者登入 [`CPN_LogOn.bat`](CPN_LogOn.bat)
	- 登入時檢查 RamDisk 狀態，若缺失則終止。
	- 使用 whoami /user 取得 SID，生成對應的 Profile 名稱。
	- 依序還原使用者設定檔，透過 7z x 解壓縮 .zip 檔到 RamDisk。
	
+ 👤 使用者登出 [`CPN_LogOff.bat`](CPN_LogOff.bat)
	- 登出時檢查 RamDisk，若存在則進行備份。
	- 定義各設定檔需要備份的檔案與目錄（排除 .old）。
	- 執行 taskkill 關閉應用，避免檔案被鎖定。
	- 使用 7z a 壓縮成 .zip，並保留 .old.zip 作為前一版本。
	
+ 🖥️ 系統關機 [`CPN_SysDn.bat`](CPN_SysDn.bat)
	- 系統關機流程，目前是空殼，僅記錄開始與結束。
	- 可依照需求擴充腳本。
	
---

## 📝程式碼
### [CPN_SysUp.bat](/CPN_SysUp.bat)
### [CPN_SysDn.bat](CPN_SysDn.bat)
### [CPN_LogOn.bat](CPN_LogOn.bat)
### [CPN_LogOff.bat](CPN_LogOff.bat)

---

