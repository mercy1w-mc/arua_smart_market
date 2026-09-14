import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/data/catalog_repository.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/brand_mark.dart';
import '../../../shared/widgets/section_heading.dart';

class FarmerShell extends StatefulWidget {
  const FarmerShell({super.key});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _selectedIndex = 0;

  Future<void> _openAddProduct() async {
    final draft = await showDialog<Product>(
      context: context,
      builder: (context) => const _AddProductDialog(),
    );
    if (draft == null || !mounted) return;
    await CatalogRepository.instance.createProduct(draft);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${draft.name} is now listed in the marketplace.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1000;
    final content = _selectedIndex == 0
        ? AnimatedBuilder(
            animation: CatalogRepository.instance,
            builder: (context, _) => _DashboardContent(
              products: CatalogRepository.instance.products,
              onAddProduct: _openAddProduct,
              onManageProducts: () => setState(() => _selectedIndex = 1),
            ),
          )
        : _FarmerPlaceholderTab(index: _selectedIndex);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              _FarmerRail(
                selectedIndex: _selectedIndex,
                onSelected: (index) => setState(() => _selectedIndex = index),
              ),
            Expanded(child: content),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Overview',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }
}

class _FarmerRail extends StatelessWidget {
  const _FarmerRail({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      padding: const EdgeInsets.fromLTRB(24, 28, 18, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandMark(),
          const SizedBox(height: 54),
          const Text(
            'FARM MANAGEMENT',
            style: TextStyle(
              color: AppColors.slate,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          _FarmerRailItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard_rounded,
            label: 'Overview',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _FarmerRailItem(
            icon: Icons.inventory_2_outlined,
            selectedIcon: Icons.inventory_2_rounded,
            label: 'Products',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _FarmerRailItem(
            icon: Icons.receipt_long_outlined,
            selectedIcon: Icons.receipt_long_rounded,
            label: 'Orders',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          _FarmerRailItem(
            icon: Icons.bar_chart_rounded,
            selectedIcon: Icons.bar_chart_rounded,
            label: 'Sales & earnings',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),
          const SizedBox(height: 26),
          const Text(
            'ACCOUNT',
            style: TextStyle(
              color: AppColors.slate,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          _FarmerRailItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Farm profile',
            selected: selectedIndex == 4,
            onTap: () => onSelected(4),
          ),
          _FarmerRailItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings_rounded,
            label: 'Settings',
            selected: selectedIndex == 5,
            onTap: () => onSelected(5),
          ),
          const Spacer(),
          const _FarmerProfileMini(),
        ],
      ),
    );
  }
}

class _FarmerRailItem extends StatelessWidget {
  const _FarmerRailItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: selected ? AppColors.mint : null,
        leading: Icon(
          selected ? selectedIcon : icon,
          color: selected ? AppColors.forest : AppColors.slate,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.forest : AppColors.ink,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.products,
    required this.onAddProduct,
    required this.onManageProducts,
  });

  final List<Product> products;
  final VoidCallback onAddProduct;
  final VoidCallback onManageProducts;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1000 ? 54.0 : 22.0;
    final isWide = width >= 760;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            28,
            horizontalPadding,
            26,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, Moses',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Here is how your farm is performing today.',
                        style: TextStyle(color: AppColors.slate),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.leaf,
                  child: Text(
                    'MO',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate.fixed(const [
              _StatCard(
                label: 'Total products',
                value: '12',
                detail: '+2 this month',
                icon: Icons.inventory_2_outlined,
                color: AppColors.forest,
              ),
              _StatCard(
                label: 'Pending orders',
                value: '08',
                detail: 'Needs your attention',
                icon: Icons.schedule_rounded,
                color: AppColors.amber,
              ),
              _StatCard(
                label: 'Total sales',
                value: 'UGX 1.8M',
                detail: '+18% from last month',
                icon: Icons.trending_up_rounded,
                color: AppColors.leaf,
              ),
              _StatCard(
                label: 'Available earnings',
                value: 'UGX 640K',
                detail: 'Ready for payout',
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.coral,
              ),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 4 : 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: isWide ? 1.35 : 1.2,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            30,
            horizontalPadding,
            14,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeading(
              title: 'Quick actions',
              subtitle: 'Keep your marketplace up to date',
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _QuickAction(
                  icon: Icons.add_circle_outline_rounded,
                  label: 'Add product',
                  onTap: onAddProduct,
                  highlighted: true,
                ),
                _QuickAction(
                  icon: Icons.inventory_2_outlined,
                  label: 'Manage products',
                  onTap: onManageProducts,
                ),
                const _QuickAction(
                  icon: Icons.receipt_long_outlined,
                  label: 'View orders',
                ),
                const _QuickAction(
                  icon: Icons.bar_chart_rounded,
                  label: 'View sales',
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            32,
            horizontalPadding,
            14,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeading(
              title: 'Your products',
              subtitle: 'Monitor your active marketplace listings',
              actionLabel: 'Manage all',
              onAction: onManageProducts,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            34,
          ),
          sliver: SliverToBoxAdapter(
            child: _ProductTable(products: products),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            34,
          ),
          sliver: SliverToBoxAdapter(
            child: _RecentOrdersCard(isWide: isWide),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, color: color, size: 18),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz_rounded, color: AppColors.slate),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail,
              style: TextStyle(color: color, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap ?? () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: highlighted ? AppColors.forest : Colors.white,
        foregroundColor: highlighted ? Colors.white : AppColors.forest,
        side: BorderSide(
          color: highlighted ? AppColors.forest : AppColors.line,
        ),
      ),
    );
  }
}

class _ProductTable extends StatelessWidget {
  const _ProductTable({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < products.length; index++) ...[
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  products[index].imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(
                    color: AppColors.mint,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.eco_rounded, color: AppColors.leaf),
                    ),
                  ),
                ),
              ),
              title: Text(
                products[index].name,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                '${products[index].category} • UGX ${products[index].price.toStringAsFixed(0)} / ${products[index].unit}',
                style: const TextStyle(color: AppColors.slate, fontSize: 12),
              ),
              trailing: _StockStatus(stock: products[index].stock),
            ),
            if (index < products.length - 1)
              const Divider(height: 1, indent: 82, endIndent: 18),
          ],
        ],
      ),
    );
  }
}

