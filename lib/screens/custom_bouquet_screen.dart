
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';

class CustomBouquetScreen extends StatefulWidget {
  const CustomBouquetScreen({super.key});

  @override
  State<CustomBouquetScreen> createState() => _CustomBouquetScreenState();
}

class _CustomBouquetScreenState extends State<CustomBouquetScreen> {
  String flower = 'Mawar';
  String wrapper = 'Pink Pastel';
  String ribbon = 'Satin';
  String accessory = 'Kartu Ucapan';

  three.ThreeJS? threeJs;
  three.Group? _bouquetGroup;

  bool is3DLoading = true;

  final Map<String, int> flowerQuantities = {
    'Mawar': 12,
    'Tulip': 0,
    'Lily': 0,
    'Daisy': 0,
    'Baby Breath': 0,
  };

  final Map<String, int> flowerPrices = {
    'Mawar': 12000,
    'Tulip': 18000,
    'Lily': 20000,
    'Daisy': 8000,
    'Baby Breath': 10000,
  };

  final Map<String, int> wrapperPrices = {
    'Pink Pastel': 15000,
    'Putih': 12000,
    'Cream': 12000,
    'Hitam Premium': 18000,
  };

  final Map<String, int> ribbonPrices = {
    'Satin': 8000,
    'Organza': 12000,
    'Velvet': 15000,
    'Tanpa Pita': 0,
  };

  final Map<String, int> accessoryPrices = {
    'Tanpa Aksesori': 0,
    'Kartu Ucapan': 5000,
    'Boneka Mini': 20000,
    'Lampu LED': 15000,
  };

  final Map<String, IconData> flowerIcons = {
    'Mawar': Icons.filter_vintage_rounded,
    'Tulip': Icons.local_florist_rounded,
    'Lily': Icons.spa_rounded,
    'Daisy': Icons.grass_rounded,
    'Baby Breath': Icons.eco_rounded,
  };

  final Map<String, Color> flowerColors = {
    'Mawar': const Color(0xFFC85E80),
    'Tulip': const Color(0xFFCB8CA6),
    'Lily': const Color(0xFFB88772),
    'Daisy': const Color(0xFFD5A844),
    'Baby Breath': const Color(0xFF849B89),
  };

  final Map<String, IconData> wrapperIcons = {
    'Pink Pastel': Icons.layers_rounded,
    'Putih': Icons.filter_frames_rounded,
    'Cream': Icons.texture_rounded,
    'Hitam Premium': Icons.diamond_rounded,
  };

  final Map<String, Color> wrapperColors = {
    'Pink Pastel': const Color(0xFFE8AFC1),
    'Putih': const Color(0xFFF8F5F2),
    'Cream': const Color(0xFFE8D2B8),
    'Hitam Premium': const Color(0xFF34313A),
  };

  final Map<String, IconData> ribbonIcons = {
    'Satin': Icons.all_inclusive_rounded,
    'Organza': Icons.auto_awesome_rounded,
    'Velvet': Icons.favorite_rounded,
    'Tanpa Pita': Icons.remove_circle_outline_rounded,
  };

  final Map<String, Color> ribbonColors = {
    'Satin': const Color(0xFFC85E80),
    'Organza': const Color(0xFFE9AFC3),
    'Velvet': const Color(0xFF9D526B),
    'Tanpa Pita': const Color(0xFFB8B0B0),
  };

  final Map<String, IconData> accessoryIcons = {
    'Tanpa Aksesori': Icons.block_rounded,
    'Kartu Ucapan': Icons.mail_outline_rounded,
    'Boneka Mini': Icons.toys_outlined,
    'Lampu LED': Icons.lightbulb_outline_rounded,
  };

  int get totalQuantity =>
      flowerQuantities.values.fold(0, (sum, value) => sum + value);

  int get flowerTotal => flowerPrices.entries.fold(
        0,
        (sum, entry) =>
            sum + entry.value * (flowerQuantities[entry.key] ?? 0),
      );

  int get totalPrice =>
      flowerTotal +
      wrapperPrices[wrapper]! +
      ribbonPrices[ribbon]! +
      accessoryPrices[accessory]!;

  List<String> get selectedFlowers => flowerQuantities.entries
      .where((entry) => entry.value > 0)
      .map((entry) => entry.key)
      .toList();

