class Requests {
  static String get companies => 'https://fake-api.tractian.com/companies';
  static String locations({required String companieId}) =>


      'https://fake-api.tractian.com/companies/$companieId/locations';
}
