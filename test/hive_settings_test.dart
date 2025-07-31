import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speak_and_translate_update/features/translation/data/repositories/hive_user_settings_repository.dart';

void main() {
  group('UserSettingsRepository Tests', () {
    late UserSettingsRepository repository;
    
    setUpAll(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      await Hive.openBox('settings');
      repository = UserSettingsRepository();
    });
    
    tearDownAll(() async {
      // Clean up after tests
      await Hive.deleteBoxFromDisk('settings');
    });
    
    test('should return default settings when no data exists', () async {
      // Clear any existing data
      await repository.clearUserSettings();
      
      // Get settings
      final settings = await repository.getUserSettings();
      
      // Verify default values
      expect(settings['microphoneMode'], 'continuousListening');
      expect(settings['motherTongue'], 'spanish');
      expect(settings['appMode'], 'languageLearning');
      expect(settings['germanWordByWord'], true);
      expect(settings['englishWordByWord'], false);
      expect(settings['germanColloquial'], true);
      expect(settings['englishColloquial'], true);
    });
    
    test('should save and retrieve user settings', () async {
      // Test data
      final testSettings = {
        'microphoneMode': 'voiceCommand',
        'motherTongue': 'english',
        'appMode': 'travelMode',
        'germanWordByWord': false,
        'englishWordByWord': true,
        'germanNative': true,
        'germanColloquial': false,
        'germanInformal': true,
        'germanFormal': false,
        'englishNative': false,
        'englishColloquial': false,
        'englishInformal': false,
        'englishFormal': true,
      };
      
      // Save settings
      await repository.saveUserSettings(testSettings);
      
      // Retrieve settings
      final retrievedSettings = await repository.getUserSettings();
      
      // Verify all settings match
      expect(retrievedSettings['microphoneMode'], 'voiceCommand');
      expect(retrievedSettings['motherTongue'], 'english');
      expect(retrievedSettings['appMode'], 'travelMode');
      expect(retrievedSettings['germanWordByWord'], false);
      expect(retrievedSettings['englishWordByWord'], true);
      expect(retrievedSettings['germanNative'], true);
      expect(retrievedSettings['englishFormal'], true);
    });
    
    test('should check if settings exist', () async {
      // Clear settings
      await repository.clearUserSettings();
      expect(repository.hasStoredSettings(), false);
      
      // Save some settings
      await repository.saveUserSettings({'test': 'value'});
      expect(repository.hasStoredSettings(), true);
    });
    
    test('should handle errors gracefully', () async {
      // This test would require mocking Hive to throw errors
      // For now, we just verify the methods don't throw
      expect(() => repository.hasStoredSettings(), returnsNormally);
    });
  });
}