  @override
  void initState() {
    super.initState();
    _init3DScene();
  }

  @override
  void dispose() {
    threeJs?.dispose();
    threeJs = null;
    super.dispose();
  }

  // =========================================================
  // INISIALISASI THREE JS
  // =========================================================

  void _init3DScene() {
    is3DLoading = true;

    threeJs = three.ThreeJS(
      setup: () {
        final setup = threeJs!;

        setup.scene = three.Scene();
        setup.scene.background = three.Color(0xFFFFFAFC);

        setup.camera = three.PerspectiveCamera(
          38,
          setup.width / setup.height,
          0.1,
          100,
        );

        setup.camera.position.setValues(0, 0.45, 4.6);

        final controls = three.OrbitControls(
          setup.camera,
          setup.globalKey,
        );

        controls.enableDamping = true;
        controls.dampingFactor = 0.06;

        final ambient = three.AmbientLight(0xffffff, 1.3);
        setup.scene.add(ambient);

        final mainLight = three.DirectionalLight(0xffffff, 2.0);
        mainLight.position.setValues(3, 6, 5);
        setup.scene.add(mainLight);

        final fillLight = three.DirectionalLight(0xffffff, 0.9);
        fillLight.position.setValues(-4, 3, 4);
        setup.scene.add(fillLight);

        final backLight = three.DirectionalLight(0xffffff, 0.7);
        backLight.position.setValues(0, 3, -5);
        setup.scene.add(backLight);

        _rebuildBouquet(setup.scene);

        setup.addAnimationEvent((dt) {
          controls.update();
        });
      },
      onSetupComplete: () {
        if (!mounted) return;
        setState(() => is3DLoading = false);
      },
    );
  }

  // =========================================================
  // REFRESH PREVIEW
  // =========================================================

  void _refreshBouquet() {
    final scene = threeJs?.scene;
    if (scene != null) {
      _rebuildBouquet(scene);
    }
  }

  // =========================================================
  // MATERIAL
  // =========================================================

  three.MeshStandardMaterial _material(
    int color, {
    double roughness = 0.55,
    double metalness = 0,
  }) {
    final tieMaterial = three.MeshStandardMaterial();
    tieMaterial.color = three.Color(0xE7B5C5.toDouble());
    tieMaterial.roughness = roughness;
    tieMaterial.metalness = metalness;
    return tieMaterial;
  }

  // =========================================================
  // MODEL UTAMA BUKET
  // =========================================================

  void _rebuildBouquet(three.Scene scene) {
    if (_bouquetGroup != null) {
      scene.remove(_bouquetGroup!);
    }

    final group = three.Group();
    _bouquetGroup = group;

    _addWrapper(group);
    _addWrapperDetails(group);
    _addStems(group);
    _addAllFlowers(group);
    _addRibbon3D(group);
    _addAccessory3D(group);

    scene.add(group);
  }

  // =========================================================
  // WRAPPING PAPER
  // =========================================================

  void _addWrapper(three.Group group) {
    final color = _colorToHex(wrapperColors[wrapper]!);
    final material = _material(color, roughness: 0.85);

    final paper = three.Mesh(
      three.ConeGeometry(1.0, 1.85, 48, 1, true),
      material,
    );

    paper.rotation.x = math.pi;
    paper.position.setValues(0, -0.67, 0);
    group.add(paper);

    // Lapisan pembungkus kedua.
    final innerMaterial = _material(
      _lightenColor(color),
      roughness: 0.9,
    );

    final inner = three.Mesh(
      three.ConeGeometry(0.94, 1.75, 48, 1, true),
      innerMaterial,
    );

    inner.rotation.x = math.pi;
    inner.position.setValues(0, -0.66, 0.015);
    group.add(inner);

    // Lipatan kertas di sisi kiri dan kanan.
    for (var i = 0; i < 7; i++) {
      final angle = -math.pi / 2 + (i * math.pi / 6);

      final fold = three.Mesh(
        three.BoxGeometry(0.018, 1.45, 0.018),
        _material(_darkenColor(color), roughness: 0.9),
      );

      fold.position.setValues(
        math.cos(angle) * 0.49,
        -0.69,
        math.sin(angle) * 0.49,
      );

      fold.rotation.y = -angle;
      fold.rotation.z = -0.16;
      group.add(fold);
    }

    // Bagian bawah pembungkus.
    final bottom = three.Mesh(
      three.SphereGeometry(0.13, 20, 16),
      material,
    );

    bottom.position.setValues(0, -1.58, 0);
    bottom.scale.setValues(1.3, 0.6, 1.1);
    group.add(bottom);
  }

