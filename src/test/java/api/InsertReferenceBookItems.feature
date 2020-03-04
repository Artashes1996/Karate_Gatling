Feature: Reference book items actions.

  Background: Get Token for set in api calls. Define variables add json path. Generate current timestamp.

    * def userLogin = call read('file:src/test/java/api/getAccessToken.feature')
    * header token = userLogin.token

    * def ExchangeBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertExchange.json'
    * def LocationBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertLocation.json'
    * def InstrumentBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertLocation.json'
    * def PartnerBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertInstrument.json'
    * def SecurityBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertSecurity.json'
    * def CustodyTariffBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertCustodyTariff.json'
    * def BrokerageTariffBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertBrokerageTariff.json'
    * def TerminalTariffBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertTerminalTariff.json'
    * def InvestmentAdvisoryTariffBody = 'file:src/test/java/api/data/ReferenceBookItems/InsertInvestmentAdvisoryTariff.json'

    * def currentTimeStamp = function() { return java.lang.System.currentTimeMillis() + '' }

  Scenario Outline: Use Scenario Outline for Data Driven. Item Name is "<Item_Name>". Scenario Outline have three parameters "controller_with_action_name","body" and "prefix_data".

    Given url baseUrl + '<Insert_Controller_With_Action_Name>'

#   Set unique name selected entity.

    * def jsonFile = read(<Body>)
    * def Name = '<Prefix_Data>' + currentTimeStamp()
    * set jsonFile.Name = Name

#  Send post call, for insert entity.

    Given request jsonFile
    When method post
    Then status 200
    Then assert responseTime <1000
    And match response == {Success: true, Message: null, Data: '#number'}
    * def store_id = response.Data

#   Check insert functionality.

    * header token = userLogin.token

    Given url baseUrl + '<Get_Controller_With_Action_Name>' + store_id
    When method get
    Then status 200
    Then assert responseTime <1000
    * json sampleJson = response.Data
    * def updatedName = '<Prefix_Data>' + currentTimeStamp() + '_edit'
    * set sampleJson.Name = updatedName

#   Get all list same items, and check insert item contains in all list.

    * header token = userLogin.token

    Given url baseUrl + '<Get_All_Items>'
    When method get
    Then status 200
    Then assert responseTime <1000
    * def temp = karate.jsonPath(response, "$.Data[?(@.Name=='" + Name + "')]")[0].Id
    * print karate.jsonPath(response, "$.Data[?(@.Name=='" + Name + "')]")
    * print temp
    And match temp == store_id

#   Send post call, for update entity.

    * header token = userLogin.token

    Given url baseUrl + '<Update_Controller_With_Action_Name>'
    Given request sampleJson
    When method post
    Then status 200
    Then assert responseTime <1000
    And match response == {Success: true, Message: null, Data: null}

#   Use item id and send get call for check update functionality.

    * header token = userLogin.token

    Given url baseUrl + '<Get_Controller_With_Action_Name>' + store_id
    When method get
    Then status 200
    Then assert responseTime <1000
    And match response.Data.Name == updatedName

#   Get all list same items, and check updated item contains in all list.

    * header token = userLogin.token

    Given url baseUrl + '<Get_All_Items>'
    When method get
    Then status 200
    Then assert responseTime <1000
    * def temp = karate.jsonPath(response, "$.Data[?(@.Name=='" + updatedName + "')]")[0].Id
    And match temp == store_id



#   Table with parameters

    Examples:
      | Item_Name                | Insert_Controller_With_Action_Name  | Body                         | Prefix_Data                               | Get_Controller_With_Action_Name   | Update_Controller_With_Action_Name  | Get_All_Items                        |
      | Exchange                 | Exchange/InsertExchange             | ExchangeBody                 | Exchange_name_api_test_                   | Exchange/GetExchange/             | Exchange/UpdateExchange             | Exchange/GetAllExchanges             |
      | Location                 | Location/InsertLocation             | LocationBody                 | Location_name_api_test_                   | Location/GetLocation/             | Location/UpdateLocation             | Location/GetAllLocations             |
      | InstrumentType           | InstrumentType/InsertInstrumentType | InstrumentBody               | Instrument_Type_api_test_                 | InstrumentType/GetInstrumentType/ | InstrumentType/UpdateInstrumentType | InstrumentType/GetAllInstrumentTypes |
      | Partner                  | Partner/InsertPartner               | PartnerBody                  | Partner_name_api_test_                    | Partner/GetPartner/               | Partner/UpdatePartner               | Partner/GetAllPartners               |
      | CustodyTariff            | Tariff/InsertTariff                 | CustodyTariffBody            | Custody_Tariff_name_api_test_             | Tariff/GetTariff/                 | Tariff/UpdateTariff                 | Tariff/GetTariffsGridView            |
      | BrokerageTariff          | Tariff/InsertTariff                 | BrokerageTariffBody          | Brokerage_Tariff_name_api_test_           | Tariff/GetTariff/                 | Tariff/UpdateTariff                 | Tariff/GetTariffsGridView            |
      | TerminalTariff           | Tariff/InsertTariff                 | TerminalTariffBody           | Terminal_Tariff_name_api_test_            | Tariff/GetTariff/                 | Tariff/UpdateTariff                 | Tariff/GetTariffsGridView            |
      | InvestmentAdvisoryTariff | Tariff/InsertTariff                 | InvestmentAdvisoryTariffBody | Investment_Advisory_Tariff_name_api_test_ | Tariff/GetTariff/                 | Tariff/UpdateTariff                 | Tariff/GetTariffsGridView            |






