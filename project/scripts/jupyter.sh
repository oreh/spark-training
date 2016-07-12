#!/usr/bin/env sh
export PYSPARK_DRIVER_PYTHON=ipython
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --port=8888 --notebook-dir=/vagrant/notebooks"
/usr/local/spark/bin/pyspark --master=local

# or use a single line command
# PYSPARK_DRIVER_PYTHON=ipython PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --port=8888" ./bin/pyspark
