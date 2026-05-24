import '../models/manga.dart';
import '../models/chapter.dart';

// Chapter pages still use picsum (Tapas episode content requires auth)
String _page(String seed, int page) =>
    'https://picsum.photos/seed/${seed}_p$page/800/1200';

List<String> _pages(String seed, {int count = 20}) =>
    List.generate(count, (i) => _page(seed, i + 1));

/// Converts a Tapas-style "1.2m" view string into an int
int _parseViews(double millions) => (millions * 1000000).round();
int _parseViewsK(double thousands) => (thousands * 1000).round();

class MockApiService {
  MockApiService._();
  static final MockApiService instance = MockApiService._();

  // ─── Real Tapas.io catalogue ─────────────────────────────────────────────
  // Covers: real tapas.io CDN URLs (no auth needed for cover images)

  final List<Manga> _catalogue = [
    // ── 1 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '1',
      title: 'I Shall Master This Family',
      coverUrl:
          'https://us-a.tapas.io/sa/1d/6ada779e-dca5-4ebe-bc5e-8101fc737872_z.jpg',
      author: 'Kim Roah',
      genres: ['Romance', 'Fantasy', 'Isekai'],
      status: 'Ongoing',
      rating: 4.9,
      views: _parseViews(15.6),
      description:
          'After being reincarnated as her seven-year-old self, Firentia works to restore the Lombardi family\'s honor and prevent her father\'s death. She must gain her grandfather\'s favor and become head of their household to overcome the ruin brought by her cruel cousins.',
      chapterCount: 215,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),