  void _addWrapperDetails(three.Group group) {
    final color = _colorToHex(wrapperColors[wrapper]!);

    final material = _material(
      _darkenColor(color),
      roughness: 0.8,
    );

    // Detail tepi atas pembungkus.
    final rim = three.Mesh(
      three.TorusGeometry(0.76, 0.025, 10, 48),
      material,
    );

    rim.position.setValues(0, 0.18, 0);
    group.add(rim);
  }

  // =========================================================
  // BATANG DAN DAUN
  // =========================================================

  void _addStems(three.Group group) {
    final stemMaterial = _material(0x557C50, roughness: 0.9);
    final leafMaterial = _material(0x72966A, roughness: 0.85);

    var index = 0;

    for (final entry in flowerQuantities.entries) {
      for (var i = 0; i < entry.value; i++) {
        final angle = index * 2.399963229728653;
        final radius = 0.13 + (index % 4) * 0.045;

        final x = math.cos(angle) * radius;
        final z = math.sin(angle) * radius * 0.55;

        final stem = three.Mesh(
          three.CylinderGeometry(0.018, 0.025, 1.05, 8),
          stemMaterial,
        );

        stem.position.setValues(x * 0.7, -0.12, z * 0.7);
        stem.rotation.z = math.sin(angle) * 0.1;
        group.add(stem);

        // Daun kecil pada batang.
        final leaf = three.Mesh(
          three.SphereGeometry(0.12, 12, 10),
          leafMaterial,
        );

        leaf.scale.setValues(1.8, 0.3, 0.65);
        leaf.position.setValues(x + 0.1, -0.38, z + 0.04);
        leaf.rotation.z = angle * 0.3;
        group.add(leaf);

        index++;
      }
    }
  }

  // =========================================================
  // SEMUA BUNGA
  // =========================================================

  void _addAllFlowers(three.Group group) {
    final flowerHex = {
      'Mawar': 0xD9577E,
      'Tulip': 0xEFA8BC,
      'Lily': 0xFFF0D7,
      'Daisy': 0xFFD76B,
      'Baby Breath': 0xFFF8F5,
    };

    var index = 0;

    for (final entry in flowerQuantities.entries) {
      final count = entry.value;
      if (count <= 0) continue;

      for (var i = 0; i < count; i++) {
        final angle = index * 2.399963229728653;
        final ring = index ~/ 9;
        final radius = 0.13 + ring * 0.16;

        final x = math.cos(angle) * radius;
        final z = math.sin(angle) * radius * 0.55;
        final y = 0.42 - ring * 0.035 +
            0.08 * math.sin(angle * 2);

        if (entry.key == 'Baby Breath') {
          _addBabyBreath(group, x, y, z, index);
        } else {
          _addFlower(
            group,
            entry.key,
            flowerHex[entry.key]!,
            x,
            y,
            z,
            index,
          );
        }

        index++;
      }
    }
  }

  // =========================================================
  // MODEL BUNGA BERDASARKAN JENIS
  // =========================================================

  void _addFlower(
    three.Group group,
    String type,
    int color,
    double x,
    double y,
    double z,
    int index,
  ) {
    final flowerGroup = three.Group();
    flowerGroup.position.setValues(x, y, z);

    final petalMaterial = _material(color, roughness: 0.4);
    final centerMaterial = _material(
      type == 'Daisy' ? 0xEAAE32 : 0xD99564,
      roughness: 0.55,
    );

    if (type == 'Mawar') {
      _addRose(flowerGroup, petalMaterial, centerMaterial);
    } else if (type == 'Tulip') {
      _addTulip(flowerGroup, petalMaterial, centerMaterial);
    } else if (type == 'Lily') {
      _addLily(flowerGroup, petalMaterial, centerMaterial);
    } else if (type == 'Daisy') {
      _addDaisy(flowerGroup, petalMaterial, centerMaterial);
    }

    final scale = 0.92 + (index % 4) * 0.045;
    flowerGroup.scale.setValues(scale, scale, scale);

    group.add(flowerGroup);
  }

