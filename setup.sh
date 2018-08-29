#!/bin/bash

num_jobs=5
test_folder="${num_jobs}_jobs"
binaries="rjm_batch_submit rjm_batch_wait rjm_batch_clean"

for binary in ${binaries}; do
  bin="data/bin/${binary}"
  if [ ! -f "${bin}" ]; then
    echo "File ${bin} doesn't exist."
    echo "Please copy the RJM binaries into data/bin before calling setup.sh."
    echo "Exiting."
    exit 1
  fi
done

if [ -d "${test_folder}" ]; then
  rm -r "${test_folder}"
fi

echo "Creating test folder ${test_folder}"
mkdir "${test_folder}"

dirs_file="${test_folder}/localdirs.txt"

for i in $(seq ${num_jobs}); do
  job="job${i}"
  jobdir="${test_folder}/${job}"
  mkdir ${jobdir}
  cp data/job_folders/matrix_in.txt ${jobdir}
  cp data/job_folders/rjm_downloads.txt ${jobdir}
  cp data/job_folders/rjm_uploads.txt ${jobdir}
  sed -i\  's/__PATHSEP__/\//' ${jobdir}/rjm_uploads.txt
  echo "${job}" >> "${dirs_file}"
done

for binary in ${binaries}; do
  bin="data/bin/${binary}"
  cp "${bin}" "${test_folder}"
done

cp data/script.sh "${test_folder}"
cp data/transpose.m "${test_folder}"

runfile="${test_folder}/run.sh"
echo './rjm_batch_submit -c "bash script.sh" -m 1G -j serial -w 00:01:00 -f localdirs.txt' > ${runfile}
echo './rjm_batch_wait -f localdirs.txt -z 5' >> ${runfile}
echo './rjm_batch_clean -f localdirs.txt' >> ${runfile}
chmod u+rwx ${runfile}
