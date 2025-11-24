class QuotePriority {
  final int id;
  final int items;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? projectId;
  final String? projectName;
  final String customerImpact;
  final DateTime expiresAt;
  final int impactScore;
  final double hoursLeft;

  QuotePriority({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.projectId,
    this.projectName,
    required this.customerImpact,
    required this.expiresAt,
    required this.impactScore,
    required this.hoursLeft,
  });

  factory QuotePriority.fromJson(Map<String, dynamic> json) => QuotePriority(
    id: json['id'],
    items: json['items'],
    total: (json['total'] as num).toDouble(),
    status: json['status'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    projectId: json['projectId'],
    projectName: json['projectName'],
    customerImpact: json['customerImpact'],
    expiresAt: DateTime.parse(json['expiresAt']),
    impactScore: json['impactScore'],
    hoursLeft: (json['hoursLeft'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items,
    'total': total,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'projectId': projectId,
    'projectName': projectName,
    'customerImpact': customerImpact,
    'expiresAt': expiresAt.toIso8601String(),
    'impactScore': impactScore,
    'hoursLeft': hoursLeft,
  };
}

class QuoteProjectGroup {
  final int? projectId;
  final String projectName;
  final List<QuotePriority> quotes;

  QuoteProjectGroup({
    required this.projectId,
    required this.projectName,
    required this.quotes,
  });

  factory QuoteProjectGroup.fromJson(Map<String, dynamic> json) =>
      QuoteProjectGroup(
        projectId: json['projectId'],
        projectName: json['projectName'] ?? 'Sin proyecto',
        quotes: (json['quotes'] as List<dynamic>)
            .map((q) => QuotePriority.fromJson(q))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'projectName': projectName,
    'quotes': quotes.map((q) => q.toJson()).toList(),
  };
}

class QuotePriorityResult {
  final bool groupByProject;
  final List<QuotePriority> quotes;
  final List<QuoteProjectGroup>? groups;

  QuotePriorityResult({
    required this.groupByProject,
    required this.quotes,
    this.groups,
  });
}
