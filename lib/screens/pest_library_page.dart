import 'package:flutter/material.dart';
import 'pest_library.dart';
import 'pest_repository.dart';

class PestLibraryPage extends StatefulWidget {
  const PestLibraryPage({super.key});

  @override
  State<PestLibraryPage> createState() => _PestLibraryPageState();
}

class _PestLibraryPageState extends State<PestLibraryPage> {
  String _searchQuery = '';
  String _selectedType = 'All';
  String _selectedSeverity = 'All';
  String _selectedCategory = 'All';

  List<Pest> get _filteredPests {
    var pests = PestRepository.getPests();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      pests = pests.where((pest) =>
      pest.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pest.scientificName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pest.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by type
    if (_selectedType != 'All') {
      pests = pests.where((pest) => pest.type == _selectedType).toList();
    }

    // Filter by severity
    if (_selectedSeverity != 'All') {
      pests = pests.where((pest) => pest.severity == _selectedSeverity).toList();
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      pests = pests.where((pest) => pest.category == _selectedCategory).toList();
    }

    return pests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Library'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PestSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pests...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'All',
                    selected: _selectedType == 'All',
                    onSelected: () {
                      setState(() {
                        _selectedType = 'All';
                      });
                    },
                  ),
                  _buildFilterChip(
                    label: 'Insects',
                    selected: _selectedType == 'insect',
                    onSelected: () {
                      setState(() {
                        _selectedType = 'insect';
                      });
                    },
                  ),
                  _buildFilterChip(
                    label: 'Mites',
                    selected: _selectedType == 'mite',
                    onSelected: () {
                      setState(() {
                        _selectedType = 'mite';
                      });
                    },
                  ),
                  _buildFilterChip(
                    label: 'Fungal',
                    selected: _selectedType == 'fungal',
                    onSelected: () {
                      setState(() {
                        _selectedType = 'fungal';
                      });
                    },
                  ),
                  _buildFilterChip(
                    label: 'Healthy',
                    selected: _selectedType == 'healthy',
                    onSelected: () {
                      setState(() {
                        _selectedType = 'healthy';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Critical',
                    selected: _selectedSeverity == 'Critical',
                    onSelected: () {
                      setState(() {
                        _selectedSeverity = 'Critical';
                      });
                    },
                    color: Colors.deepOrange,
                  ),
                  _buildFilterChip(
                    label: 'High',
                    selected: _selectedSeverity == 'High',
                    onSelected: () {
                      setState(() {
                        _selectedSeverity = 'High';
                      });
                    },
                    color: Colors.red,
                  ),
                  _buildFilterChip(
                    label: 'Medium',
                    selected: _selectedSeverity == 'Medium',
                    onSelected: () {
                      setState(() {
                        _selectedSeverity = 'Medium';
                      });
                    },
                    color: Colors.orange,
                  ),
                  _buildFilterChip(
                    label: 'Low',
                    selected: _selectedSeverity == 'Low',
                    onSelected: () {
                      setState(() {
                        _selectedSeverity = 'Low';
                      });
                    },
                    color: Colors.yellow.shade700,
                  ),
                ],
              ),
            ),
          ),