  // Mawar: kelopak berlapis dan melingkar.
  void _addRose(
    three.Group flower,
    three.MeshStandardMaterial material,
    three.MeshStandardMaterial centerMaterial,
  ) {
    for (var layer = 0; layer < 3; layer++) {
      final count = 7 + layer * 2;
      final radius = 0.045 + layer * 0.075;

      for (var i = 0; i < count; i++) {
        final angle = (2 * math.pi * i / count) +
            (layer * 0.35);

        final petal = three.Mesh(
          three.SphereGeometry(0.105, 18, 14),
          material,
        );

        petal.position.setValues(
          math.cos(angle) * radius,
          layer * 0.025,
          math.sin(angle) * radius,
        );

        petal.scale.setValues(1.0, 0.42, 1.35);
        petal.rotation.y = -angle;
        flower.add(petal);
      }
    }

    final center = three.Mesh(
      three.SphereGeometry(0.075, 18, 14),
      centerMaterial,
    );

    center.position.y = 0.055;
    center.scale.setValues(0.85, 0.65, 0.85);
    flower.add(center);
  }

  // Tulip: kelopak memanjang dan menguncup.
  void _addTulip(
    three.Group flower,
    three.MeshStandardMaterial material,
    three.MeshStandardMaterial centerMaterial,
  ) {
    for (var i = 0; i < 6; i++) {
      final angle = (2 * math.pi * i) / 6;

      final petal = three.Mesh(
        three.SphereGeometry(0.13, 20, 16),
        material,
      );

      petal.position.setValues(
        math.cos(angle) * 0.075,
        0.035,
        math.sin(angle) * 0.075,
      );

      petal.scale.setValues(0.78, 1.5, 0.75);
      petal.rotation.z = math.cos(angle) * 0.18;
      flower.add(petal);
    }

    final center = three.Mesh(
      three.SphereGeometry(0.065, 16, 12),
      centerMaterial,
    );

    center.position.y = 0.045;
    flower.add(center);
  }

  // Lily: enam kelopak panjang dan terbuka.
  void _addLily(
    three.Group flower,
    three.MeshStandardMaterial material,
    three.MeshStandardMaterial centerMaterial,
  ) {
    for (var i = 0; i < 6; i++) {
      final angle = (2 * math.pi * i) / 6;

      final petal = three.Mesh(
        three.SphereGeometry(0.15, 20, 16),
        material,
      );

      petal.position.setValues(
        math.cos(angle) * 0.12,
        0,
        math.sin(angle) * 0.12,
      );

      petal.scale.setValues(0.62, 0.38, 1.8);
      petal.rotation.y = -angle;
      flower.add(petal);
    }

    final center = three.Mesh(
      three.SphereGeometry(0.075, 16, 12),
      centerMaterial,
    );

    center.position.y = 0.04;
    flower.add(center);

    // Detail putik lily.
    final pistilMaterial = _material(0xD9A64B);

    for (var i = 0; i < 3; i++) {
      final pistil = three.Mesh(
        three.CylinderGeometry(0.009, 0.012, 0.17, 6),
        pistilMaterial,
      );

      pistil.position.setValues(
        (i - 1) * 0.035,
        0.12,
        0,
      );

      flower.add(pistil);
    }
  }

  // Daisy: kelopak kecil mengelilingi bagian tengah.
  void _addDaisy(
    three.Group flower,
    three.MeshStandardMaterial material,
    three.MeshStandardMaterial centerMaterial,
  ) {
    for (var i = 0; i < 12; i++) {
      final angle = (2 * math.pi * i) / 12;

      final petal = three.Mesh(
        three.SphereGeometry(0.09, 16, 12),
        material,
      );

      petal.position.setValues(
        math.cos(angle) * 0.14,
        0,
        math.sin(angle) * 0.14,
      );

      petal.scale.setValues(0.75, 0.38, 1.55);
      petal.rotation.y = -angle;
      flower.add(petal);
    }

    final center = three.Mesh(
      three.SphereGeometry(0.105, 20, 16),
      centerMaterial,
    );

    center.position.y = 0.035;
    flower.add(center);
  }

