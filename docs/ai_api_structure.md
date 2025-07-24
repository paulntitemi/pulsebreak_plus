# AI Wellness Coach API Structure

## Base URL
```
https://api.pulsebreak.com/v1
```

## Authentication
All requests require Bearer token authentication:
```
Authorization: Bearer <user_jwt_token>
```

## Core Endpoints

### 1. Chat with AI Coach
**POST** `/ai/chat`

**Purpose:** Main conversational interface with the AI wellness coach

**Request Body:**
```json
{
  "message": "I'm feeling anxious about work today",
  "conversation_id": "uuid-string", // optional, for continuing conversations
  "context": {
    "current_mood": "anxious",
    "time_of_day": "morning",
    "location": "work" // optional
  }
}
```

**Response:**
```json
{
  "response": "I understand you're feeling anxious about work. Let's explore some grounding techniques...",
  "conversation_id": "uuid-string",
  "suggestions": [
    {
      "type": "breathing_exercise",
      "title": "5-4-3-2-1 Grounding",
      "action_id": "grounding_technique_1"
    }
  ],
  "follow_up_questions": [
    "What specific aspect of work is causing the most anxiety?",
    "Have you tried any coping strategies yet today?"
  ]
}
```

### 2. Mood Analysis & Insights
**POST** `/ai/mood-analysis`

**Purpose:** Get AI insights based on mood patterns and journal entries

**Request Body:**
```json
{
  "timeframe": "week", // week, month, 3months
  "include_journal": true,
  "specific_question": "Why do I feel more anxious on Mondays?" // optional
}
```

**Response:**
```json
{
  "insights": [
    {
      "type": "pattern",
      "title": "Monday Anxiety Pattern",
      "description": "Your mood data shows consistently lower scores on Mondays...",
      "confidence": 0.85,
      "recommendations": ["sunday_prep", "monday_ritual"]
    }
  ],
  "mood_trends": {
    "overall_direction": "improving",
    "key_factors": ["sleep_quality", "exercise_frequency"],
    "concern_areas": ["work_stress", "social_anxiety"]
  },
  "personalized_tips": [
    "Consider preparing for Monday on Sunday evening",
    "Your anxiety levels correlate with poor sleep - focus on sleep hygiene"
  ]
}
```

### 3. Wellness Recommendations
**POST** `/ai/recommendations`

**Purpose:** Get personalized wellness recommendations

**Request Body:**
```json
{
  "focus_area": "stress_management", // stress, sleep, mood, anxiety, depression
  "current_challenges": ["work_stress", "poor_sleep"],
  "preferences": {
    "exercise_level": "beginner",
    "time_availability": "15_minutes",
    "preferred_activities": ["meditation", "journaling"]
  }
}
```

**Response:**
```json
{
  "recommendations": [
    {
      "id": "rec_001",
      "type": "daily_practice",
      "title": "Morning Mindfulness Routine",
      "description": "A 10-minute morning practice tailored to your stress levels",
      "difficulty": "beginner",
      "estimated_time": "10 minutes",
      "steps": [
        "Find a quiet space",
        "Focus on breath for 5 minutes",
        "Set positive intention for the day"
      ],
      "tracking_metrics": ["stress_level", "mood_improvement"]
    }
  ],
  "reasoning": "Based on your stress patterns and morning anxiety, this routine addresses your core challenges",
  "expected_outcomes": ["reduced morning anxiety", "better stress management"]
}
```

### 4. Goal Setting & Tracking
**POST** `/ai/goals`

**Purpose:** AI-powered goal suggestions and progress analysis

**Request Body:**
```json
{
  "action": "suggest", // suggest, analyze_progress, adjust
  "current_goals": [
    {
      "id": "goal_001",
      "title": "Meditate daily",
      "progress": 0.6,
      "challenges": ["finding_time", "staying_consistent"]
    }
  ],
  "focus_areas": ["stress_reduction", "better_sleep"]
}
```

