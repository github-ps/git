@echo off
echo ------------------------------------------------
echo ����1����������������HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SvcHost ��netsvcsֵ�е�һ���ַ���,���򱨴�����1083�����ó��ڸÿ�ִ�г��������е����������ִ�и÷���
echo ����2������DLL���ļ��������ڵ�ǰĿ¼��
echo ����3��x86��32λ���� ���� x64��64λ���� ��ʡ�������Ĭ��Ϊx86�������Ŀ���ѡ����ȷ��ֵ�����������С�
echo ------------------------------------------------
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SvcHost" /v netsvcs
echo �������������CTRL+C����ִ��   
pause

if [%1] == [] ( 
echo ������������������
goto end
)

if [%2] == [] ( 
echo ������������������
goto end
)

reg query hklm\system\currentcontrolset\services\%1 >nul
if %errorlevel% == 0 (
echo �÷����Ѿ����ڣ������������
goto end
)

sc create "%1" binpath= "%SystemRoot%\system32\svchost.exe -k netsvcs" type= share start= auto DisplayName= "Remote Desktop Clients" 

if "%3" == "x64" (
 reg add    hklm\system\currentcontrolset\services\%1 /v WOW64 /t REG_DWORD /d 1
 copy .\%2 %SystemRoot%\sysWOW64\%2
) else (
 copy .\%2 %SystemRoot%\system32\%2
)

reg add    hklm\system\currentcontrolset\services\%1\parameters /v servicedll /t REG_EXPAND_SZ /d %SystemRoot%\system32\%2

reg add    hklm\system\currentcontrolset\services\%1 /v Description /t REG_SZ /d "Microsoft Remote Desktop Clients"
sc start "%1"

:end