class _StockStatus extends StatelessWidget {
  const _StockStatus({required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final low = stock < 40;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$stock in stock',
          style: TextStyle(
            color: low ? AppColors.coral : AppColors.forest,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          low ? 'Low stock' : 'Active',
          style: TextStyle(
            color: low ? AppColors.coral : AppColors.slate,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              title: 'Recent orders',
              subtitle: 'Orders that need your attention',
              actionLabel: 'View all',
            ),
            const SizedBox(height: 18),
            if (isWide)
              const Row(
                children: [
                  Expanded(child: _OrderCell('#ASM-1048', 'Amina M.', 'Today')),
                  Expanded(child: _OrderCell('Fresh tomatoes', '24 kg', 'UGX 120K')),
                  _OrderStatus(label: 'Pending', color: AppColors.amber),
                ],
              )
            else
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '#ASM-1048 • Amina M.',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('Fresh tomatoes • 24 kg • Today'),
                trailing: _OrderStatus(label: 'Pending', color: AppColors.amber),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderCell extends StatelessWidget {
  const _OrderCell(this.title, this.subtitle, this.detail);

  final String title;
  final String subtitle;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(color: AppColors.slate)),
        const SizedBox(height: 3),
        Text(detail, style: const TextStyle(color: AppColors.slate, fontSize: 12)),
      ],
    );
  }
}

class _OrderStatus extends StatelessWidget {
  const _OrderStatus({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _FarmerProfileMini extends StatelessWidget {
  const _FarmerProfileMini();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: AppColors.leaf,
          child: Text(
            'MO',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moses Odongo',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Green Valley Farm',
              style: TextStyle(color: AppColors.slate, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

class _FarmerPlaceholderTab extends StatelessWidget {
  const _FarmerPlaceholderTab({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final data = [
      ('Manage products', 'Add, edit and monitor your live listings.',
          Icons.inventory_2_rounded),
      ('Incoming orders', 'Review and update orders from customers.',
          Icons.receipt_long_rounded),
      ('Sales & earnings', 'Track how your farm business is growing.',
          Icons.bar_chart_rounded),
      ('Farm profile', 'Keep your farm information current.',
          Icons.person_rounded),
      ('Settings', 'Manage your marketplace preferences.',
          Icons.settings_rounded),
    ][index - 1];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.$3, size: 56, color: AppColors.leaf),
            const SizedBox(height: 16),
            Text(
              data.$1,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(data.$2, style: const TextStyle(color: AppColors.slate)),
            const SizedBox(height: 20),
            const Text(
              'This connected workflow is part of the next marketplace phase.',
              style: TextStyle(color: AppColors.slate),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddProductDialog extends StatefulWidget {
  const _AddProductDialog();

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'Vegetables';
  String _unit = 'kg';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Product(
        id: 'draft',
        name: _nameController.text.trim(),
        category: _category,
        price: double.parse(_priceController.text),
        unit: _unit,
        farmer: 'Moses Odongo',
        location: 'Arua',
        imageUrl:
            'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=800&q=80',
        stock: int.parse(_quantityController.text),
        description: _descriptionController.text.trim().isEmpty
            ? 'Fresh produce from a local Arua farm.'
            : _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a product'),
      content: SizedBox(
        width: 430,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    prefixIcon: Icon(Icons.eco_outlined),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Add a product name'
                      : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    'Fresh Produce',
                    'Vegetables',
                    'Fruits',
                    'Grains',
                    'Legumes',
                    'Other',
                  ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (UGX)',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null) {
                      return 'Enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Available quantity',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null) {
                            return 'Enter quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _unit,
                        decoration: const InputDecoration(labelText: 'Unit'),
                        items: const ['kg', 'basket', 'crate', 'bag']
                            .map(
                              (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _unit = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save product')),
      ],
    );
  }
}