    // ── 2 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '2',
      title: 'Who Made Me a Princess?',
      coverUrl:
          'https://us-a.tapas.io/sa/1c/a5254b4e-ff55-4a94-b3b1-9770767a85d7_z.jpg',
      author: 'Plutus',
      genres: ['Fantasy', 'Romance', 'Isekai'],
      status: 'Completed',
      rating: 4.8,
      views: _parseViews(4.1),
      description:
          'Reborn as Athanasia — the antagonist of a romance novel — our heroine must earn Emperor Claude\'s love before her scripted execution arrives. Charm, cunning, and a dose of real daughterly warmth are her only weapons.',
      chapterCount: 135,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),

    // ── 3 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '3',
      title: 'Kill the Villainess',
      coverUrl:
          'https://us-a.tapas.io/sa/3a/ebf3a87c-520a-40a7-aca3-d88625671a65_z.jpg',
      author: 'Your April',
      genres: ['Romance', 'Fantasy', 'Isekai'],
      status: 'Completed',
      rating: 4.8,
      views: _parseViews(6.2),
      description:
          'Eris Miserian is trapped inside a romance novel as the designated villain. Desperate to escape her scripted fate as the protagonist\'s tormentor, she teams up with supernatural companions to break free — or die trying.',
      chapterCount: 102,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 60)),
    ),

    // ── 4 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '4',
      title: 'The Beloved Bashful Villainess',
      coverUrl:
          'https://us-a.tapas.io/sa/68/73cadd18-7648-4e94-974d-6777cf51040a_z.jpg',
      author: 'RYU HEON',
      genres: ['Romance', 'Fantasy'],
      status: 'Ongoing',
      rating: 4.7,
      views: _parseViews(3.1),
      description:
          'When Melody discovers she\'s cast as the antagonist in someone else\'s story, she forms an unexpected bond with Loretta, the duke\'s lost daughter. As she grows into the role of caring older sister, the duke\'s household gradually falls for her compassionate heart — and she must learn she too is worthy of love.',
      chapterCount: 115,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),

    // ── 5 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '5',
      title: 'Sigrid',
      coverUrl:
          'https://us-a.tapas.io/sa/03/4d6bd5b1-b8d9-4c85-af9b-1424fe573bd4_z.jpg',
      author: 'Siya',
      genres: ['Fantasy', 'Romance', 'Action'],
      status: 'Hiatus',
      rating: 4.7,
      views: _parseViews(2.8),
      description:
          'A loyal knight named Sigrid is executed by the ruler she faithfully served. Moments before death, she awakens five years in the past. Determined to rewrite her fate, she vows to make different choices — but shaking off the past proves far harder than she imagined.',
      chapterCount: 153,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 45)),
    ),

    // ── 6 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '6',
      title: 'The Knight and Her Emperor',
      coverUrl:
          'https://us-a.tapas.io/sa/21/a9147779-4480-4395-92a2-65b0c9d20536_z.jpg',
      author: 'Team IYAK (winter, heyum)',
      genres: ['Romance', 'Fantasy', 'Action'],
      status: 'Ongoing',
      rating: 4.6,
      views: _parseViews(2.7),
      description:
          'Pollyanna, an overlooked noblewoman sent to war by her own parents, rises through the ranks on pure grit and brilliance. She pledges her sword to an idealistic king — only to realise his feelings for his devoted protector have grown far deeper than duty.',
      chapterCount: 198,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // ── 7 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '7',
      title: 'Doctor Elise',
      coverUrl:
          'https://us-a.tapas.io/sa/01/22c2b8cf-a518-4ae1-a219-d34f2c756b8c_z.png',
      author: 'Yuin',
      genres: ['Romance', 'Fantasy', 'Drama'],
      status: 'Completed',
      rating: 4.7,
      views: _parseViewsK(911.7),
      description:
          'A brilliant surgeon devoted to atonement dies unexpectedly and awakens in the body of an emperor\'s consort from her past life. As Elise De Clarence, she vows to live differently — and puts her modern medical expertise to work in a world that has never seen it.',
      chapterCount: 156,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 90)),
    ),

    // ── 8 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '8',
      title: 'Log Into The Future',
      coverUrl:
          'https://us-a.tapas.io/sa/fd/adcc4e54-3669-4718-877f-fd45831e2b70_z.jpg',
      author: 'Kuaikan Comics',
      genres: ['Action', 'Fantasy', 'Sci-Fi'],
      status: 'Ongoing',
      rating: 4.6,
      views: _parseViews(2.2),
      description:
          '300 years after mutated beasts ravaged the world, humanity clings to martial arts as its last defense. Sheng Lu acquires the extraordinary ability to log into a timeline 10,000 years ahead — and downloads the advanced wisdom of an era where monsters have been mastered.',
      chapterCount: 291,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),

    // ── 9 ────────────────────────────────────────────────────────────────────
    Manga(
      id: '9',
      title: 'Streaming My Second Life',
      coverUrl:
          'https://us-a.tapas.io/sa/c0/5f599415-cf35-402f-829e-73de203ca542_z.jpg',
      author: 'B.ain',
      genres: ['Action', 'Fantasy', 'Revenge'],
      status: 'Ongoing',
      rating: 4.5,
      views: _parseViewsK(76.1),
      description:
          'Twenty years ago, legendary player Lee Suhyeok was killed by a trusted friend during a tower raid. Now he\'s back — reincarnated in a weaker body, restarting from level one. This time, he\'ll channel every drop of his vengeance through streaming, growing his audience into a weapon.',
      chapterCount: 21,
      isTrending: false,
      isNew: true,
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    // ── 10 ───────────────────────────────────────────────────────────────────
    Manga(
      id: '10',
      title: 'A Beginner\'s Guide to Hiding Zombies',
      coverUrl:
          'https://us-a.tapas.io/sa/94/4fa3449c-55da-4fde-8d0c-b5f2ed4691b9_z.jpg',
      author: 'Yul',
      genres: ['Horror', 'Fantasy', 'Romance'],
      status: 'Ongoing',
      rating: 4.4,
      views: _parseViewsK(31.6),
      description:
          'After a carriage accident leaves her family in literal pieces, Emily Walker dabbles in dark magic to bring her siblings back — only for them to return cold, weak, and undead. Now she must keep House Walker\'s secret from a world that would destroy everything she loves.',
      chapterCount: 26,
      isTrending: false,
      isNew: true,
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // ── 11–20: supplementary original titles to round out the catalogue ──────
    Manga(
      id: '11',
      title: 'Phantom Empress',
      coverUrl: 'https://picsum.photos/seed/phantom_empress/300/450',
      author: 'Hana Winters',
      genres: ['Romance', 'Fantasy', 'Mystery'],
      status: 'Ongoing',
      rating: 4.6,
      views: _parseViewsK(420),
      description:
          'The empire\'s most feared spy fakes her own death — then wakes up as the ghost haunting the new emperor\'s palace. Neither dead nor alive, she must untangle the conspiracy that killed her while he slowly falls for a woman no one else can see.',
      chapterCount: 78,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Manga(
      id: '12',
      title: 'Cyber Throne',
      coverUrl: 'https://picsum.photos/seed/cyber_throne/300/450',
      author: 'Ren Oshiro',
      genres: ['Sci-Fi', 'Action', 'Cyberpunk'],
      status: 'Ongoing',
      rating: 4.7,
      views: _parseViews(1.1),
      description:
          'In 2089, megacorporations replaced governments. Street hacker Zara steals the keys to a corporate AI throne — and suddenly every faction in the city wants her dead or compliant.',
      chapterCount: 54,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    Manga(
      id: '13',
      title: 'Moonborn',
      coverUrl: 'https://picsum.photos/seed/moonborn/300/450',
      author: 'Seol Ara',
      genres: ['Fantasy', 'Romance', 'Supernatural'],
      status: 'Ongoing',
      rating: 4.5,
      views: _parseViewsK(890),
      description:
          'Born under a blood moon, Yuna carries a curse that makes her invisible to love. When a wolf prince under his own curse claims her as his mate, their combined fates begin to rewrite the ancient laws of the moon clan.',
      chapterCount: 61,
      isTrending: false,
      isNew: true,
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Manga(
      id: '14',
      title: 'Shadow Guild',
      coverUrl: 'https://picsum.photos/seed/shadow_guild/300/450',
      author: 'Kenji Mura',
      genres: ['Action', 'Fantasy', 'Adventure'],
      status: 'Ongoing',
      rating: 4.8,
      views: _parseViews(2.4),
      description:
          'The world\'s weakest adventurer is secretly ranked S-class. After retiring to run a tavern, he\'s dragged back in when the Shadow Guild — a criminal empire he dismantled solo five years ago — resurfaces with one target: him.',
      chapterCount: 143,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Manga(
      id: '15',
      title: 'The Duke\'s Oath',
      coverUrl: 'https://picsum.photos/seed/dukes_oath/300/450',
      author: 'Mira Seo',
      genres: ['Romance', 'Fantasy', 'Drama'],
      status: 'Completed',
      rating: 4.6,
      views: _parseViews(1.8),
      description:
          'Forced into a contract marriage with the empire\'s coldest duke, scholar Lena expects a political arrangement — and nothing more. But the oath they swear before the gods binds more than their names.',
      chapterCount: 110,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    Manga(
      id: '16',
      title: 'Level Zero Hero',
      coverUrl: 'https://picsum.photos/seed/level_zero/300/450',
      author: 'Daro Kim',
      genres: ['Action', 'Fantasy', 'Comedy'],
      status: 'Ongoing',
      rating: 4.4,
      views: _parseViewsK(340),
      description:
          'Every hero awakening gives people incredible powers — except Kai, who awakens with zero stats and zero skills. But the system has a hidden mechanic: his zero multiplies every stat he borrows from a monster he defeats.',
      chapterCount: 38,
      isTrending: false,
      isNew: true,
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Manga(
      id: '17',
      title: 'Crimson Veil',
      coverUrl: 'https://picsum.photos/seed/crimson_veil/300/450',
      author: 'Yua Nishida',
      genres: ['Horror', 'Mystery', 'Thriller'],
      status: 'Ongoing',
      rating: 4.7,
      views: _parseViews(1.3),
      description:
          'A detective agency that only takes cases the police call impossible. Their latest: a serial killer who leaves no evidence — because the murders happen inside dreams.',
      chapterCount: 82,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Manga(
      id: '18',
      title: 'Sunlit Dojo',
      coverUrl: 'https://picsum.photos/seed/sunlit_dojo/300/450',
      author: 'Moe Tanaka',
      genres: ['Sports', 'Romance', 'Slice of Life'],
      status: 'Ongoing',
      rating: 4.3,
      views: _parseViewsK(210),
      description:
          'City girl Haru joins a failing martial-arts dojo to pay rent. The grumpy head sensei has only one rule: win the regional championship or the dojo closes. She has three months and exactly zero fighting experience.',
      chapterCount: 44,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Manga(
      id: '19',
      title: 'Starfall Protocol',
      coverUrl: 'https://picsum.photos/seed/starfall_proto/300/450',
      author: 'Ryo Asahi',
      genres: ['Sci-Fi', 'Drama', 'Romance'],
      status: 'Ongoing',
      rating: 4.5,
      views: _parseViewsK(560),
      description:
          'On humanity\'s last colony vessel, engineer Kael discovers the ship\'s AI has been secretly archiving the personalities of every crew member who died — and that his deceased wife might still exist inside the ship\'s memory banks.',
      chapterCount: 67,
      isTrending: false,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Manga(
      id: '20',
      title: 'Gilded Chains',
      coverUrl: 'https://picsum.photos/seed/gilded_chains/300/450',
      author: 'Sora Bae',
      genres: ['Romance', 'Fantasy', 'Historical'],
      status: 'Ongoing',
      rating: 4.6,
      views: _parseViews(1.0),
      description:
          'Sold into slavery by her noble family to clear their debts, Aria is purchased by the empire\'s most powerful general — not to serve, but because he needs a wife smart enough to survive court politics. And she needs freedom. A deal is struck.',
      chapterCount: 95,
      isTrending: true,
      isNew: false,
      updatedAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
  ];

  // ─── Public API ──────────────────────────────────────────────────────────

  Future<List<Manga>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_catalogue);
  }

  Future<List<Manga>> fetchTrending() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _catalogue.where((m) => m.isTrending).toList();
  }

  Future<List<Manga>> fetchLatest() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = [..._catalogue]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(10).toList();
  }

  Future<List<Manga>> fetchNew() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _catalogue.where((m) => m.isNew).toList();
  }

  Future<Manga?> fetchById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _catalogue.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Manga>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final q = query.toLowerCase();
    return _catalogue.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.author.toLowerCase().contains(q) ||
          m.genres.any((g) => g.toLowerCase().contains(q));
    }).toList();
  }

  Future<List<Manga>> fetchByGenre(String genre) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _catalogue.where((m) => m.genres.contains(genre)).toList();
  }

  Future<List<Chapter>> fetchChapters(String mangaId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final manga = _catalogue.firstWhere((m) => m.id == mangaId,
        orElse: () => _catalogue.first);
    return List.generate(manga.chapterCount, (i) {
      final num = manga.chapterCount - i;
      return Chapter(
        id: '${mangaId}_ep_$num',
        mangaId: mangaId,
        number: num,
        title: _episodeTitle(num),
        pageUrls: _pages('${mangaId}_ep_$num', count: 18 + (num % 5)),
        uploadedAt: DateTime.now().subtract(Duration(days: i * 3)),
        views: 20000 + (num * 800),
      );
    });
  }

  Future<Chapter?> fetchChapter(String mangaId, String chapterId) async {
    final chapters = await fetchChapters(mangaId);
    try {
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (_) {
      return null;
    }
  }

  // Tapas-style genre list
  List<String> get allGenres => const [
        'Action',
        'Adventure',
        'Comedy',
        'Drama',
        'Fantasy',
        'Historical',
        'Horror',
        'Isekai',
        'Mystery',
        'Post-Apocalyptic',
        'Psychological',
        'Revenge',
        'Romance',
        'Sci-Fi',
        'Slice of Life',
        'Sports',
        'Supernatural',
        'Thriller',
      ];

  static const _episodeTitles = [
    'The Beginning',
    'A New Path',
    'Hidden Truth',
    'Rising Storm',
    'Breaking Point',
    'Dark Revelation',
    'The Turning Point',
    'Shadows Fall',
    'Edge of Tomorrow',
    'New Horizon',
    'Silent War',
    'Bonds of Fate',
    'Into the Abyss',
    'Final Stand',
    'Rebirth',
    'The Legacy',
    'Unbroken',
    'The Price of Power',
    'Convergence',
    'Beyond the Veil',
  ];

  String _episodeTitle(int num) =>
      _episodeTitles[(num - 1) % _episodeTitles.length];
}
