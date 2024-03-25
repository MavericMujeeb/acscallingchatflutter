import 'dart:convert';

/// token_type : "Bearer"
/// expires_in : 3599
/// ext_expires_in : 3599
/// access_token : "eyJ0eXAiOiJKV1QiLCJub25jZSI6IlV3UHFPS3d6ck1KcU5yTkVTbWlPcWFwWjNhNWtkaFZxQWZtZGpsM3BqS28iLCJhbGciOiJSUzI1NiIsIng1dCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSIsImtpZCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8zMmQ3OTUyOS0zZGVmLTQ3OTUtOWJjYi0zMDhhMDBiN2Q1M2QvIiwiaWF0IjoxNzExMzg3ODQ1LCJuYmYiOjE3MTEzODc4NDUsImV4cCI6MTcxMTM5MTc0NSwiYWlvIjoiRTJOZ1lDaGMvU1I2a3RHdTBxN0VzTFZUSitvOEFBQT0iLCJhcHBfZGlzcGxheW5hbWUiOiJQb3N0bWFuIE1TIEdyYXBoIiwiYXBwaWQiOiJlNmM1MzM5Ny0zYjFjLTQzNjAtYjc2MS02MjU1ZDU5ZmM4NTIiLCJhcHBpZGFjciI6IjEiLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8zMmQ3OTUyOS0zZGVmLTQ3OTUtOWJjYi0zMDhhMDBiN2Q1M2QvIiwiaWR0eXAiOiJhcHAiLCJvaWQiOiI2YzZlN2Y3OS0zZmQ0LTQwN2EtYWVkNC1jZGViZjMyZTg0MTIiLCJyaCI6IjAuQVVZQUtaWFhNdTg5bFVlYnl6Q0tBTGZWUFFNQUFBQUFBQUFBd0FBQUFBQUFBQUM4QUFBLiIsInJvbGVzIjpbIk1haWwuUmVhZFdyaXRlIiwiVXNlci5SZWFkV3JpdGUuQWxsIiwiQm9va2luZ3NBcHBvaW50bWVudC5SZWFkV3JpdGUuQWxsIiwiQm9va2luZ3MuUmVhZC5BbGwiLCJDYWxlbmRhcnMuUmVhZFdyaXRlIiwiTWFpbC5TZW5kIiwiTWFpbGJveFNldHRpbmdzLlJlYWRXcml0ZSJdLCJzdWIiOiI2YzZlN2Y3OS0zZmQ0LTQwN2EtYWVkNC1jZGViZjMyZTg0MTIiLCJ0ZW5hbnRfcmVnaW9uX3Njb3BlIjoiTkEiLCJ0aWQiOiIzMmQ3OTUyOS0zZGVmLTQ3OTUtOWJjYi0zMDhhMDBiN2Q1M2QiLCJ1dGkiOiJSa0J6c202c2gwMnJOZ3pucnJkMEFBIiwidmVyIjoiMS4wIiwid2lkcyI6WyIwOTk3YTFkMC0wZDFkLTRhY2ItYjQwOC1kNWNhNzMxMjFlOTAiXSwieG1zX3RjZHQiOjE2ODIzNTk5NDh9.RyqQ9x5xZqsUZuAGIU2BE3H4yo4sfVpEddZN9-Brdl8EB93X6zXg9R457R96yskDBIw1n4KZo0gUPXnM13kKgPlce72FiK7Z7FZolvWjkQlfmw8qMuMCZsPZ6-cv_ZprQCEzNzYJtpRG7Jdp4RBJCfegybz_pS1Qq54L48EMQ119o0-ijSlZ53fx-lVlL4iw8sbT3WG26cQYNcDI5CR8QRxhqulyC2tJQXVY7OfDFiztnFSWX3KgV3uQh_isWUNYvhP0OhrHsCc1x3xN4Sr-M6DTK1ytd5GAMDRhnA4qcvnEFa0mcI-J7niC2wqWD7JtiG-womTVdaHZE9NrfIiM3g"

class AccessToken {
  AccessToken({
    String? tokenType,
    num? expiresIn,
    num? extExpiresIn,
    String? accessToken,
  }) {
    _tokenType = tokenType;
    _expiresIn = expiresIn;
    _extExpiresIn = extExpiresIn;
    _accessToken = accessToken;
  }

  AccessToken.jsonDecode(dynamic source) {
    var respToken = jsonDecode(source);
    AccessToken.fromJson(respToken);
  }

  AccessToken.fromJson(dynamic json) {
    _tokenType = json['token_type'];
    _expiresIn = json['expires_in'];
    _extExpiresIn = json['ext_expires_in'];
    _accessToken = json['access_token'];
  }

  String? _tokenType;
  num? _expiresIn;
  num? _extExpiresIn;
  String? _accessToken;

  AccessToken copyWith({
    String? tokenType,
    num? expiresIn,
    num? extExpiresIn,
    String? accessToken,
  }) =>
      AccessToken(
        tokenType: tokenType ?? _tokenType,
        expiresIn: expiresIn ?? _expiresIn,
        extExpiresIn: extExpiresIn ?? _extExpiresIn,
        accessToken: accessToken ?? _accessToken,
      );

  String? get tokenType => _tokenType;

  num? get expiresIn => _expiresIn;

  num? get extExpiresIn => _extExpiresIn;

  String? get accessToken => _accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token_type'] = _tokenType;
    map['expires_in'] = _expiresIn;
    map['ext_expires_in'] = _extExpiresIn;
    map['access_token'] = _accessToken;
    return map;
  }
}
