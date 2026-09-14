import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/brand_mark.dart';
import '../../../shared/widgets/section_heading.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  final _searchController = TextEditingController();
  final _cart = <String, int>{};
  final _wishlist = <String>{};
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return demoProducts.where((product) {
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.farmer.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _addToCart(Product product) {
    setState(() => _cart[product.id] = (_cart[product.id] ?? 0) + 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to your cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'View cart', onPressed: _showCart),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _CartSheet(
        cart: _cart,
        onCheckout: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(
              content: Text('Checkout will be connected to orders in Phase 5.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _showProduct(Product product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _ProductDetailsSheet(
        product: product,
        isSaved: _wishlist.contains(product.id),
        onSave: () {
          setState(() {
            if (_wishlist.contains(product.id)) {
              _wishlist.remove(product.id);
            } else {
              _wishlist.add(product.id);
            }
          });
          Navigator.pop(context);
        },
        onAdd: () {
          Navigator.pop(context);
          _addToCart(product);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1000;
    final content = _selectedIndex == 0
        ? _HomeContent(
            searchController: _searchController,
            products: _filteredProducts,
            selectedCategory: _selectedCategory,
            onSearchChanged: (_) => setState(() {}),
            onCategoryChanged: (category) {
              setState(() => _selectedCategory = category);
            },
            wishlist: _wishlist,
            onToggleWishlist: (product) {
              setState(() {
                if (_wishlist.contains(product.id)) {
                  _wishlist.remove(product.id);
                } else {
                  _wishlist.add(product.id);
                }
              });
            },
            onAddToCart: _addToCart,
            onProductTap: _showProduct,
          )
        : _PlaceholderTab(
            index: _selectedIndex,
            cartCount: _cart.values.fold(0, (sum, count) => sum + count),
          );

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              _CustomerRail(
                selectedIndex: _selectedIndex,
                onSelected: (index) => setState(() => _selectedIndex = index),
                cartCount: _cart.values.fold(0, (sum, count) => sum + count),
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
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border_rounded),
                  selectedIcon: Icon(Icons.favorite_rounded),
                  label: 'Saved',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Account',
                ),
              ],
            ),
    );
  }
}

class _CustomerRail extends StatelessWidget {
  const _CustomerRail({
    required this.selectedIndex,
    required this.onSelected,
    required this.cartCount,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int cartCount;

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
          const SizedBox(height: 58),
          const Text(
            'SHOP',
            style: TextStyle(
              color: AppColors.slate,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _RailItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Marketplace',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _RailItem(
            icon: Icons.receipt_long_outlined,
            selectedIcon: Icons.receipt_long_rounded,
            label: 'My orders',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _RailItem(
            icon: Icons.favorite_border_rounded,
            selectedIcon: Icons.favorite_rounded,
            label: 'Saved products',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          const SizedBox(height: 28),
          const Text(
            'ACCOUNT',
            style: TextStyle(
              color: AppColors.slate,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _RailItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'My profile',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.support_agent_rounded, color: AppColors.forest),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Need help?\nTalk to our team',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
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

class _RailItem extends StatelessWidget {
  const _RailItem({
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

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.searchController,
    required this.products,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.wishlist,
    required this.onToggleWishlist,
    required this.onAddToCart,
    required this.onProductTap,
  });

  final TextEditingController searchController;
  final List<Product> products;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final Set<String> wishlist;
  final ValueChanged<Product> onToggleWishlist;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1000 ? 54.0 : 22.0;
    final columns = width >= 1250 ? 4 : width >= 720 ? 3 : 2;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            28,
            horizontalPadding,
            12,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, Amina',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'What are you looking for today?',
                        style: TextStyle(color: AppColors.slate),
                      ),
                    ],
                  ),
                ),
                _CircleAction(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                ),
                const SizedBox(width: 10),
                _CircleAction(
                  icon: Icons.shopping_bag_outlined,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your cart is ready at the bottom right.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.leaf,
                  child: Text(
                    'AM',
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
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 14,
          ),
          sliver: SliverToBoxAdapter(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search products, categories or farmers',
                prefixIcon: Icon(Icons.search_rounded),
                suffixIcon: Icon(Icons.tune_rounded),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: _HeroBanner(onBrowse: () => onCategoryChanged('All')),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            28,
            horizontalPadding,
            14,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeading(
              title: 'Shop by category',
              subtitle: 'Find what you need from local growers',
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final category in const [
                    'All',
                    'Vegetables',
                    'Fruits',
                    'Grains',
                    'Legumes',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) => onCategoryChanged(category),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            28,
            horizontalPadding,
            14,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeading(
              title: 'Fresh from local farms',
              subtitle: '${products.length} products available near you',
              actionLabel: 'View all',
              onAction: () => onCategoryChanged('All'),
            ),
          ),
        ),
        if (products.isEmpty)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: const SliverToBoxAdapter(child: _EmptySearchState()),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              32,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(
                  product: products[index],
                  isSaved: wishlist.contains(products[index].id),
                  onToggleWishlist: () => onToggleWishlist(products[index]),
                  onAddToCart: () => onAddToCart(products[index]),
                  onTap: () => onProductTap(products[index]),
                ),
                childCount: products.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                      childAspectRatio: width < 500 ? .68 : .78,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1499529112087-3cb3b73cec95?w=1200&q=80',
          ),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          opacity: .2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Fresh harvests,\ncloser to home.',
            style: TextStyle(
              color: Colors.white,
              height: 1.1,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onBrowse,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            child: const Text('Browse all products'),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isSaved,
    required this.onToggleWishlist,
    required this.onAddToCart,
    required this.onTap,
  });

  final Product product;
  final bool isSaved;
  final VoidCallback onToggleWishlist;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 11,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(
                      color: AppColors.mint,
                      child: Icon(
                        Icons.eco_rounded,
                        size: 46,
                        color: AppColors.leaf,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton.filledTonal(
                      onPressed: onToggleWishlist,
                      icon: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 19,
                      ),
                      color: isSaved ? AppColors.coral : AppColors.ink,
                      tooltip: 'Save product',
                    ),
                  ),
                  if (product.isFeatured)
                    const Positioned(
                      left: 10,
                      top: 12,
                      child: _StatusBadge(label: 'FEATURED'),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 11, 11, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.farmer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.slate,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'UGX ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' / ${product.unit}',
                          style: const TextStyle(
                            color: AppColors.slate,
                            fontSize: 10,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.add_rounded),
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.forest,
                            foregroundColor: Colors.white,
                          ),
                          tooltip: 'Add to cart',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.amber,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon),
      color: AppColors.ink,
      tooltip: 'Open',
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 44, color: AppColors.leaf),
          SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 5),
          Text(
            'Try another search or browse all categories.',
            style: TextStyle(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.index, required this.cartCount});

  final int index;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final data = [
      (
        'Your orders',
        'Track every order from farm to doorstep.',
        Icons.receipt_long_rounded,
      ),
      (
        'Saved products',
        'Your favourite local harvests will appear here.',
        Icons.favorite_rounded,
      ),
      (
        'Your profile',
        'Manage your details, delivery address and preferences.',
        Icons.person_rounded,
      ),
    ][index - 1];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.$3, size: 54, color: AppColors.leaf),
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
            Text(
              'This connected flow is part of the next marketplace phase.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailsSheet extends StatelessWidget {
  const _ProductDetailsSheet({
    required this.product,
    required this.isSaved,
    required this.onSave,
    required this.onAdd,
  });

  final Product product;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.8,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(color: AppColors.mint),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.category.toUpperCase(),
              style: const TextStyle(
                color: AppColors.forest,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 7),
            Text(
              'UGX ${product.price.toStringAsFixed(0)} / ${product.unit}',
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              product.description,
              style: const TextStyle(color: AppColors.slate, height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.agriculture_rounded,
                    color: AppColors.forest, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${product.farmer} • ${product.location}',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${product.stock} ${product.unit}s available',
              style: const TextStyle(color: AppColors.slate),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSave,
                    icon: Icon(
                      isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                    label: Text(isSaved ? 'Saved' : 'Save'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Add to cart'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSheet extends StatelessWidget {
  const _CartSheet({required this.cart, required this.onCheckout});

  final Map<String, int> cart;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final items = demoProducts.where((product) => cart.containsKey(product.id));
    final subtotal = items.fold<double>(
      0,
      (sum, product) => sum + product.price * (cart[product.id] ?? 0),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your cart',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 26),
                child: Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(color: AppColors.slate),
                  ),
                ),
              )
            else ...[
              for (final product in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product.imageUrl),
                  ),
                  title: Text(product.name),
                  subtitle: Text('${cart[product.id]} × UGX ${product.price}'),
                  trailing: Text(
                    'UGX ${(product.price * (cart[product.id] ?? 0)).toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              const Divider(height: 26),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Subtotal',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    'UGX ${subtotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  child: const Text('Continue to checkout'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}