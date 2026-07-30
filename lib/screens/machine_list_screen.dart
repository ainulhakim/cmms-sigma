import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machine_provider.dart';
import '../config/theme.dart';
import '../models/machine_model.dart';

class MachineListScreen extends StatefulWidget {
  const MachineListScreen({super.key});

  @override
  State<MachineListScreen> createState() => _MachineListScreenState();
}

class _MachineListScreenState extends State<MachineListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MachineProvider>().loadMachines();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mesin'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari mesin...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          context.read<MachineProvider>().setSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                context.read<MachineProvider>().setSearchQuery(value);
                setState(() {}); // rebuild for clear button
              },
            ),
          ),

          // Machine List
          Expanded(
            child: Consumer<MachineProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.allMachines.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.allMachines.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48,
                            color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => provider.loadMachines(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final machines = provider.machines;

                if (machines.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'Mesin tidak ditemukan'
                              : 'Belum ada data mesin',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadMachines(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: machines.length,
                    itemBuilder: (context, index) {
                      return _MachineCard(machine: machines[index]);
                    },
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

class _MachineCard extends StatelessWidget {
  final MachineModel machine;

  const _MachineCard({required this.machine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = AppTheme.getStatusColor(machine.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/machine-detail',
            arguments: machine.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Machine icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.precision_manufacturing_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Machine info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      machine.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          machine.code,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.forklift_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          machine.line,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Status badge
              Chip(
                label: Text(
                  AppTheme.getStatusLabel(machine.status),
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: statusColor.withOpacity(0.1),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
