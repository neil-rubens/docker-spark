Fork of `sequenceiq/docker-spark` modified to work with scala 2.11

# Why

As of Jun.2015, Apache Spark binary distributions are only for scala 2.10 (and so is `sequenceiq/docker-spark` image).  

This fork provides an spark-docker image for scala 2.11 which requires [building it from the source][http://spark.apache.org/docs/latest/building-spark.html#building-for-scala-211].

# Getting the Docker Image

## Pre-Build Image (recommended)

`docker pull activeintel/docker-spark`

## Manually Build Docker Image

You can also build the image.

Download/pull this project; and at it's root:

`docker build --rm -t activeintel/spark:1.4.0 .`

Note: this is a lengthy process; will take ~30 min (for compilation/downloads, etc.).

# Verification

To verify that image works you can do the following.

Run the image:

`docker run -it activeintel/spark:1.4.0 bash`

```bash
# execute the the following command which should write the "Pi is roughly 3.1418" into the logs
# note you must specify --files argument in cluster mode to enable metrics
spark-submit \
--class org.apache.spark.examples.SparkPi \
--files $SPARK_HOME/conf/metrics.properties \
--master yarn-client \
--driver-memory 1g \
--executor-memory 1g \
--executor-cores 1 \
$SPARK_HOME/examples/target/scala-2.11/spark-examples-1.4.0-hadoop2.6.0.jar
```

Note that location of the jar `examples/target/scala-2.11/` is different from [sequenceiq/docker-spark](https://github.com/sequenceiq/docker-spark) which is in `lib/`.  
For more information see issue [#1](/../../issues/1)



# See Also

[sequenceiq/docker-spark](https://github.com/sequenceiq/docker-spark)


