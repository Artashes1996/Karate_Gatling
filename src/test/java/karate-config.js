function fn() {


  var env = karate.env;
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
     baseUrl: 'https://brokerstest.ameriabank.am/v1/api/',

  }
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}