          // Results count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Found ${_filteredPests.length} pests',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          // Pest list
          Expanded(
            child: _filteredPests.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No pests found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredPests.length,
              itemBuilder: (context, index) {
                final pest = _filteredPests[index];
                return _buildPestCard(pest);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        backgroundColor: Colors.white,
        selectedColor: color?.withOpacity(0.2) ?? Colors.green.shade100,
        checkmarkColor: color ?? Colors.green.shade800,
        onSelected: (_) => onSelected(),
        labelStyle: TextStyle(
          color: selected ? (color ?? Colors.green.shade800) : Colors.grey.shade700,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPestCard(Pest pest) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PestDetailPage(pest: pest),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: pest.getTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    pest.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pest.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pest.scientificName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: pest.getTypeColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pest.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: pest.getTypeColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: pest.getSeverityColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                pest.getSeverityIcon(),
                                size: 12,
                                color: pest.getSeverityColor(),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                pest.severity,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: pest.getSeverityColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pest Search Delegate
class PestSearchDelegate extends SearchDelegate<Pest?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = PestRepository.searchPests(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final pest = results[index];
        return ListTile(
          leading: Text(pest.icon, style: const TextStyle(fontSize: 28)),
          title: Text(pest.name),
          subtitle: Text(pest.scientificName),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: pest.getSeverityColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              pest.severity,
              style: TextStyle(
                color: pest.getSeverityColor(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PestDetailPage(pest: pest),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = PestRepository.searchPests(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final pest = results[index];
        return ListTile(
          leading: Text(pest.icon, style: const TextStyle(fontSize: 28)),
          title: Text(pest.name),
          subtitle: Text(pest.scientificName),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PestDetailPage(pest: pest),
              ),
            );
          },
        );
      },
    );
  }
}

// Pest Detail Page
class PestDetailPage extends StatelessWidget {
  final Pest pest;

  const PestDetailPage({super.key, required this.pest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pest.name),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: pest.getTypeColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pest.getTypeColor().withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Text(pest.icon, style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pest.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          pest.scientificName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: pest.getTypeColor().withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                pest.category,
                                style: TextStyle(
                                  color: pest.getTypeColor(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: pest.getSeverityColor().withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    pest.getSeverityIcon(),
                                    size: 14,
                                    color: pest.getSeverityColor(),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Severity: ${pest.severity}',
                                    style: TextStyle(
                                      color: pest.getSeverityColor(),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            _buildSection(
              title: '📝 Description',
              content: pest.description,
            ),
            const SizedBox(height: 16),

            // Affected Parts
            _buildSection(
              title: '🎯 Affected Parts',
              content: pest.affectedParts.join(', '),
            ),
            const SizedBox(height: 16),

            // Symptoms
            _buildSection(
              title: '⚠️ Symptoms',
              content: '',
              isList: true,
              items: pest.symptoms,
            ),
            const SizedBox(height: 16),

            // Seasonal Activity
            _buildSection(
              title: '📅 Seasonal Activity',
              content: pest.seasonalActivity,
            ),
            const SizedBox(height: 16),

            // Favorable Conditions
            if (pest.favorableConditions.isNotEmpty)
              _buildSection(
                title: '🌡️ Favorable Conditions',
                content: '',
                isList: true,
                items: pest.favorableConditions,
              ),
            const SizedBox(height: 16),

            // Remedies
            const Text(
              '🛠️ Remedies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              pest.remedies.length,
                  (index) => _buildRemedyCard(pest.remedies[index]),
            ),
            const SizedBox(height: 16),

            // Prevention
            _buildSection(
              title: '🌱 Prevention',
              content: pest.prevention,
            ),
            const SizedBox(height: 16),

            // Similar Pests
            if (pest.similarPests.isNotEmpty)
              _buildSection(
                title: '🔍 Similar Pests',
                content: '',
                isList: true,
                items: pest.similarPests,
              ),
            const SizedBox(height: 16),

            // Organic status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: pest.isOrganic ? Colors.green.shade50 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: pest.isOrganic ? Colors.green.shade200 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    pest.isOrganic ? Icons.eco : Icons.science,
                    color: pest.isOrganic ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pest.isOrganic
                          ? '🌿 This pest can be managed with organic methods'
                          : '🧪 Chemical intervention may be needed for this pest',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    bool isList = false,
    List<String>? items,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          if (isList && items != null)
            ...List.generate(
              items.length,
                  (index) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(items[index])),
                  ],
                ),
              ),
            )
          else
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
        ],
      ),
    );
  }

  Widget _buildRemedyCard(Remedy remedy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  remedy.getTypeIcon(),
                  color: remedy.getTypeColor(),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    remedy.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (remedy.effectiveness != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${remedy.effectiveness}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: remedy.getTypeColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                remedy.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: remedy.getTypeColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              remedy.steps.length,
                  (index) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        remedy.steps[index],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (remedy.frequency != null || remedy.duration != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    if (remedy.frequency != null)
                      Row(
                        children: [
                          const Text(
                            'Frequency: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(remedy.frequency!),
                        ],
                      ),
                    if (remedy.duration != null)
                      Row(
                        children: [
                          const Text(
                            'Duration: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(remedy.duration!),
                        ],
                      ),
                  ],
                ),
              ),
            ],
            if (remedy.precautions != null && remedy.precautions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Precautions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...List.generate(
                      remedy.precautions!.length,
                          (index) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(remedy.precautions![index])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}