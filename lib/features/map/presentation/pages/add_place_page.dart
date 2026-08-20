import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/widgets/user_avatar.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';
import 'package:wereat/features/groups/presentation/providers/groups_provider.dart';
import 'package:wereat/features/groups/presentation/widgets/create_group_dialog.dart';
import 'package:wereat/features/map/data/address_search.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/domain/entities/place_category_style.dart';
import 'package:wereat/features/map/domain/entities/price_range.dart';
import 'package:wereat/features/map/presentation/pages/pick_location_page.dart';
import 'package:wereat/features/map/presentation/providers/location_provider.dart';
import 'package:wereat/features/map/presentation/providers/user_places_provider.dart';

const _stepLabels = ['Información', 'Detalles', 'Redes', 'Revisar'];

class AddPlacePage extends ConsumerStatefulWidget {
  const AddPlacePage({super.key});

  @override
  ConsumerState<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends ConsumerState<AddPlacePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _facebookController = TextEditingController();
  final _webController = TextEditingController();
  final _addressFocusNode = FocusNode();

  int _step = 0;
  String? _groupId;
  PlaceCategory _category = PlaceCategory.restaurant;
  PriceRange _priceRange = PriceRange.normal;
  int _rating = 5;
  LatLng? _location;
  bool _isSaving = false;
  bool _isSearching = false;
  bool _suppressNextSearch = false;
  List<AddressSuggestion> _suggestions = [];
  Timer? _debounce;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _facebookController.dispose();
    _webController.dispose();
    _addressFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onAddressChanged(String query) {
    if (_suppressNextSearch) {
      _suppressNextSearch = false;
      return;
    }

    setState(() {
      _location = null;
      if (query.trim().length < 3) _suggestions = [];
    });

    _debounce?.cancel();
    if (query.trim().length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      final position = ref.read(userLocationProvider).value;
      final near = position == null
          ? null
          : LatLng(position.latitude, position.longitude);
      final results = await searchAddressSuggestions(query, near: near);
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _suggestions = results;
      });
    });
  }

  void _clearAddress() {
    _debounce?.cancel();
    _addressController.clear();
    setState(() {
      _location = null;
      _suggestions = [];
      _isSearching = false;
    });
  }

  Widget _addressSuffixIcon() {
    if (_isSearching) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_addressController.text.isEmpty) {
      return const Icon(Icons.search, size: 20);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_location != null)
          const Icon(Icons.check_circle, size: 20, color: AppColors.teal400),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          onPressed: _clearAddress,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _selectSuggestion(AddressSuggestion suggestion) {
    _suppressNextSearch = true;
    _addressController.text = suggestion.displayName;
    _addressFocusNode.unfocus();
    setState(() {
      _location = LatLng(suggestion.latitude, suggestion.longitude);
      _suggestions = [];
    });

    if (!suggestion.isExact) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Solo encontramos la calle, no el número exacto. '
            'Ajusta el pin en el mapa para afinar la ubicación.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _pickOnMap() async {
    final position = ref.read(userLocationProvider).value;
    final initialCenter =
        _location ??
        (position == null
            ? const LatLng(6.2442, -75.5812)
            : LatLng(position.latitude, position.longitude));

    final picked = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) =>
            PickLocationPage(initialCenter: initialCenter, category: _category),
      ),
    );
    if (picked == null || !mounted) return;

    _addressFocusNode.unfocus();
    setState(() {
      _location = picked;
      _suggestions = [];
      _isSearching = true;
    });

    final address = await reverseGeocodeAddress(picked);
    if (!mounted) return;

    _suppressNextSearch = true;
    _addressController.text =
        address ??
        '${picked.latitude.toStringAsFixed(5)}, ${picked.longitude.toStringAsFixed(5)}';
    setState(() => _isSearching = false);
  }

  void _goNext() {
    if (_step == 0) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ponle un nombre al lugar')),
        );
        return;
      }
      if (_location == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Elige una dirección de la lista antes de continuar'),
          ),
        );
        return;
      }
      if (_effectiveGroupId() == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crea un grupo antes de continuar')),
        );
        return;
      }
    }
    setState(() => _step++);
  }

  void _goBack() {
    if (_step == 0) {
      context.pop();
    } else {
      setState(() => _step--);
    }
  }

  /// El grupo elegido en el paso 1, o el activo si el usuario no cambió
  /// la selección. `null` si todavía no hay ningún grupo (ver
  /// [GroupsNotifier], que siembra uno por defecto en el primer uso).
  String? _effectiveGroupId() {
    return _groupId ?? ref.read(activeGroupProvider).value;
  }

  Future<void> _save() async {
    final location = _location;
    final groupId = _effectiveGroupId();
    if (_nameController.text.trim().isEmpty || location == null || groupId == null) {
      setState(() => _step = 0);
      return;
    }

    setState(() => _isSaving = true);

    final user = ref.read(authStateChangesProvider).value;
    final place = Place(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      addedByLabel: 'Agregado por ${user?.displayName ?? 'ti'}',
      category: _category,
      latitude: location.latitude,
      longitude: location.longitude,
      address: _addressController.text.trim(),
      groupId: groupId,
      rating: _rating,
      priceRange: _priceRange,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      instagramUrl: _emptyToNull(_instagramController.text),
      tiktokUrl: _emptyToNull(_tiktokController.text),
      facebookUrl: _emptyToNull(_facebookController.text),
      webUrl: _emptyToNull(_webController.text),
      addedByAvatarUrl: user?.photoURL,
      addedAt: DateTime.now(),
    );

    await ref.read(userPlacesProvider.notifier).addPlace(place);

    if (!mounted) return;
    context.pop();
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(userLocationProvider).value;
    final headerCenter =
        _location ??
        (position == null
            ? const LatLng(6.2442, -75.5812)
            : LatLng(position.latitude, position.longitude));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        title: const Text('Agregar lugar'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.sm,
            ),
            child: _StepIndicator(step: _step),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: _LocationPreview(
                location: headerCenter,
                category: _category,
                hasExactLocation: _location != null,
                addressText: _addressController.text.trim(),
                onEditTap: _pickOnMap,
                height: 150,
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _step,
                children: [
                  _buildInfoStep(),
                  _buildDetailsStep(),
                  _buildSocialsStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupPicker() {
    final groupsAsync = ref.watch(groupsProvider);
    final activeGroupId = ref.watch(activeGroupProvider).value;

    return groupsAsync.when(
      loading: () => const SizedBox(
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, _) => Text(
        'No pudimos cargar tus grupos',
        style: TextStyle(color: AppColors.gray400),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  'No tienes grupos todavía.',
                  style: TextStyle(color: AppColors.gray400),
                ),
              ),
              TextButton(
                onPressed: () => showCreateGroupDialog(context, ref),
                child: const Text('Crear grupo'),
              ),
            ],
          );
        }

        final selectedId = _groupId ?? activeGroupId;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final group in groups)
              _GroupChip(
                name: group.name,
                selected: group.id == selectedId,
                onTap: () => setState(() => _groupId = group.id),
              ),
            _GroupChip(
              name: '+ Nuevo grupo',
              selected: false,
              onTap: () => showCreateGroupDialog(context, ref),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoStep() {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        OutlinedButton.icon(
          onPressed: _pickOnMap,
          icon: const Icon(Icons.map_outlined, size: 18),
          label: const Text('Mover pin en el mapa'),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Dirección', style: textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _addressController,
          focusNode: _addressFocusNode,
          decoration: InputDecoration(
            hintText: 'Busca una dirección',
            suffixIcon: _addressSuffixIcon(),
          ),
          onChanged: _onAddressChanged,
        ),
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          _AddressSuggestionsList(
            suggestions: _suggestions,
            onSelect: _selectSuggestion,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text('Nombre del lugar', style: textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Ej. Miniburguer'),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Grupo', style: textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        _buildGroupPicker(),
        const SizedBox(height: AppSpacing.lg),
        Text('Categoría', style: textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final category in PlaceCategory.values)
              _CategoryChip(
                category: category,
                selected: _category == category,
                onTap: () => setState(() => _category = category),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _TipBox(
          message:
              'Mientras más detalles agregues, más útil será para tu grupo.',
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _SectionCard(
          icon: Icons.star_outline,
          iconColor: AppColors.amber400,
          title: 'Calificación',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Cómo calificarías este lugar?',
                style: TextStyle(fontSize: 13, color: AppColors.gray600),
              ),
              Row(
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () => setState(() => _rating = i),
                      icon: Icon(
                        i <= _rating ? Icons.star : Icons.star_border,
                        color: AppColors.amber200,
                      ),
                    ),
                ],
              ),
              Text(
                '¡Tu opinión ayuda a tu grupo!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.teal600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          icon: Icons.sell_outlined,
          iconColor: AppColors.teal400,
          title: 'Precio',
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final range in PriceRange.values)
                _PriceChip(
                  range: range,
                  selected: _priceRange == range,
                  onTap: () => setState(() => _priceRange = range),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          icon: Icons.edit_note,
          iconColor: AppColors.gray600,
          title: 'Notas',
          child: TextField(
            controller: _notesController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '¿Qué pedir? ¿Qué tal el ambiente?',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialsStep() {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Todo opcional — agrega las que quieras.',
          style: textTheme.bodySmall?.copyWith(color: AppColors.gray400),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionCard(
          icon: Icons.share_outlined,
          iconColor: AppColors.gray600,
          title: 'Redes sociales',
          child: Column(
            children: [
              _SocialField(
                icon: Icons.camera_alt_outlined,
                color: AppColors.coral400,
                controller: _instagramController,
                hint: 'Instagram',
              ),
              const SizedBox(height: AppSpacing.md),
              _SocialField(
                icon: Icons.music_note_outlined,
                color: AppColors.gray900,
                controller: _tiktokController,
                hint: 'TikTok',
              ),
              const SizedBox(height: AppSpacing.md),
              _SocialField(
                icon: Icons.facebook_outlined,
                color: AppColors.teal400,
                controller: _facebookController,
                hint: 'Facebook',
              ),
              const SizedBox(height: AppSpacing.md),
              _SocialField(
                icon: Icons.language,
                color: AppColors.amber400,
                controller: _webController,
                hint: 'Sitio web',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authStateChangesProvider).value;
    final groups = ref.watch(groupsProvider).value ?? [];
    final groupId = _effectiveGroupId();
    final groupName = groups
        .where((g) => g.id == groupId)
        .map((g) => g.name)
        .firstOrNull;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.gray100, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _category.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_category.icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _nameController.text.trim().isEmpty
                          ? 'Sin nombre'
                          : _nameController.text.trim(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${_category.label} · ${_priceRange.label}',
                style: textTheme.bodySmall?.copyWith(color: AppColors.gray400),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  for (var i = 1; i <= 5; i++)
                    Icon(
                      i <= _rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: AppColors.amber200,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  UserAvatar(
                    displayName: user?.displayName,
                    email: user?.email,
                    radius: 10,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Agregado por ${user?.displayName ?? 'ti'}'
                      '${groupName == null ? '' : ' a $groupName'}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.gray400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_location != null) ...[
          const SizedBox(height: AppSpacing.md),
          _LocationPreview(
            location: _location!,
            category: _category,
            hasExactLocation: true,
            addressText: _addressController.text.trim(),
          ),
        ],
        if (_notesController.text.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            icon: Icons.edit_note,
            iconColor: AppColors.gray600,
            title: 'Notas',
            child: Text(
              _notesController.text.trim(),
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    final isReview = _step == 3;
    final nextLabel = switch (_step) {
      0 => 'Siguiente',
      1 => 'Siguiente: Redes sociales',
      2 => 'Siguiente: Revisar',
      _ => 'Guardar lugar',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.gray100, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: _isSaving ? null : (isReview ? _save : _goNext),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coral400,
              minimumSize: const Size.fromHeight(AppSpacing.touchTarget),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(nextLabel),
                      if (!isReview) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _step == 0 ? () => context.pop() : _goBack,
            child: Text(_step == 0 ? 'Cancelar' : 'Volver'),
          ),
        ],
      ),
    );
  }
}

enum _StepState { pending, active, done }

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (index, label) in _stepLabels.indexed) ...[
          if (index > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: index <= step ? AppColors.teal400 : AppColors.gray200,
              ),
            ),
          _StepDot(
            number: index + 1,
            label: label,
            state: index < step
                ? _StepState.done
                : index == step
                ? _StepState.active
                : _StepState.pending,
          ),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.number,
    required this.label,
    required this.state,
  });

  final int number;
  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final isFilled = state != _StepState.pending;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.teal400 : Colors.white,
            border: Border.all(
              color: isFilled ? AppColors.teal400 : AppColors.gray200,
              width: 1.5,
            ),
          ),
          child: state == _StepState.done
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFilled ? Colors.white : AppColors.gray400,
                  ),
                ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: state == _StepState.active
                ? FontWeight.w600
                : FontWeight.w400,
            color: state == _StepState.active
                ? AppColors.gray900
                : AppColors.gray400,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.gray100, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final PlaceCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? category.accent : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: selected
                ? null
                : Border.all(color: AppColors.gray200, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                size: 16,
                color: selected ? Colors.white : category.accent,
              ),
              const SizedBox(width: 6),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.range,
    required this.selected,
    required this.onTap,
  });

  final PriceRange range;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.teal400 : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: selected
                ? null
                : Border.all(color: AppColors.gray200, width: 0.5),
          ),
          child: Text(
            range.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.gray900,
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.teal400 : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: selected
                ? null
                : Border.all(color: AppColors.gray200, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.groups,
                size: 16,
                color: selected ? Colors.white : AppColors.gray600,
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressSuggestionsList extends StatelessWidget {
  const _AddressSuggestionsList({
    required this.suggestions,
    required this.onSelect,
  });

  final List<AddressSuggestion> suggestions;
  final ValueChanged<AddressSuggestion> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.gray100, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, suggestion) in suggestions.indexed) ...[
            if (index > 0)
              const Divider(height: 1, color: AppColors.gray100),
            InkWell(
              onTap: () => onSelect(suggestion),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 20,
                      color: AppColors.gray400,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  suggestion.mainText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!suggestion.isExact) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.amber50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'aprox.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.amber600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (suggestion.secondaryText.isNotEmpty)
                            Text(
                              suggestion.secondaryText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.gray400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LocationPreview extends StatelessWidget {
  const _LocationPreview({
    required this.location,
    required this.category,
    required this.hasExactLocation,
    this.addressText,
    this.onEditTap,
    this.height = 160,
  });

  final LatLng location;
  final PlaceCategory category;
  final bool hasExactLocation;
  final String? addressText;
  final VoidCallback? onEditTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final pinColor = hasExactLocation ? category.accent : AppColors.gray200;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            FlutterMap(
              // `initialCenter` solo se aplica al montar el widget; sin esta
              // key, FlutterMap conserva su cámara aunque `location` cambie
              // (por ejemplo al elegir otra dirección) y el mapa se queda
              // apuntando al punto viejo.
              key: ValueKey(
                '${location.latitude},${location.longitude}',
              ),
              options: MapOptions(
                initialCenter: location,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.wereat.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                          color: pinColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          category.icon,
                          color: hasExactLocation
                              ? Colors.white
                              : AppColors.gray600,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 8,
              bottom: 8,
              right: onEditTap == null ? 8 : 56,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CaptionLine(
                      dotColor: hasExactLocation
                          ? AppColors.teal400
                          : AppColors.gray200,
                      text: hasExactLocation
                          ? 'Ubicación seleccionada'
                          : 'Aún no eliges la ubicación',
                      bold: true,
                    ),
                    if (hasExactLocation && (addressText ?? '').isNotEmpty)
                      _CaptionLine(
                        dotColor: AppColors.gray200,
                        text: addressText!,
                      ),
                  ],
                ),
              ),
            ),
            if (onEditTap != null)
              Positioned(
                right: 8,
                bottom: 8,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onEditTap,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit_location_alt_outlined,
                        size: 18,
                        color: AppColors.teal400,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CaptionLine extends StatelessWidget {
  const _CaptionLine({
    required this.dotColor,
    required this.text,
    this.bold = false,
  });

  final Color dotColor;
  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: dotColor),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.gray600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipBox extends StatelessWidget {
  const _TipBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 18,
            color: AppColors.teal600,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consejo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
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

class _SocialField extends StatelessWidget {
  const _SocialField({
    required this.icon,
    required this.color,
    required this.controller,
    required this.hint,
  });

  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
        ),
      ],
    );
  }
}
