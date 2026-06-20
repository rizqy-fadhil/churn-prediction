class TopFeature {
  final String feature;
  final double value;

  TopFeature({required this.feature, required this.value});

  factory TopFeature.fromJson(Map<String, dynamic> json) {
    return TopFeature(
      feature: json['feature'],
      value: (json['value'] as num).toDouble(),
    );
  }
}

class PredictionResult {
  final String predictionLabel;
  final double churnProbability;
  final int inferenceTimeMs;

  PredictionResult({
    required this.predictionLabel,
    required this.churnProbability,
    required this.inferenceTimeMs,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictionLabel: json['prediction_label'],
      churnProbability: (json['churn_probability'] as num).toDouble(),
      inferenceTimeMs: json['inference_time_ms'],
    );
  }
}

class ChurnPrediction {
  final int id;
  final int accountLength;
  final int numberVmailMessages;
  final double totalDayMinutes;
  final int totalDayCalls;
  final double totalDayCharge;
  final double totalEveMinutes;
  final int totalEveCalls;
  final double totalEveCharge;
  final double totalNightMinutes;
  final int totalNightCalls;
  final double totalNightCharge;
  final double totalIntlMinutes;
  final int totalIntlCalls;
  final double totalIntlCharge;
  final int customerServiceCalls;
  final String internationalPlan;
  final String voiceMailPlan;
  final String? createdAt;
  final PredictionResult? prediction;
  final List<TopFeature> topFeatures;

  ChurnPrediction({
    required this.id,
    required this.accountLength,
    required this.numberVmailMessages,
    required this.totalDayMinutes,
    required this.totalDayCalls,
    required this.totalDayCharge,
    required this.totalEveMinutes,
    required this.totalEveCalls,
    required this.totalEveCharge,
    required this.totalNightMinutes,
    required this.totalNightCalls,
    required this.totalNightCharge,
    required this.totalIntlMinutes,
    required this.totalIntlCalls,
    required this.totalIntlCharge,
    required this.customerServiceCalls,
    required this.internationalPlan,
    required this.voiceMailPlan,
    this.createdAt,
    this.prediction,
    required this.topFeatures,
  });

  factory ChurnPrediction.fromJson(Map<String, dynamic> json) {
    return ChurnPrediction(
      id: json['id'],
      accountLength: json['account_length'],
      numberVmailMessages: json['number_vmail_messages'],
      totalDayMinutes: (json['total_day_minutes'] as num).toDouble(),
      totalDayCalls: json['total_day_calls'],
      totalDayCharge: (json['total_day_charge'] as num).toDouble(),
      totalEveMinutes: (json['total_eve_minutes'] as num).toDouble(),
      totalEveCalls: json['total_eve_calls'],
      totalEveCharge: (json['total_eve_charge'] as num).toDouble(),
      totalNightMinutes: (json['total_night_minutes'] as num).toDouble(),
      totalNightCalls: json['total_night_calls'],
      totalNightCharge: (json['total_night_charge'] as num).toDouble(),
      totalIntlMinutes: (json['total_intl_minutes'] as num).toDouble(),
      totalIntlCalls: json['total_intl_calls'],
      totalIntlCharge: (json['total_intl_charge'] as num).toDouble(),
      customerServiceCalls: json['customer_service_calls'],
      internationalPlan: json['international_plan'],
      voiceMailPlan: json['voice_mail_plan'],
      createdAt: json['created_at'],
      prediction: json['prediction'] != null
          ? PredictionResult.fromJson(json['prediction'])
          : null,
      topFeatures: (json['top_features'] as List)
          .map((e) => TopFeature.fromJson(e))
          .toList(),
    );
  }
}