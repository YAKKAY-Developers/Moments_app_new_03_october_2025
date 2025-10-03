class EventInvitationModel {
  final String phoneNumber;
  final String status;
  final String? invitationToken;
  
  EventInvitationModel({
    required this.phoneNumber,
    required this.status,
    this.invitationToken,
  });

  factory EventInvitationModel.fromJson(Map<String, dynamic> json) {
    return EventInvitationModel(
      phoneNumber: json['phone_number'] ?? '',
      status: json['status'] ?? '',
      invitationToken: json['invitation_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'status': status,
      if (invitationToken != null) 'invitation_token': invitationToken,
    };
  }
}
