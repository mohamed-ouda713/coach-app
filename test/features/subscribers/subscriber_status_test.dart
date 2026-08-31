import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/features/subscribers/models/subscriber_model.dart';

SubscriberModel clientEnding(Duration fromNow) {
  final now = DateTime.now();
  return SubscriberModel(
    id: 'id',
    trainerId: 'trainer',
    fullName: 'Lina',
    goal: FitnessGoal.muscleGain,
    program: ProgramType.gym,
    subscriptionStartDate: now,
    subscriptionEndDate: now.add(fromNow),
    subscriptionFee: 200,
    createdAt: now,
  );
}

void main() {
  group('status', () {
    test('a subscription ending in a week is active', () {
      expect(
        clientEnding(const Duration(days: 7)).status,
        SubscriptionStatus.active,
      );
    });

    test('a subscription ending within the threshold is expiring soon', () {
      expect(
        clientEnding(const Duration(days: 2)).status,
        SubscriptionStatus.expiringSoon,
      );
    });

    test('a subscription ending today is not yet expired', () {
      // العمود تاريخ بلا وقت، فالمقارنة لازم تكون بالأيام مش بالساعات.
      expect(
        clientEnding(Duration.zero).status,
        isNot(SubscriptionStatus.expired),
      );
    });

    test('a subscription that ended yesterday is expired', () {
      expect(
        clientEnding(const Duration(days: -1)).status,
        SubscriptionStatus.expired,
      );
    });
  });

  group('isActive', () {
    test('an expiring-soon client still counts as active', () {
      final client = clientEnding(const Duration(days: 2));

      expect(client.status, SubscriptionStatus.expiringSoon);
      expect(
        client.isActive,
        isTrue,
        reason:
            '"expiring soon" is a warning about a live subscription, not a '
            'replacement for it — it must still appear under the active filter',
      );
    });

    test('a comfortably active client is active', () {
      expect(clientEnding(const Duration(days: 30)).isActive, isTrue);
    });

    test('an expired client is not active', () {
      expect(clientEnding(const Duration(days: -5)).isActive, isFalse);
    });
  });
}
