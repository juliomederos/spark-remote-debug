import org.apache.spark.sql.SparkSession

object DemoApp {

  def main(args: Array[String]): Unit = {

    val spark: SparkSession = SparkSession.builder().appName("DemoApp Debug").getOrCreate()

    println("Hello world")

    spark.close()

  }
}
