@REM ----------------------------------------------------------------------------
@REM Maven Wrapper startup batch script for Windows
@REM ----------------------------------------------------------------------------

@IF "%DEBUG%"=="" @ECHO OFF
@REM Set local scope for the variables with windows NT shell
IF "%OS%"=="Windows_NT" SETLOCAL

SET MAVEN_PROJECTBASEDIR=%~dp0
SET WRAPPER_JAR="%MAVEN_PROJECTBASEDIR%.mvn\wrapper\maven-wrapper.jar"
SET WRAPPER_PROPERTIES="%MAVEN_PROJECTBASEDIR%.mvn\wrapper\maven-wrapper.properties"

@REM Find java.exe
SET JAVA_EXE=java.exe
IF NOT "%JAVA_HOME%"=="" SET JAVA_EXE="%JAVA_HOME%\bin\java.exe"

@REM Determine Maven distribution URL from properties
FOR /F "usebackq tokens=1,2 delims==" %%A IN (%WRAPPER_PROPERTIES%) DO (
    IF "%%A"=="distributionUrl" SET DOWNLOAD_URL=%%B
)

@REM Set Maven home directory
SET MAVEN_HOME=%USERPROFILE%\.m2\wrapper\dists\apache-maven-3.9.6
SET MVN_CMD="%MAVEN_HOME%\bin\mvn.cmd"

@REM Download and extract Maven if not present
IF NOT EXIST %MVN_CMD% (
    ECHO Maven not found. Downloading Maven 3.9.6...
    
    SET MAVEN_ZIP=%TEMP%\apache-maven-3.9.6-bin.zip
    
    @REM Download using PowerShell
    powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%TEMP%\apache-maven-3.9.6-bin.zip' }"
    
    @REM Create target directory
    IF NOT EXIST "%USERPROFILE%\.m2\wrapper\dists" MKDIR "%USERPROFILE%\.m2\wrapper\dists"
    
    @REM Extract using PowerShell
    powershell -Command "& { Expand-Archive -Path '%TEMP%\apache-maven-3.9.6-bin.zip' -DestinationPath '%USERPROFILE%\.m2\wrapper\dists' -Force }"
    
    @REM Clean up
    DEL "%TEMP%\apache-maven-3.9.6-bin.zip" 2>NUL
    
    ECHO Maven 3.9.6 installed successfully.
)

@REM Execute Maven
%MVN_CMD% %*
IF ERRORLEVEL 1 GOTO error
GOTO end

:error
SET ERROR_CODE=1

:end
@ENDLOCAL & SET ERROR_CODE=%ERROR_CODE%
EXIT /B %ERROR_CODE%
