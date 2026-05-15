import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonymusic/ui/screens/Home/home_screen_controller.dart';

MediaItem _song(String id) => MediaItem(id: id, title: 'Song $id');

void main() {
  group('takePlayableHomeSection', () {
    test('prefers the requested playable section', () {
      final sections = [
        {
          'title': 'Fresh songs',
          'contents': [_song('fallback')]
        },
        {
          'title': 'Quick picks',
          'contents': [_song('quick-pick')]
        },
      ];

      final picked = takePlayableHomeSection(sections, const ['Quick picks']);

      expect(picked?['title'], 'Quick picks');
      expect((picked?['contents'] as List).single.id, 'quick-pick');
      expect(sections.length, 1);
    });

    test('falls back to the first playable section when Quick picks is missing',
        () {
      final sections = [
        {
          'title': 'Albums',
          'contents': ['not a playable song']
        },
        {
          'title': 'Fresh songs',
          'contents': [_song('fallback')]
        },
      ];

      final picked = takePlayableHomeSection(sections, const ['Quick picks']);

      expect(picked?['title'], 'Fresh songs');
      expect((picked?['contents'] as List).single.id, 'fallback');
      expect(sections.length, 1);
    });

    test('returns null when no playable section exists', () {
      final sections = [
        {'title': 'Albums', 'contents': []},
        {
          'title': 'Playlists',
          'contents': ['not a playable song']
        },
      ];

      final picked = takePlayableHomeSection(sections, const ['Quick picks']);

      expect(picked, isNull);
      expect(sections.length, 2);
    });

    test('can disable fallback for specific requested sections', () {
      final sections = [
        {
          'title': 'Fresh songs',
          'contents': [_song('fallback')]
        },
      ];

      final picked = takePlayableHomeSection(
        sections,
        const ['Trending'],
        fallbackToFirstPlayable: false,
      );

      expect(picked, isNull);
      expect(sections.length, 1);
    });
  });
}
