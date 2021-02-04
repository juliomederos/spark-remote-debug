package exercise

import java.io.FileInputStream
import java.util.Properties

import org.apache.spark.serializer.KryoSerializer
import org.apache.spark.sql.SparkSession
import org.datasyslab.geosparksql.utils.GeoSparkSQLRegistrator
import org.datasyslab.geosparkviz.core.Serde.GeoSparkVizKryoRegistrator
import org.apache.spark.sql.functions.col
import org.apache.spark.sql.types.{LongType, StringType}

object DemoApp{

  def main (args : Array[String]): Unit ={

    val spark: SparkSession = SparkSession.builder().appName("DemoApp Debug").getOrCreate()

    println("Hello world")

    spark.close()

  }
}