**Response:**
```json
{
  "suggested_goals": [
    {
      "title": "10-minute morning meditation",
      "type": "habit",
      "difficulty": "easy",
      "timeline": "21_days",
      "success_factors": ["morning_routine", "meditation_app"],
      "milestones": [
        {"day": 7, "description": "Complete first week"},
        {"day": 14, "description": "Notice stress improvements"},
        {"day": 21, "description": "Habit formation complete"}
      ]
    }
  ],
  "goal_adjustments": [
    {
      "goal_id": "goal_001",
      "suggested_changes": "Reduce from 20 to 10 minutes to improve consistency",
      "reasoning": "Your completion rate suggests the current goal may be too ambitious"
    }
  ]
}
```

### 5. Crisis Detection & Support
**POST** `/ai/crisis-check`

**Purpose:** Monitor for mental health crisis indicators

**Request Body:**
```json
{
  "mood_score": 2, // 1-10 scale
  "journal_entry": "I feel hopeless and don't see the point anymore",
  "behavioral_changes": ["sleep_disruption", "social_withdrawal"],
  "duration": "2_weeks"
}
```

**Response:**
```json
{
  "risk_level": "moderate", // low, moderate, high, critical
  "immediate_recommendations": [
    {
      "type": "professional_help",
      "message": "Consider speaking with a mental health professional",
      "resources": [
        {
          "name": "Crisis Text Line",
          "contact": "Text HOME to 741741",
          "available": "24/7"
        }
      ]
    }
  ],
  "coping_strategies": [
    "Reach out to a trusted friend or family member",
    "Use grounding techniques to manage overwhelming feelings"
  ],
  "follow_up": {
    "check_in_hours": 24,
    "escalation_triggers": ["worsening_mood", "self_harm_thoughts"]
  }
}
```

### 6. Personalized Check-ins
**GET** `/ai/check-in`

**Purpose:** Daily AI-generated check-in questions

**Response:**
```json
{
  "check_in": {
    "primary_question": "How are you feeling about your stress levels today?",
    "follow_up_questions": [
      "What's one thing that went well for you today?",
      "Is there anything specific you'd like support with?"
    ],
    "mood_scale_prompt": "On a scale of 1-10, how would you rate your overall mood today?",
    "personalization_note": "I noticed you mentioned work stress yesterday - how did today go?"
  },
  "suggested_actions": [
    {
      "type": "quick_exercise",
      "title": "2-minute breathing break",
      "description": "Based on your stress levels, this could help reset your day"
    }
  ]
}
```

## Data Models

### User Context
```json
{
  "user_id": "uuid",
  "mood_history": [
    {
      "date": "2025-01-20",
      "mood_score": 7,
      "emotions": ["happy", "energetic"],
      "triggers": ["good_sleep", "exercise"]
    }
  ],
  "journal_entries": [
    {
      "date": "2025-01-20",
      "content": "Had a great day at work...",
      "mood_score": 8,
      "tags": ["work", "productivity"]
    }
  ],
  "goals": [
    {
      "id": "goal_001",
      "title": "Exercise 3x per week",
      "progress": 0.7,
      "created_date": "2025-01-01"
    }
  ],
  "preferences": {
    "communication_style": "supportive", // supportive, direct, motivational
    "focus_areas": ["anxiety", "stress"],
    "intervention_preferences": ["mindfulness", "cbt_techniques"]
  }
}
```

## Error Handling

### Standard Error Response
```json
{
  "error": {
    "code": "AI_SERVICE_UNAVAILABLE",
    "message": "AI service is temporarily unavailable",
    "retry_after": 30,
    "fallback_response": "I'm having trouble connecting right now. Please try again in a moment."
  }
}
```

### Error Codes
- `AI_SERVICE_UNAVAILABLE` - External AI service down
- `CONTEXT_TOO_LARGE` - Request context exceeds limits
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `INAPPROPRIATE_CONTENT` - Content flagged by safety filters
- `INSUFFICIENT_DATA` - Not enough user data for analysis

## Rate Limits
- Chat: 30 requests per minute
- Analysis: 10 requests per hour  
- Recommendations: 20 requests per day
- Crisis checks: No limit (safety critical)

## Privacy & Safety
- All conversations are encrypted
- Crisis detection triggers professional resource recommendations
- Content is filtered for safety
- User data is anonymized for AI training (opt-in only)
- Conversation history can be deleted by user