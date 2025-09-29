class Email {
  String emailAddress;
  String alias;
  Email({
    required this.emailAddress,
    this.alias = "",
  });

  String getAliasOrEmail() {
    return alias.isNotEmpty ? alias : emailAddress;
  }

  factory Email.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Email(
        emailAddress: parsedJson['emailAddress'] ?? "",
        alias: parsedJson['alias'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"emailAddress": emailAddress, "alias": alias};
  }
}
