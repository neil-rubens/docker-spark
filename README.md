Fork of `sequenceiq/docker-spark` modified to work with scala 2.11

# Why

Currently (Jun.2015), Apache Spark binary distributions are only for scala 2.10 (and so is `sequenceiq/docker-spark` image).  

This fork provides an spark-docker image for scala 2.11 which requires [building it from the source][http://spark.apache.org/docs/latest/building-spark.html#building-for-scala-211].


# Build Docker Image

Download this project; and at it's root:

`docker build --rm -t activeintel/spark:1.4.0 .`

