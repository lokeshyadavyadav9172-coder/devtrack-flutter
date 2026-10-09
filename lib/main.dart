import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DevTrackApp());
}

class DevTrackApp extends StatelessWidget {
  const DevTrackApp({super.key});

  static const primary = Color(0xFF635BFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevTrack',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Arial',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final projects = const [
    ProjectData(
      name: 'PlanMyHome AI',
      description: 'AI-powered real estate assistant',
      progress: 0.84,
      tech: 'Flutter • FastAPI',
      icon: Icons.home_work_outlined,
    ),
    ProjectData(
      name: 'DevTrack',
      description: 'Developer productivity platform',
      progress: 0.52,
      tech: 'Flutter • Dart',
      icon: Icons.code_rounded,
    ),
    ProjectData(
      name: 'BrandPulse',
      description: 'AI market intelligence platform',
      progress: 0.67,
      tech: 'Next.js • AI',
      icon: Icons.insights_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 800;

          if (mobile) {
            return _buildMobileLayout();
          }

          return Row(
            children: [
              _Sidebar(
                selectedIndex: selectedIndex,
                onChanged: (index) {
                  setState(() => selectedIndex = index);
                },
              ),
              Expanded(child: SafeArea(child: _buildContent())),
            ],
          );
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 800
          ? NavigationBar(
              selectedIndex: selectedIndex > 4 ? 0 : selectedIndex,
              onDestinationSelected: (index) {
                setState(() => selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_outlined),
                  selectedIcon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Stats',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(child: _buildContent());
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 1:
        return ProjectsScreen(projects: projects);
      case 2:
        return const TasksScreen();
      case 3:
        return const AnalyticsScreen();
      case 4:
        return const SettingsScreen();
      default:
        return _Dashboard(projects: projects);
    }
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _Sidebar({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE8EAF0))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DevTrackApp.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.code_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'DevTrack',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _navItem(Icons.dashboard_rounded, 'Dashboard', 0),
          _navItem(Icons.folder_outlined, 'Projects', 1),
          _navItem(Icons.check_circle_outline, 'Tasks', 2),
          _navItem(Icons.bar_chart_rounded, 'Analytics', 3),
          const Spacer(),
          _navItem(Icons.settings_outlined, 'Settings', 4),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF0EEFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected ? DevTrackApp.primary : const Color(0xFF74788A),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? DevTrackApp.primary
                      : const Color(0xFF55596A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final List<ProjectData> projects;

  const _Dashboard({required this.projects});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(mobile ? 18 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 28),
          Text(
            'Good morning, Developer 👋',
            style: TextStyle(
              fontSize: mobile ? 25 : 30,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF171923),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Here is what is happening with your development work.',
            style: TextStyle(color: Color(0xFF74788A), fontSize: 14),
          ),
          const SizedBox(height: 24),

          if (mobile)
            const Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Projects',
                        value: '12',
                        change: '+3 this month',
                        icon: Icons.folder_copy_outlined,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Tasks',
                        value: '84',
                        change: '+18 this week',
                        icon: Icons.task_alt_rounded,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Bugs',
                        value: '7',
                        change: '2 critical',
                        icon: Icons.bug_report_outlined,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Productivity',
                        value: '86%',
                        change: '+12% this month',
                        icon: Icons.bolt_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Projects',
                    value: '12',
                    change: '+3 this month',
                    icon: Icons.folder_copy_outlined,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Completed Tasks',
                    value: '84',
                    change: '+18 this week',
                    icon: Icons.task_alt_rounded,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Open Bugs',
                    value: '7',
                    change: '2 critical',
                    icon: Icons.bug_report_outlined,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Productivity',
                    value: '86%',
                    change: '+12% this month',
                    icon: Icons.bolt_rounded,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),

          if (mobile)
            Column(
              children: [
                _ProjectsCard(projects: projects),
                const SizedBox(height: 18),
                const _ActivityCard(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _ProjectsCard(projects: projects)),
                const SizedBox(width: 20),
                const Expanded(flex: 2, child: _ActivityCard()),
              ],
            ),

          const SizedBox(height: 24),
          const _ProgressCard(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EF)),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, size: 20),
              SizedBox(width: 8),
              Text('Search'),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 20,
          backgroundColor: DevTrackApp.primary,
          child: Text(
            'D',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DevTrackApp.primary, size: 21),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF74788A), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsCard extends StatelessWidget {
  final List<ProjectData> projects;

  const _ProjectsCard({required this.projects});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Active Projects',
      action: 'View all',
      child: Column(
        children: projects
            .map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _ProjectRow(project: project),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ProjectData project;

  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(project.icon, color: DevTrackApp.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                project.tech,
                style: const TextStyle(fontSize: 11, color: Color(0xFF8A8EA0)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(project.progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: project.progress,
                minHeight: 5,
                borderRadius: BorderRadius.circular(20),
                backgroundColor: const Color(0xFFE9EAF1),
                color: DevTrackApp.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Recent Activity',
      action: 'View all',
      child: Column(
        children: [
          _activity(
            Icons.check_circle,
            'Completed authentication',
            '2 hours ago',
          ),
          _activity(Icons.commit_rounded, 'Pushed 4 commits', '5 hours ago'),
          _activity(Icons.bug_report, 'Fixed API validation', 'Yesterday'),
          _activity(
            Icons.add_circle_outline,
            'Created new project',
            'Yesterday',
          ),
        ],
      ),
    );
  }

  Widget _activity(IconData icon, String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: DevTrackApp.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9094A4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Weekly Activity',
      action: 'Last 7 days',
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            titlesData: const FlTitlesData(
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 2),
                  FlSpot(1, 4),
                  FlSpot(2, 3),
                  FlSpot(3, 6),
                  FlSpot(4, 5),
                  FlSpot(5, 8),
                  FlSpot(6, 7),
                ],
                isCurved: true,
                barWidth: 4,
                color: DevTrackApp.primary,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0x20635BFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String action;
  final Widget child;

  const _Card({required this.title, required this.action, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                action,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: DevTrackApp.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class ProjectsScreen extends StatelessWidget {
  final List<ProjectData> projects;

  const ProjectsScreen({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: EdgeInsets.all(mobile ? 18 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Projects',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage and track your development projects.',
            style: TextStyle(color: Color(0xFF74788A)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 380,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: mobile ? 1.15 : 1.5,
              ),
              itemCount: projects.length,
              itemBuilder: (_, index) {
                final project = projects[index];

                return _Card(
                  title: project.name,
                  action: '${(project.progress * 100).round()}%',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.description,
                        style: const TextStyle(color: Color(0xFF74788A)),
                      ),
                      const Spacer(),
                      Text(
                        project.tech,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: project.progress,
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: const Color(0xFFE9EAF1),
                        color: DevTrackApp.primary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ('Implement authentication', 'High', true),
      ('Create project dashboard', 'High', true),
      ('Connect GitHub API', 'Medium', false),
      ('Add analytics screen', 'Medium', false),
      ('Write widget tests', 'Low', false),
    ];

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tasks',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final task = tasks[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8EAF0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        task.$3
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.$3
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF9A9EAE),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.$1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: task.$3
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EEFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.$2,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: DevTrackApp.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Track your development performance.',
            style: TextStyle(color: Color(0xFF74788A)),
          ),
          SizedBox(height: 24),
          Expanded(child: _ProgressCard()),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),
        _Card(
          title: 'Application',
          action: '',
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                subtitle: const Text('Manage your developer profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none),
                title: const Text('Notifications'),
                subtitle: const Text('Configure your notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Appearance'),
                subtitle: const Text('Customize DevTrack appearance'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProjectData {
  final String name;
  final String description;
  final double progress;
  final String tech;
  final IconData icon;

  const ProjectData({
    required this.name,
    required this.description,
    required this.progress,
    required this.tech,
    required this.icon,
  });
}
