import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:music_app/core/theme/theme_provider.dart';
import 'package:music_app/features/profile/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late VideoPlayerController _videoController;

  final List<Widget> _screens = [
    const _HomeContent(),
    const ServicesPreview(),
    const OffersSection(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/banner_home.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.play();
        _videoController.setVolume(0); // Mute por defecto
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.music, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text('BarberMusic', style: TextStyle(color: colorScheme.primary)),
            Text('&Spa', style: TextStyle(color: colorScheme.onSurface)),
          ],
        ),
        backgroundColor: isDarkMode ? Colors.black : colorScheme.surface,
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('3'),
              child: Icon(Icons.notifications, color: colorScheme.primary),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Badge(
              label: const Text('1'),
              child: Icon(Icons.shopping_cart, color: colorScheme.primary),
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context, listen: true).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final provider = Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(provider.themeMode != ThemeMode.dark);
            },
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: isDarkMode ? Colors.black : colorScheme.surface,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.cut_outlined),
            selectedIcon: Icon(Icons.cut),
            label: 'Servicios',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'Promos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: const AssetImage('assets/logo.png'),
                  backgroundColor: colorScheme.primary,
                ),
                const SizedBox(height: 10),
                Text('¡Bienvenido!',
                    style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 18)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Inicio', () => setState(() => _currentIndex = 0)),
          _buildDrawerItem(Icons.cut, 'Servicios', () => setState(() => _currentIndex = 1)),
          _buildDrawerItem(Icons.local_offer, 'Promociones', () => setState(() => _currentIndex = 2)),
          _buildDrawerItem(Icons.person, 'Mi Perfil', () => setState(() => _currentIndex = 3)),
          const Divider(),
          _buildDrawerItem(Icons.login, 'Iniciar Sesión',
                  () => Navigator.pushNamed(context, '/login')),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                const Text('Modo Oscuro'),
                const Spacer(),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(value);
                  },
                  activeColor: colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      onTap: onTap,
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  __HomeContentState createState() => __HomeContentState();
}

class __HomeContentState extends State<_HomeContent> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/banner_home.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
          _videoController.setVolume(0);
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : Container(
              color: colorScheme.surfaceVariant,
              child: Center(
                  child: CircularProgressIndicator(
                      color: colorScheme.primary)),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido a BarberMusic&Spa',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Somos un centro de spa estético y barbería en México. '
                        'Disfruta de una experiencia única con nuestros servicios profesionales.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildActionChip(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Reservar',
                        onTap: () => Navigator.pushNamed(context, '/services'),
                      ),
                      _buildActionChip(
                        context,
                        icon: Icons.local_offer,
                        label: 'Promociones',
                        onTap: () {},
                      ),
                      _buildActionChip(
                        context,
                        icon: Icons.map,
                        label: 'Ubicación',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Servicios Destacados',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                final services = [
                  {'title': 'Corte Premium', 'price': '\$300', 'icon': Icons.cut},
                  {'title': 'Masaje Completo', 'price': '\$450', 'icon': Icons.spa},
                  {'title': 'Tratamiento Facial', 'price': '\$350', 'icon': Icons.face},
                ];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildServiceCard(
                    context,
                    services[index]['title'] as String,
                    services[index]['price'] as String,
                    services[index]['icon'] as IconData,
                  ),
                );
              },
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }

  Widget _buildActionChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer),
    );
  }

  Widget _buildServiceCard(
      BuildContext context, String title, String price, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(price,
                style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Widgets adicionales
class ServicesPreview extends StatelessWidget {
  const ServicesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Vista previa de servicios'));
  }
}

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Sección de promociones'));
  }
}