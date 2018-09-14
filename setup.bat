@ECHO OFF

SET num_jobs=5
SET test_folder=%num_jobs%_jobs
SET binaries=rjm_batch_submit.exe,rjm_batch_wait.exe,rjm_batch_clean.exe

FOR %%b IN (%binaries%) DO (
  IF NOT EXIST bin\%%b (
    ECHO File bin\%%b doesn't exist.
    ECHO Please copy the RJM binaries into bin before calling setup.sh.
    ECHO Exiting.
    EXIT /B 1
  )
)

IF EXIST %test_folder% (
  RMDIR /S /Q %test_folder%
)

ECHO Creating test folder %test_folder%
MKDIR %test_folder%
SET dirs_file=%test_folder%\localdirs.txt

FOR /l %%i in (1,1,%num_jobs%) DO (
  MKDIR %test_folder%\job%%i
  COPY data\job_folders\matrix_in.txt %test_folder%\job%%i > NUL
  COPY data\job_folders\rjm_downloads.txt %test_folder%\job%%i > NUL
  COPY data\job_folders\rjm_uploads.txt %test_folder%\job%%i > NUL
  util\windows\fart.exe -q %test_folder%\job%%i\rjm_uploads.txt __PATHSEP__ \
  ECHO job%%i >> %dirs_file%
)

FOR %%b IN (%binaries%) DO (
  COPY bin\%%b %test_folder% > NUL
)

COPY data\script.sh %test_folder% > NUL
COPY data\transpose.m %test_folder% > NUL

SET runfile=%test_folder%\run.bat
ECHO SET loglevel=debug >  %runfile%
ECHO rjm_batch_submit.exe -c "bash script.sh" -m 1G -j serial -w 00:01:00 -f localdirs.txt -ll %%loglevel%% >> %runfile%
ECHO rjm_batch_wait.exe -f localdirs.txt -z 5 -ll %%loglevel%% >> %runfile%
ECHO rjm_batch_clean.exe -f localdirs.txt -ll %%loglevel%% >> %runfile%

EXIT /B 0
