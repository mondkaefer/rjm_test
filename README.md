# rjm_test
Set up and run test jobs under Windows/Mac/Linux to test the rjm tools

## Prerequisites
Copy RJM binaries into data/bin before calling setup.

## Run a test batch
On Windows, call setup.bat, on Linux call setup.sh. This will create a directory 5_jobs. To run the test, change into 5_jobs and execute run.sh on Linux/Mac, or run.bat on Windows. This will then submit 5 jobs to the cluster, wait for their completion, download the results, and clean up the job directories on the cluster at the end.

If you want to change the number of jobs in a test, change the value of the variable num_jobs in the setup.bat/setup.sh.
