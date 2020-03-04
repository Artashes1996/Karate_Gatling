Feature: Login IBX for getting Token

  Background: * url baseUrl

  Scenario: Login IBX

    * def instrumentBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertInstrument.json'
    Given url baseUrl + 'Account/Login'
    And request {username:'test',password:'test'}
    When method post
    Then status 200
    Then match response.Success == true
    And def toke = response.Data.Token

    And header token = toke
    Given url 'https://brokerstest.ameriabank.am/v1/api/InstrumentType/InsertInstrumentType'
    Given request instrumentBody
    When method post
    Then status 200




