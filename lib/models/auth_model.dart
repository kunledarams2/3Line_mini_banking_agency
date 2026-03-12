class LoginRequest {
  final String agentId;
  final String password;

  const LoginRequest({required this.agentId, required this.password});

  Map<String, dynamic> toJson() => {'agentId': agentId, 'password': password};
}

class LoginResponse {
  final String token;
  final String agentName;

  const LoginResponse({required this.token, required this.agentName});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json['token'] as String,
        agentName: json['agentName'] as String,
      );
}