  // Baby breath: kumpulan bunga kecil berwarna putih.
  void _addBabyBreath(
    three.Group group,
    double x,
    double y,
    double z,
    int index,
  ) {
    final cluster = three.Group();
    cluster.position.setValues(x, y, z);

    final white = _material(0xFFFFFAF8);
    final centerMaterial = _material(0xE9D4B9);

    for (var i = 0; i < 5; i++) {
      final angle = i * 2.399963229728653;

      final smallFlower = three.Group();

      final petal = three.Mesh(
        three.SphereGeometry(0.035, 10, 8),
        white,
      );

      petal.scale.setValues(1, 0.65, 1.25);
      petal.position.setValues(
        math.cos(angle) * 0.025,
        0,
        math.sin(angle) * 0.025,
      );

      smallFlower.add(petal);

      final center = three.Mesh(
        three.SphereGeometry(0.018, 8, 8),
        centerMaterial,
      );

      center.position.y = 0.015;
      smallFlower.add(center);

      cluster.add(smallFlower);
    }

    final scale = 0.9 + (index % 3) * 0.08;
    cluster.scale.setValues(scale, scale, scale);
    group.add(cluster);
  }

  // =========================================================
  // PITA 3D
  // =========================================================

  void _addRibbon3D(three.Group group) {
    if (ribbon == 'Tanpa Pita') return;

    final colors = {
      'Satin': 0xFFC85E80,
      'Organza': 0xFFE9AFC3,
      'Velvet': 0xFF9D526B,
    };

    final material = _material(
      colors[ribbon] ?? 0xFFC85E80,
      roughness: ribbon == 'Velvet' ? 0.85 : 0.3,
    );

    // Simpul utama.
    final knot = three.Mesh(
      three.SphereGeometry(0.085, 18, 14),
      material,
    );

    knot.scale.setValues(1.2, 0.75, 0.6);
    knot.position.setValues(0, -0.16, 0.84);
    group.add(knot);

    // Dua lingkaran pita.
    for (var i = 0; i < 2; i++) {
      final loop = three.Mesh(
        three.TorusGeometry(0.15, 0.04, 12, 32),
        material,
      );

      loop.position.setValues(
        i == 0 ? -0.17 : 0.17,
        -0.13,
        0.84,
      );

      loop.scale.setValues(1.2, 0.8, 0.6);
      loop.rotation.z = i == 0 ? 0.4 : -0.4;
      group.add(loop);
    }

    // Dua ujung pita.
    for (var i = 0; i < 2; i++) {
      final tail = three.Mesh(
        three.BoxGeometry(0.10, 0.43, 0.025),
        material,
      );

      tail.position.setValues(
        i == 0 ? -0.12 : 0.12,
        -0.47,
        0.83,
      );

      tail.rotation.z = i == 0 ? -0.16 : 0.16;
      group.add(tail);
    }
  }

  // =========================================================
  // AKSESORI 3D
  // =========================================================

  void _addAccessory3D(three.Group group) {
    if (accessory == 'Tanpa Aksesori') return;

    if (accessory == 'Kartu Ucapan') {
      _addGreetingCard(group);
    } else if (accessory == 'Boneka Mini') {
      _addMiniDoll(group);
    } else if (accessory == 'Lampu LED') {
      _addLedLights(group);
    }
  }

  void _addGreetingCard(three.Group group) {
    final cardMaterial = _material(0xFFFFF0E5);
    final pinkMaterial = _material(0xFFC85E80);

    final card = three.Mesh(
      three.BoxGeometry(0.32, 0.25, 0.035),
      cardMaterial,
    );

    card.position.setValues(0.49, -0.14, 0.82);
    card.rotation.z = -0.18;
    group.add(card);

    final heart = three.Mesh(
      three.SphereGeometry(0.055, 16, 12),
      pinkMaterial,
    );

    heart.position.setValues(0.49, -0.14, 0.85);
    heart.scale.setValues(1.2, 0.8, 0.4);
    group.add(heart);
  }

