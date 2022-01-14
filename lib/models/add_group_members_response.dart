class AddGroupMembersResponse {
  factory AddGroupMembersResponse.fromJson(Map<String, dynamic> json) =>
      AddGroupMembersResponse(
        added: List<String>.from(json['added'].map((x) => x)),
        pending: List<String>.from(json['pending'].map((x) => x)),
        invalid: List<String>.from(json['invalid'].map((x) => x)),
      );

  AddGroupMembersResponse({
    required this.added,
    required this.pending,
    required this.invalid,
  });
  List<String> added;
  List<String> pending;
  List<String> invalid;
}
