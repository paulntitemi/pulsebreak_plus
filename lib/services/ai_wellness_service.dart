import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AIWellnessService {
  static const String _baseUrl = 'https://api.pulsebreak.com/v1';
  static const String _mockBaseUrl = 'https://mock-api.pulsebreak.com/v1'; // For development
  
  // Use mock URL in debug mode
  static String get baseUrl => kDebugMode ? _mockBaseUrl : _baseUrl;
  
  static AIWellnessService? _instance;
  static AIWellnessService get instance => _instance ??= AIWellnessService._();
  AIWellnessService._();

  String? _authToken;
  
  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Chat with AI Coach
  Future<AIChatResponse> sendChatMessage({
    required String message,
    String? conversationId,
    ChatContext? context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/chat'),
        headers: _headers,
        body: jsonEncode({
          'message': message,
          if (conversationId != null) 'conversation_id': conversationId,
          if (context != null) 'context': context.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return AIChatResponse.fromJson(responseData);
      } else if (response.statusCode == 429) {
        throw AIException('Rate limit exceeded. Please wait a moment and try again.');
      } else {
        throw AIException('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AIException) rethrow;
      
      // Return fallback response for network/server errors
      return AIChatResponse(
        response: "I'm having trouble connecting right now. Please check your internet connection and try again.",
        conversationId: conversationId ?? _generateUuid(),
        suggestions: [],
        followUpQuestions: [],
      );
    }
  }

  // Get mood analysis and insights
  Future<MoodAnalysisResponse> getMoodAnalysis({
    required String timeframe,
    bool includeJournal = true,
    String? specificQuestion,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/mood-analysis'),
        headers: _headers,
        body: jsonEncode({
          'timeframe': timeframe,
          'include_journal': includeJournal,
          if (specificQuestion != null) 'specific_question': specificQuestion,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return MoodAnalysisResponse.fromJson(responseData);
      } else {
        throw AIException('Failed to get mood analysis: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AIException) rethrow;
      throw AIException('Network error during mood analysis');
    }
  }

  // Get wellness recommendations
  Future<WellnessRecommendationsResponse> getWellnessRecommendations({
    required String focusArea,
    List<String> currentChallenges = const [],
    UserPreferences? preferences,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/recommendations'),
        headers: _headers,
        body: jsonEncode({
          'focus_area': focusArea,
          'current_challenges': currentChallenges,
          if (preferences != null) 'preferences': preferences.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return WellnessRecommendationsResponse.fromJson(responseData);
      } else {
        throw AIException('Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AIException) rethrow;
      throw AIException('Network error during recommendations fetch');
    }
  }

  // Get goal suggestions and analysis
  Future<GoalResponse> getGoalSuggestions({
    required String action,
    List<CurrentGoal> currentGoals = const [],
    List<String> focusAreas = const [],
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/goals'),
        headers: _headers,
        body: jsonEncode({
          'action': action,
          'current_goals': currentGoals.map((g) => g.toJson()).toList(),
          'focus_areas': focusAreas,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return GoalResponse.fromJson(responseData);
      } else {
        throw AIException('Failed to get goal suggestions: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AIException) rethrow;
      throw AIException('Network error during goal suggestions');
    }
  }

  // Crisis detection and support
  Future<CrisisCheckResponse> performCrisisCheck({
    required int moodScore,
    String? journalEntry,
    List<String> behavioralChanges = const [],
    String? duration,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/crisis-check'),
        headers: _headers,
        body: jsonEncode({
          'mood_score': moodScore,
          if (journalEntry != null) 'journal_entry': journalEntry,
          'behavioral_changes': behavioralChanges,
          if (duration != null) 'duration': duration,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return CrisisCheckResponse.fromJson(responseData);
      } else {
        throw AIException('Failed to perform crisis check: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AIException) rethrow;
      
      // For crisis checks, always provide fallback resources
      return CrisisCheckResponse(
        riskLevel: 'moderate',
        immediateRecommendations: [
          ImmediateRecommendation(
            type: 'professional_help',
            message: 'Please consider speaking with a mental health professional',
            resources: [
              CrisisResource(
                name: 'Crisis Text Line',
                contact: 'Text HOME to 741741',
                available: '24/7',
              ),
            ],
          ),
        ],
        copingStrategies: [
          'Reach out to a trusted friend or family member',
          'Use grounding techniques to manage overwhelming feelings',
        ],
        followUp: FollowUp(
          checkInHours: 24,
          escalationTriggers: ['worsening_mood', 'self_harm_thoughts'],
        ),
      );
    }
  }

  // Get personalized check-in
  Future<CheckInResponse> getPersonalizedCheckIn() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ai/check-in'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return CheckInResponse.fromJson(responseData);
      } else {
        throw AIException('Failed to get check-in: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AIException) rethrow;
      
      // Fallback check-in
      return CheckInResponse(
        checkIn: CheckIn(
          primaryQuestion: 'How are you feeling today?',
          followUpQuestions: [
            'What\'s one thing you\'re grateful for today?',
            'Is there anything you\'d like support with?',
          ],
          moodScalePrompt: 'On a scale of 1-10, how would you rate your overall mood today?',
          personalizationNote: null,
        ),
        suggestedActions: [],
      );
    }
  }

  String _generateUuid() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

// Data Models
class ChatContext {
  final String? currentMood;
  final String? timeOfDay;
  final String? location;

  ChatContext({
    this.currentMood,
    this.timeOfDay,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    if (currentMood != null) 'current_mood': currentMood,
    if (timeOfDay != null) 'time_of_day': timeOfDay,
    if (location != null) 'location': location,
  };
}

class AIChatResponse {
  final String response;
  final String conversationId;
  final List<AISuggestion> suggestions;
  final List<String> followUpQuestions;

  AIChatResponse({
    required this.response,
    required this.conversationId,
    required this.suggestions,
    required this.followUpQuestions,
  });

  factory AIChatResponse.fromJson(Map<String, dynamic> json) {
    return AIChatResponse(
      response: json['response'] as String? ?? '',
      conversationId: json['conversation_id'] as String? ?? '',
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((s) => AISuggestion.fromJson(s as Map<String, dynamic>))
          .toList() ?? [],
      followUpQuestions: List<String>.from(json['follow_up_questions'] as List<dynamic>? ?? []),
    );
  }
}

class AISuggestion {
  final String type;
  final String title;
  final String actionId;

  AISuggestion({
    required this.type,
    required this.title,
    required this.actionId,
  });

  factory AISuggestion.fromJson(Map<String, dynamic> json) {
    return AISuggestion(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      actionId: json['action_id'] as String? ?? '',
    );
  }
}

class MoodAnalysisResponse {
  final List<MoodInsight> insights;
  final MoodTrends moodTrends;
  final List<String> personalizedTips;

  MoodAnalysisResponse({
    required this.insights,
    required this.moodTrends,
    required this.personalizedTips,
  });

  factory MoodAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return MoodAnalysisResponse(
      insights: (json['insights'] as List<dynamic>?)
          ?.map((i) => MoodInsight.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      moodTrends: MoodTrends.fromJson(json['mood_trends'] as Map<String, dynamic>? ?? {}),
      personalizedTips: List<String>.from(json['personalized_tips'] as List<dynamic>? ?? []),
    );
  }
}

class MoodInsight {
  final String type;
  final String title;
  final String description;
  final double confidence;
  final List<String> recommendations;

  MoodInsight({
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    required this.recommendations,
  });

  factory MoodInsight.fromJson(Map<String, dynamic> json) {
    return MoodInsight(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      recommendations: List<String>.from(json['recommendations'] as List<dynamic>? ?? []),
    );
  }
}

class MoodTrends {
  final String overallDirection;
  final List<String> keyFactors;
  final List<String> concernAreas;

  MoodTrends({
    required this.overallDirection,
    required this.keyFactors,
    required this.concernAreas,
  });

  factory MoodTrends.fromJson(Map<String, dynamic> json) {
    return MoodTrends(
      overallDirection: json['overall_direction'] as String? ?? '',
      keyFactors: List<String>.from(json['key_factors'] as List<dynamic>? ?? []),
      concernAreas: List<String>.from(json['concern_areas'] as List<dynamic>? ?? []),
    );
  }
}

class WellnessRecommendationsResponse {
  final List<WellnessRecommendation> recommendations;
  final String reasoning;
  final List<String> expectedOutcomes;

  WellnessRecommendationsResponse({
    required this.recommendations,
    required this.reasoning,
    required this.expectedOutcomes,
  });

  factory WellnessRecommendationsResponse.fromJson(Map<String, dynamic> json) {
    return WellnessRecommendationsResponse(
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((r) => WellnessRecommendation.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
      reasoning: json['reasoning'] as String? ?? '',
      expectedOutcomes: List<String>.from(json['expected_outcomes'] as List<dynamic>? ?? []),
    );
  }
}

class WellnessRecommendation {
  final String id;
  final String type;
  final String title;
  final String description;
  final String difficulty;
  final String estimatedTime;
  final List<String> steps;
  final List<String> trackingMetrics;

  WellnessRecommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedTime,
    required this.steps,
    required this.trackingMetrics,
  });

  factory WellnessRecommendation.fromJson(Map<String, dynamic> json) {
    return WellnessRecommendation(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      estimatedTime: json['estimated_time'] as String? ?? '',
      steps: List<String>.from(json['steps'] as List<dynamic>? ?? []),
      trackingMetrics: List<String>.from(json['tracking_metrics'] as List<dynamic>? ?? []),
    );
  }
}

class UserPreferences {
  final String exerciseLevel;
  final String timeAvailability;
  final List<String> preferredActivities;

  UserPreferences({
    required this.exerciseLevel,
    required this.timeAvailability,
    required this.preferredActivities,
  });

  Map<String, dynamic> toJson() => {
    'exercise_level': exerciseLevel,
    'time_availability': timeAvailability,
    'preferred_activities': preferredActivities,
  };
}

class CurrentGoal {
  final String id;
  final String title;
  final double progress;
  final List<String> challenges;

  CurrentGoal({
    required this.id,
    required this.title,
    required this.progress,
    required this.challenges,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'progress': progress,
    'challenges': challenges,
  };
}

class GoalResponse {
  final List<SuggestedGoal> suggestedGoals;
  final List<GoalAdjustment> goalAdjustments;

  GoalResponse({
    required this.suggestedGoals,
    required this.goalAdjustments,
  });

  factory GoalResponse.fromJson(Map<String, dynamic> json) {
    return GoalResponse(
      suggestedGoals: (json['suggested_goals'] as List<dynamic>?)
          ?.map((g) => SuggestedGoal.fromJson(g as Map<String, dynamic>))
          .toList() ?? [],
      goalAdjustments: (json['goal_adjustments'] as List<dynamic>?)
          ?.map((a) => GoalAdjustment.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class SuggestedGoal {
  final String title;
  final String type;
  final String difficulty;
  final String timeline;
  final List<String> successFactors;
  final List<GoalMilestone> milestones;

  SuggestedGoal({
    required this.title,
    required this.type,
    required this.difficulty,
    required this.timeline,
    required this.successFactors,
    required this.milestones,
  });

  factory SuggestedGoal.fromJson(Map<String, dynamic> json) {
    return SuggestedGoal(
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      timeline: json['timeline'] as String? ?? '',
      successFactors: List<String>.from(json['success_factors'] as List<dynamic>? ?? []),
      milestones: (json['milestones'] as List<dynamic>?)
          ?.map((m) => GoalMilestone.fromJson(m as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class GoalMilestone {
  final int day;
  final String description;

  GoalMilestone({
    required this.day,
    required this.description,
  });

  factory GoalMilestone.fromJson(Map<String, dynamic> json) {
    return GoalMilestone(
      day: json['day'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }
}

class GoalAdjustment {
  final String goalId;
  final String suggestedChanges;
  final String reasoning;

  GoalAdjustment({
    required this.goalId,
    required this.suggestedChanges,
    required this.reasoning,
  });

  factory GoalAdjustment.fromJson(Map<String, dynamic> json) {
    return GoalAdjustment(
      goalId: json['goal_id'] as String? ?? '',
      suggestedChanges: json['suggested_changes'] as String? ?? '',
      reasoning: json['reasoning'] as String? ?? '',
    );
  }
}

class CrisisCheckResponse {
  final String riskLevel;
  final List<ImmediateRecommendation> immediateRecommendations;
  final List<String> copingStrategies;
  final FollowUp followUp;

  CrisisCheckResponse({
    required this.riskLevel,
    required this.immediateRecommendations,
    required this.copingStrategies,
    required this.followUp,
  });

  factory CrisisCheckResponse.fromJson(Map<String, dynamic> json) {
    return CrisisCheckResponse(
      riskLevel: json['risk_level'] as String? ?? '',
      immediateRecommendations: (json['immediate_recommendations'] as List<dynamic>?)
          ?.map((r) => ImmediateRecommendation.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
      copingStrategies: List<String>.from(json['coping_strategies'] as List<dynamic>? ?? []),
      followUp: FollowUp.fromJson(json['follow_up'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ImmediateRecommendation {
  final String type;
  final String message;
  final List<CrisisResource> resources;

  ImmediateRecommendation({
    required this.type,
    required this.message,
    required this.resources,
  });

  factory ImmediateRecommendation.fromJson(Map<String, dynamic> json) {
    return ImmediateRecommendation(
      type: json['type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      resources: (json['resources'] as List<dynamic>?)
          ?.map((r) => CrisisResource.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class CrisisResource {
  final String name;
  final String contact;
  final String available;

  CrisisResource({
    required this.name,
    required this.contact,
    required this.available,
  });

  factory CrisisResource.fromJson(Map<String, dynamic> json) {
    return CrisisResource(
      name: json['name'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      available: json['available'] as String? ?? '',
    );
  }
}

class FollowUp {
  final int checkInHours;
  final List<String> escalationTriggers;

  FollowUp({
    required this.checkInHours,
    required this.escalationTriggers,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      checkInHours: json['check_in_hours'] as int? ?? 24,
      escalationTriggers: List<String>.from(json['escalation_triggers'] as List<dynamic>? ?? []),
    );
  }
}

class CheckInResponse {
  final CheckIn checkIn;
  final List<SuggestedAction> suggestedActions;

  CheckInResponse({
    required this.checkIn,
    required this.suggestedActions,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      checkIn: CheckIn.fromJson(json['check_in'] as Map<String, dynamic>? ?? {}),
      suggestedActions: (json['suggested_actions'] as List<dynamic>?)
          ?.map((a) => SuggestedAction.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class CheckIn {
  final String primaryQuestion;
  final List<String> followUpQuestions;
  final String moodScalePrompt;
  final String? personalizationNote;

  CheckIn({
    required this.primaryQuestion,
    required this.followUpQuestions,
    required this.moodScalePrompt,
    this.personalizationNote,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      primaryQuestion: json['primary_question'] as String? ?? '',
      followUpQuestions: List<String>.from(json['follow_up_questions'] as List<dynamic>? ?? []),
      moodScalePrompt: json['mood_scale_prompt'] as String? ?? '',
      personalizationNote: json['personalization_note'] as String?,
    );
  }
}

class SuggestedAction {
  final String type;
  final String title;
  final String description;

  SuggestedAction({
    required this.type,
    required this.title,
    required this.description,
  });

  factory SuggestedAction.fromJson(Map<String, dynamic> json) {
    return SuggestedAction(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class AIException implements Exception {
  final String message;
  AIException(this.message);

  @override
  String toString() => 'AIException: $message';
}