  void _addMiniDoll(three.Group group) {
    final bodyMaterial = _material(0xFFE7D1B9);
    final earMaterial = _material(0xFFE7D1B9);
    final eyeMaterial = _material(0xFF493A3A);

    final body = three.Mesh(
      three.SphereGeometry(0.12, 20, 16),
      bodyMaterial,
    );

    body.position.setValues(0.48, -0.24, 0.82);
    group.add(body);

    final head = three.Mesh(
      three.SphereGeometry(0.09, 20, 16),
      bodyMaterial,
    );

    head.position.setValues(0.48, -0.08, 0.82);
    group.add(head);

    for (var i = 0; i < 2; i++) {
      final ear = three.Mesh(
        three.SphereGeometry(0.04, 12, 10),
        earMaterial,
      );

      ear.position.setValues(
        i == 0 ? 0.42 : 0.54,
        -0.005,
        0.82,
      );

      group.add(ear);
    }

    for (var i = 0; i < 2; i++) {
      final eye = three.Mesh(
        three.SphereGeometry(0.012, 8, 8),
        eyeMaterial,
      );

      eye.position.setValues(
        i == 0 ? 0.45 : 0.51,
        -0.08,
        0.905,
      );

      group.add(eye);
    }
  }

  void _addLedLights(three.Group group) {
    final ledMaterial = _material(0xFFFFD66B, roughness: 0.2);

    for (var i = 0; i < 9; i++) {
      final angle = i * 2.399963229728653;

      final led = three.Mesh(
        three.SphereGeometry(0.045, 12, 10),
        ledMaterial,
      );

      led.position.setValues(
        math.cos(angle) * 0.58,
        0.28 + math.sin(angle) * 0.17,
        0.65,
      );

      group.add(led);
    }
  }

  // =========================================================
  // UTILITAS WARNA
  // =========================================================

  int _colorToHex(Color color) {
    return ((color.r * 255).round() << 16) |
        ((color.g * 255).round() << 8) |
        (color.b * 255).round();
  }

  int _lightenColor(int color) {
    final r = (color >> 16) & 0xff;
    final g = (color >> 8) & 0xff;
    final b = color & 0xff;

    return (((r + 255) ~/ 2) << 16) |
        (((g + 255) ~/ 2) << 8) |
        ((b + 255) ~/ 2);
  }

  int _darkenColor(int color) {
    final r = (color >> 16) & 0xff;
    final g = (color >> 8) & 0xff;
    final b = color & 0xff;

    return ((r * 0.78).round() << 16) |
        ((g * 0.78).round() << 8) |
        (b * 0.78).round();
  }

  // =========================================================
  // BUILD HALAMAN
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Bouquet',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Design your own floral story',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          _buildPreview(),
          const SizedBox(height: 28),

          _buildSectionHeading(
            '01',
            'Pilih Bunga Favorit',
            'Kombinasikan berbagai bunga untuk buket unikmu.',
          ),
          const SizedBox(height: 15),
          _buildFlowerChoices(),

          const SizedBox(height: 28),

          _buildSectionHeading(
            '02',
            'Wrapping Paper',
            'Pilih warna pembungkus yang paling kamu suka.',
          ),
          const SizedBox(height: 15),
          _buildWrapperChoices(),

          const SizedBox(height: 28),

          _buildSectionHeading(
            '03',
            'Pita Buket',
            'Lengkapi rangkaian dengan pita pilihanmu.',
          ),
          const SizedBox(height: 15),
          _buildRibbonChoices(),

          const SizedBox(height: 28),

          _buildSectionHeading(
            '04',
            'Sentuhan Personal',
            'Tambahkan aksesori untuk membuatnya lebih istimewa.',
          ),
          const SizedBox(height: 15),
          _buildAccessoryChoices(),

