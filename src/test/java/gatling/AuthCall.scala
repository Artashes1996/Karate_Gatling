package gatling

import io.gatling.core.Predef._
import scala.concurrent.duration._
import com.intuit.karate.gatling.PreDef._

class AuthCall extends Simulation {

  private val getSingleUser = scenario(scenarioName = "Login IBX").exec(karateFeature(name = "classpath:java/api/getAccessToken.feature"))

  setUp(
    getSingleUser.inject(rampUsers(users = 2).during(5 seconds))
  )

}