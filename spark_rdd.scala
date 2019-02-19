val rdd = sc.textFile("/home/lin/1_training/nasa/*.gz")

// regex
val REG = """(.+) - - \[(.+)\] \"(.+)\" (\d+) (.+)""".r

def parseRDD(log: String) = {

  val res = REG.findFirstMatchIn(log)

  val m = res.get

  if (m.group(5) == "-"){
    (m.group(1), m.group(2), m.group(3), m.group(4), 0)
  } else {
    (m.group(1), m.group(2), m.group(3), m.group(4), m.group(5).toInt)
  }
}

val result = rdd.map(parseRDD)

result.take(3)

val df = result.toDF("hostnames","date","gets","code","size")

val df404 = df.where($"code" === "404")

println("===== Total de erros 404 =====")
df404.count

println("===== Top 5 erros 404 =====")
df404.groupBy("hostnames").count.sort($"count".desc).show(5)


println("===== Quant erros 404 por dia ======")
df404.withColumn("datas", $"date".substr(0,11)).groupBy("datas").count.sort($"datas".asc).show(100)


println("===== Quant bytes retornados =====")
df.select(sum("size").alias("total")).show
