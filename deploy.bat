@echo off
echo ========================================
echo    AUTO DEPLOY JSP SERVLET PROJECT
echo ========================================

echo [1/6] Dung Tomcat...
cd /d d:\Tomcat\bin
call shutdown.bat
timeout /t 3

echo [2/6] Xoa ung dung cu...
cd /d d:\Tomcat\webapps
if exist jsp-servlet-DatVeXe (
    rd /s /q jsp-servlet-DatVeXe
    echo - Da xoa thu muc jsp-servlet-DatVeXe
)
if exist jsp-servlet-DatVeXe.war (
    del jsp-servlet-DatVeXe.war
    echo - Da xoa file jsp-servlet-DatVeXe.war
)

echo [3/6] Build project...
cd /d "d:\CODE\DUT\KY 4\CongNgheWeb\JSP\DatVeXe"
call mvn clean package
if %errorlevel% neq 0 (
    echo ERROR: Maven build failed!
    pause
    exit /b 1
)

echo [4/6] Copy file WAR moi...
if exist target\jsp-servlet-DatVeXe.war (
    copy target\jsp-servlet-DatVeXe.war d:\Tomcat\webapps\
    echo - Da copy file WAR thanh cong
) else (
    echo ERROR: File WAR khong ton tai!
    pause
    exit /b 1
)

echo [5/6] Khoi dong Tomcat...
cd /d d:\Tomcat\bin
call startup.bat

echo [6/6] Hoan thanh!
echo Ung dung se co san trong vai giay tai:
echo http://localhost:8080/jsp-servlet-DatVeXe/

@REM cd ve lai thu muc cua project
cd /d "d:\CODE\DUT\KY 4\CongNgheWeb\JSP\DatVeXe"
timeout /t 5