import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bloc/admin_bloc.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final _sections = [
    'Dashboard',
    'Module Manager',
    'User Management',
    'Permission Matrix',
    'Audit Logs',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadAdminConfig());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Admin Control Center',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: Row(
        children: [
          // Side navigation
          Container(
            width: 220,
            color: const Color(0xFF16213E),
            child: Column(
              children: List.generate(_sections.length, (index) {
                final icons = [
                  Icons.dashboard,
                  Icons.widgets,
                  Icons.people,
                  Icons.security,
                  Icons.history,
                ];
                return Material(
                  color: _selectedIndex == index
                      ? const Color(0xFF0F3460)
                      : Colors.transparent,
                  child: ListTile(
                    leading: Icon(icons[index],
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.white54),
                    title: Text(_sections[index],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.white54,
                        )),
                    onTap: () => setState(() => _selectedIndex = index),
                  ),
                );
              }),
            ),
          ),
          // Content area
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildModuleManager();
      case 2:
        return _buildUserManagement();
      case 3:
        return _buildPermissionMatrix();
      case 4:
        return _buildAuditLogs();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdminConfigLoaded) {
          final config = state.config;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('System Overview',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildMetricCard('Active Modules',
                        '${config?.modules.length ?? 0}', Icons.widgets, Colors.blue),
                    const SizedBox(width: 16),
                    _buildMetricCard('Business Rules',
                        '${config?.businessRules.length ?? 0}', Icons.rule, Colors.green),
                    const SizedBox(width: 16),
                    _buildMetricCard('System', 'Online', Icons.cloud_done, Colors.cyan),
                  ],
                ),
                const SizedBox(height: 24),
                if (config != null) ...[
                  Text('Module Status',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: config.modules.entries.length,
                      itemBuilder: (context, index) {
                        final entry = config.modules.entries.elementAt(index);
                        return _buildModuleStatusTile(
                            entry.key, entry.value.enabled, entry.value.features);
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        if (state is AdminConfigError) {
          return Center(
            child: Text(state.message,
                style: GoogleFonts.poppins(color: Colors.redAccent)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleStatusTile(
      String name, bool enabled, Map<String, dynamic> features) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Text(name[0].toUpperCase() + name.substring(1),
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          const Spacer(),
          Text(enabled ? 'Enabled' : 'Disabled',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: enabled ? Colors.greenAccent : Colors.redAccent)),
        ],
      ),
    );
  }

  Widget _buildModuleManager() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminConfigLoaded) {
          final config = state.config;
          if (config == null) {
            return Center(
                child: Text('No configuration loaded',
                    style: GoogleFonts.poppins(color: Colors.white70)));
          }
          final modules = config.modules.entries.toList();
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Module Manager',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text('Enable or disable features dynamically',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.white54)),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      final entry = modules[index];
                      final features = entry.value.features;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16213E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    entry.key[0].toUpperCase() +
                                        entry.key.substring(1),
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                const Spacer(),
                                Switch(
                                  value: entry.value.enabled,
                                  activeColor: const Color(0xFF0F3460),
                                  onChanged: (value) {
                                    context.read<AdminBloc>().add(ToggleModule(
                                          module: entry.key,
                                          enabled: value,
                                          features: features,
                                        ));
                                  },
                                ),
                              ],
                            ),
                            if (features.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: features.entries.map((f) {
                                  return Chip(
                                    label: Text(
                                        '${f.key}: ${f.value}',
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.white70)),
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.05),
                                    side: BorderSide.none,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  );
                                }).toList(),
                              ),
                            ],
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildUserManagement() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('User Management',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text('Click "Load Users" to fetch user data',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AdminBloc>().add(const LoadUsers());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Load Users'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is UsersLoaded) {
                  final users = state.users;
                  if (users.isEmpty) {
                    return Text('No users found',
                        style: GoogleFonts.poppins(color: Colors.white54));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final role = user['role'] as String? ?? 'viewer';
                      final banned = user['banned'] as bool? ?? false;
                      final email = user['email'] as String? ?? 'No email';
                      final name = user['displayName'] as String? ?? email;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16213E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF0F3460),
                              child: Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                  Text(email,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: Colors.white54)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (banned ? Colors.red : Colors.green)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(role,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: banned ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionMatrix() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permission Matrix',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text('Role-based access control overview',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      WidgetStateProperty.all(const Color(0xFF16213E)),
                  dataRowColor:
                      WidgetStateProperty.all(const Color(0xFF1A1A2E)),
                  columns: [
                    const DataColumn(label: Text('Role',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('Level',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('Products',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('Orders',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('Payments',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('Admin',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('HR',
                        style: TextStyle(color: Colors.white))),
                    const DataColumn(label: Text('Reports',
                        style: TextStyle(color: Colors.white))),
                  ],
                  rows: [
                    _buildRoleRow('Super Admin', 'P0', 'Full', 'Full', 'Full', 'Full', 'Full', 'Full'),
                    _buildRoleRow('Admin', 'P1', 'Full', 'Full', 'Full', 'Full', 'Full', 'Full'),
                    _buildRoleRow('Supervisor', 'P2', 'Edit', 'Approve', 'Process', 'No', 'View', 'Create'),
                    _buildRoleRow('Accountant', 'P3', 'View', 'Refund', 'Process', 'No', 'Payroll', 'Export'),
                    _buildRoleRow('Data Entry', 'P4', 'Edit', 'Create', 'View', 'No', 'No', 'View'),
                    _buildRoleRow('Viewer', 'P5', 'View', 'View', 'View', 'No', 'View', 'View'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRoleRow(String role, String level, String products,
      String orders, String payments, String admin, String hr, String reports) {
    return DataRow(cells: [
      DataCell(Text(role,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white))),
      DataCell(Text(level,
          style:
              GoogleFonts.poppins(fontSize: 12, color: Colors.white54))),
      DataCell(_buildPermissionChip(products)),
      DataCell(_buildPermissionChip(orders)),
      DataCell(_buildPermissionChip(payments)),
      DataCell(_buildPermissionChip(admin)),
      DataCell(_buildPermissionChip(hr)),
      DataCell(_buildPermissionChip(reports)),
    ]);
  }

  Widget _buildPermissionChip(String value) {
    final color = value == 'Full'
        ? Colors.green
        : value == 'No'
            ? Colors.red
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(value,
          style: TextStyle(fontSize: 11, color: color)),
    );
  }

  Widget _buildAuditLogs() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Audit Trail',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text('Track all changes made in the system',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AdminBloc>().add(const LoadAuditLogs());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Load Audit Logs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AuditLogsLoaded) {
                  final logs = state.logs;
                  if (logs.isEmpty) {
                    return Text('No audit logs found',
                        style: GoogleFonts.poppins(color: Colors.white54));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final action = log['action'] as String? ?? '';
                      final entityType = log['entityType'] as String? ?? '';
                      final userName = log['userName'] as String? ?? 'System';
                      final description =
                          log['description'] as String? ?? 'No description';
                      final timestamp = log['timestamp'] != null
                          ? (log['timestamp'] as Timestamp).toDate()
                          : null;

                      final actionColor = action == 'create'
                          ? Colors.green
                          : action == 'update'
                              ? Colors.orange
                              : action == 'delete'
                                  ? Colors.red
                                  : Colors.blue;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16213E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: actionColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(description,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(
                                      '$entityType • $userName${timestamp != null ? ' • ${_formatDate(timestamp)}' : ''}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.white38)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}