          const SizedBox(height: 28),
          _buildPriceSummary(),
          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _showSummary,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinkDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 19),
                  SizedBox(width: 10),
                  Text(
                    'Lihat Ringkasan Custom',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 17),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 13,
                color: AppColors.roseGold,
              ),
              SizedBox(width: 6),
              Text(
                'Dibuat khusus untuk momen istimewamu',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PREVIEW 3D
  // =========================================================

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF2D9E3),
            Color(0xFFFFFAF7),
            Color(0xFFF7E9E0),
          ],
        ),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkDark.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: AppColors.pinkDark,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'YOUR CREATION (3D)',
                      style: TextStyle(
                        color: AppColors.pinkDark,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.threed_rotation,
                color: AppColors.roseGold,
                size: 23,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  if (threeJs != null)
                    Positioned.fill(child: threeJs!.build()),
                  if (is3DLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.pinkDark,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 13,
                color: AppColors.muted,
              ),
              SizedBox(width: 5),
              Text(
                'Geser untuk memutar buket 3D',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            selectedFlowers.isEmpty
                ? 'Buket pilihanmu'
                : selectedFlowers.join(' + '),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '$totalQuantity tangkai  •  $wrapper  •  $ribbon',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: 75,
            height: 1,
            color: AppColors.roseGold.withValues(alpha: 0.55),
          ),

          const SizedBox(height: 14),

          const Text(
            'ESTIMASI HARGA BUKET',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),

          const SizedBox(height: 5),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              formatRupiah(totalPrice),
              key: ValueKey<int>(totalPrice),
              style: const TextStyle(
                color: AppColors.pinkDark,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // JUDUL BAGIAN
  // =========================================================

  Widget _buildSectionHeading(
    String number,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF5DCE5),
                Color(0xFFFBEDE8),
              ],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.pinkDark,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PILIHAN BUNGA
  // =========================================================

  Widget _buildFlowerChoices() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: AppColors.pinkLight.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                color: AppColors.pinkDark,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$totalQuantity tangkai dipilih. Tambahkan jenis bunga sesukamu.',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),

        ...flowerPrices.entries.map((entry) {
          final name = entry.key;
          final count = flowerQuantities[name] ?? 0;
          final selected = count > 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildSelectableCard(
              selected: selected,
              onTap: () {
                if (count == 0) {
                  _changeFlowerQuantity(name, 1);
                } else {
                  setState(() => flower = name);
                }
              },
              child: Row(
                children: [
                  _illustrationTile(
                    icon: flowerIcons[name]!,
                    color: flowerColors[name]!,
                    selected: selected,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${formatRupiah(entry.value)} / tangkai',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected)
                    _buildMiniQuantityControl(
                      count: count,
                      onMinus: () => _changeFlowerQuantity(name, -1),
                      onPlus: () => _changeFlowerQuantity(name, 1),
                    )
                  else
                    const Icon(
                      Icons.add_circle_rounded,
                      color: AppColors.pinkDark,
                      size: 27,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMiniQuantityControl({
    required int count,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.pinkLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _miniButton(
            icon: Icons.remove_rounded,
            onTap: onMinus,
          ),
          SizedBox(
            width: 25,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _miniButton(
            icon: Icons.add_rounded,
            onTap: onPlus,
          ),
        ],
      ),
    );
  }

  Widget _miniButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 27,
          height: 30,
          child: Icon(
            icon,
            size: 15,
            color: AppColors.pinkDark,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // JUMLAH BUNGA
  // =========================================================

  void _changeFlowerQuantity(String name, int change) {
    final current = flowerQuantities[name] ?? 0;

    if (change > 0 && totalQuantity >= 50) {
      _showMessage('Maksimal 50 tangkai per buket.');
      return;
    }

    if (change < 0 && current <= 0) return;

    if (change < 0 && totalQuantity <= 3) {
      _showMessage('Buket minimal terdiri dari 3 tangkai.');
      return;
    }

    setState(() {
      flowerQuantities[name] = current + change;

      if (change > 0) {
        flower = name;
      } else if (flowerQuantities[name] == 0 && flower == name) {
        final remaining = selectedFlowers;
        if (remaining.isNotEmpty) {
          flower = remaining.first;
        }
      }
    });

    _refreshBouquet();
  }

  // =========================================================
  // WRAPPING PAPER
  // =========================================================

  Widget _buildWrapperChoices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wrapperPrices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final name = wrapperPrices.keys.elementAt(index);
        final price = wrapperPrices[name]!;
        final selected = wrapper == name;
        final color = wrapperColors[name]!;

        return _buildSelectableCard(
          selected: selected,
          onTap: () {
            setState(() => wrapper = name);
            _refreshBouquet();
          },
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: name == 'Putih'
                              ? const Color(0xFFE5DCD8)
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      child: Icon(
                        wrapperIcons[name]!,
                        size: 27,
                        color: name == 'Hitam Premium'
                            ? Colors.white
                            : const Color(0xFF9B667A),
                      ),
                    ),
                  ),
                  if (selected)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.pinkDark,
                        size: 19,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(price),
                style: const TextStyle(
                  color: AppColors.pinkDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // PILIHAN PITA
  // =========================================================

  Widget _buildRibbonChoices() {
    return Column(
      children: ribbonPrices.entries.map((entry) {
        final name = entry.key;
        final selected = ribbon == name;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildSelectableCard(
            selected: selected,
            onTap: () {
              setState(() => ribbon = name);
              _refreshBouquet();
            },
            child: Row(
              children: [
                _illustrationTile(
                  icon: ribbonIcons[name]!,
                  color: ribbonColors[name]!,
                  selected: selected,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        entry.value == 0
                            ? 'Tanpa tambahan biaya'
                            : formatRupiah(entry.value),
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: selected
                      ? AppColors.pinkDark
                      : AppColors.textLight,
                  size: 21,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================================================
  // PILIHAN AKSESORI
  // =========================================================

  Widget _buildAccessoryChoices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: accessoryPrices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.12,
      ),
      itemBuilder: (context, index) {
        final name = accessoryPrices.keys.elementAt(index);
        final price = accessoryPrices[name]!;
        final selected = accessory == name;

        return _buildSelectableCard(
          selected: selected,
          onTap: () {
            setState(() => accessory = name);
            _refreshBouquet();
          },
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 43,
                      decoration: BoxDecoration(
                        color: AppColors.pinkLight.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        accessoryIcons[name]!,
                        color: AppColors.pinkDark,
                        size: 24,
                      ),
                    ),
                  ),
                  if (selected)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.pinkDark,
                        size: 18,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                price == 0 ? 'Gratis' : formatRupiah(price),
                style: const TextStyle(
                  color: AppColors.pinkDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // KARTU PILIHAN
  // =========================================================

  Widget _buildSelectableCard({
    required bool selected,
    required VoidCallback onTap,
    required Widget child,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFFFF6F8)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected
              ? AppColors.pinkDark.withValues(alpha: 0.65)
              : AppColors.divider,
          width: selected ? 1.4 : 1,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: AppColors.pinkDark.withValues(alpha: 0.045),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ILUSTRASI IKON PILIHAN
  // =========================================================

  Widget _illustrationTile({
    required IconData icon,
    required Color color,
    required bool selected,
  }) {
    return Container(
      width: 57,
      height: 57,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.24),
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 5,
            top: 5,
            child: Icon(
              Icons.auto_awesome,
              size: 11,
              color: color.withValues(alpha: 0.65),
            ),
          ),
          Icon(
            icon,
            size: 31,
            color: color,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RINGKASAN HARGA
  // =========================================================

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.pinkLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkDark.withValues(alpha: 0.045),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: AppColors.pinkDark,
                size: 21,
              ),
              SizedBox(width: 9),
              Text(
                'Ringkasan Harga',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Rincian biaya desain buket pilihanmu.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 17),

          ...flowerQuantities.entries
              .where((entry) => entry.value > 0)
              .map(
                (entry) => _priceRow(
                  '${entry.key} × ${entry.value} tangkai',
                  flowerPrices[entry.key]! * entry.value,
                ),
              ),

          _priceRow('Pembungkus · $wrapper', wrapperPrices[wrapper]!),
          _priceRow('Pita · $ribbon', ribbonPrices[ribbon]!),
          _priceRow(accessory, accessoryPrices[accessory]!),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              color: AppColors.divider,
            ),
          ),

          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL HARGA',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Estimasi biaya buket',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    formatRupiah(totalPrice),
                    key: ValueKey<int>(totalPrice),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: AppColors.pinkDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatRupiah(amount),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DIALOG RINGKASAN
  // =========================================================

  void _showSummary() {
    if (totalQuantity < 3) {
      _showMessage('Pilih minimal 3 tangkai bunga untuk buketmu.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(21),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: AppColors.pinkLight,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: const Icon(
                      Icons.local_florist_rounded,
                      color: AppColors.pinkDark,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Your Bouquet Design',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Berikut detail buket pilihanmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 19),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      children: [
                        ...flowerQuantities.entries
                            .where((entry) => entry.value > 0)
                            .map(
                              (entry) => _dialogRow(
                                '${entry.key} (${entry.value} tangkai)',
                                formatRupiah(
                                  flowerPrices[entry.key]! *
                                      entry.value,
                                ),
                              ),
                            ),
                        _dialogRow('Pembungkus', wrapper),
                        _dialogRow('Pita', ribbon),
                        _dialogRow('Aksesori', accessory),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                        ),

                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total estimasi',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                formatRupiah(totalPrice),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: AppColors.pinkDark,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 19),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.pinkDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PESAN
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.pinkDark,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
