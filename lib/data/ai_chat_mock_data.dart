/// Mock data used to build context for the AI chat (sellers, FAQ).

class AiChatSeller {
  final String category;
  final String location;
  final String supplierName;
  final String productTitle;
  final String priceRange;
  final String? moq;
  /// Company or product page URL (e.g. from IndiaMART). Shown as tappable link in chat.
  final String? url;
  /// Optional image URL (e.g. og:image or listing thumbnail) for card display.
  final String? imageUrl;
  /// Optional short description (e.g. og:description) for card display.
  final String? description;

  const AiChatSeller({
    required this.category,
    required this.location,
    required this.supplierName,
    required this.productTitle,
    required this.priceRange,
    this.moq,
    this.url,
    this.imageUrl,
    this.description,
  });

  factory AiChatSeller.fromJson(Map<String, dynamic> json) {
    return AiChatSeller(
      category: json['category'] as String? ?? '',
      location: json['location'] as String? ?? '',
      supplierName: json['supplierName'] as String? ?? '',
      productTitle: json['productTitle'] as String? ?? '',
      priceRange: json['priceRange'] as String? ?? '',
      moq: json['moq'] as String?,
      url: json['url'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
    );
  }
}

class AiChatFaqEntry {
  final List<String> keywords;
  final String answer;

  const AiChatFaqEntry({required this.keywords, required this.answer});
}

class AiChatMockData {
  AiChatMockData._();

  static const List<AiChatSeller> sellers = [
    // Rice
    AiChatSeller(
      category: 'Rice',
      location: 'Noida',
      supplierName: 'Agro Foods Noida',
      productTitle: 'Basmati Rice',
      priceRange: '₹45 – ₹65 / kg',
      moq: 'MOQ: 100 kg',
    ),
    AiChatSeller(
      category: 'Rice',
      location: 'Noida',
      supplierName: 'North India Grains',
      productTitle: 'Sona Masoori Rice',
      priceRange: '₹38 – ₹52 / kg',
      moq: 'MOQ: 50 kg',
    ),
    AiChatSeller(
      category: 'Rice',
      location: 'Delhi NCR',
      supplierName: 'Delhi Rice Traders',
      productTitle: 'Basmati & Non-basmati',
      priceRange: '₹42 – ₹70 / kg',
      moq: 'MOQ: 25 kg',
    ),
    AiChatSeller(
      category: 'Rice',
      location: 'Mumbai',
      supplierName: 'Western Grains Co',
      productTitle: 'Indrayani Rice',
      priceRange: '₹40 – ₹55 / kg',
      moq: 'MOQ: 100 kg',
    ),
    // Machinery
    AiChatSeller(
      category: 'Machinery',
      location: 'Noida',
      supplierName: 'Precision Tools India',
      productTitle: 'CNC Milling Machine 5-Axis',
      priceRange: '₹12,50,000 – ₹18,00,000 / unit',
      moq: 'MOQ: 1 unit',
    ),
    AiChatSeller(
      category: 'Machinery',
      location: 'Delhi NCR',
      supplierName: 'Heavy Equip Co',
      productTitle: 'Hydraulic Press 100 Ton',
      priceRange: '₹8,00,000 – ₹15,00,000',
      moq: 'MOQ: 1 unit',
    ),
    AiChatSeller(
      category: 'Machinery',
      location: 'Pune',
      supplierName: 'Pune Machine Works',
      productTitle: 'Lathe Machine',
      priceRange: '₹2,50,000 – ₹6,00,000',
      moq: 'MOQ: 1 unit',
    ),
    AiChatSeller(
      category: 'Machinery',
      location: 'Chennai',
      supplierName: 'ConveyTech Systems',
      productTitle: 'Industrial Conveyor Belt',
      priceRange: '₹2,50,000 – ₹6,00,000 / set',
      moq: 'MOQ: 1 set',
    ),
    // Raw Materials
    AiChatSeller(
      category: 'Raw Materials',
      location: 'Noida',
      supplierName: 'Metals & Alloys Noida',
      productTitle: 'Steel Coils CRCA',
      priceRange: '₹58 – ₹72 / kg',
      moq: 'MOQ: 5 tonnes',
    ),
    AiChatSeller(
      category: 'Raw Materials',
      location: 'Delhi NCR',
      supplierName: 'Prime Cables Ltd',
      productTitle: 'Copper Wire 99.9%',
      priceRange: '₹720 – ₹850 / kg',
      moq: 'MOQ: 100 kg',
    ),
    AiChatSeller(
      category: 'Raw Materials',
      location: 'Mumbai',
      supplierName: 'Metallurgy Solutions',
      productTitle: 'Aluminium Ingots',
      priceRange: '₹180 – ₹220 / kg',
      moq: 'MOQ: 500 kg',
    ),
    // Electronics
    AiChatSeller(
      category: 'Electronics',
      location: 'Noida',
      supplierName: 'Tech Components Noida',
      productTitle: 'PCB & Electronic Components',
      priceRange: '₹500 – ₹5,000 / unit',
      moq: 'MOQ: 10 units',
    ),
    AiChatSeller(
      category: 'Electronics',
      location: 'Delhi NCR',
      supplierName: 'Digital Solutions India',
      productTitle: 'Sensors & Modules',
      priceRange: '₹200 – ₹2,000 / piece',
      moq: 'MOQ: 25 pieces',
    ),
    AiChatSeller(
      category: 'Electronics',
      location: 'Bangalore',
      supplierName: 'Bangalore Electronics',
      productTitle: 'LED Drivers & Power Supply',
      priceRange: '₹150 – ₹1,500 / unit',
      moq: 'MOQ: 50 units',
    ),
    // Textiles & Garments
    AiChatSeller(
      category: 'Textiles & Garments',
      location: 'Noida',
      supplierName: 'Noida Textiles',
      productTitle: 'Cotton Fabric',
      priceRange: '₹120 – ₹350 / metre',
      moq: 'MOQ: 100 metres',
    ),
    AiChatSeller(
      category: 'Textiles & Garments',
      location: 'Delhi NCR',
      supplierName: 'Delhi Garments Co',
      productTitle: 'Polyester Yarn',
      priceRange: '₹80 – ₹180 / kg',
      moq: 'MOQ: 50 kg',
    ),
    AiChatSeller(
      category: 'Textiles & Garments',
      location: 'Mumbai',
      supplierName: 'Mumbai Fabrics Ltd',
      productTitle: 'Denim & Twill',
      priceRange: '₹200 – ₹450 / metre',
      moq: 'MOQ: 200 metres',
    ),
    // Chemicals
    AiChatSeller(
      category: 'Chemicals',
      location: 'Noida',
      supplierName: 'Chem Solutions Noida',
      productTitle: 'Industrial Chemicals',
      priceRange: '₹50 – ₹500 / kg',
      moq: 'MOQ: 25 kg',
    ),
    AiChatSeller(
      category: 'Chemicals',
      location: 'Mumbai',
      supplierName: 'Polymer World',
      productTitle: 'HDPE Granules Virgin',
      priceRange: '₹95 – ₹112 / kg',
      moq: 'MOQ: 500 kg',
    ),
    AiChatSeller(
      category: 'Chemicals',
      location: 'Vadodara',
      supplierName: 'Gujarat Chemicals',
      productTitle: 'Caustic Soda & Acids',
      priceRange: '₹40 – ₹120 / kg',
      moq: 'MOQ: 50 kg',
    ),
    // Packaging
    AiChatSeller(
      category: 'Packaging',
      location: 'Noida',
      supplierName: 'Pack Solutions Noida',
      productTitle: 'Corrugated Boxes',
      priceRange: '₹15 – ₹80 / piece',
      moq: 'MOQ: 100 pieces',
    ),
    AiChatSeller(
      category: 'Packaging',
      location: 'Delhi NCR',
      supplierName: 'Delhi Packaging',
      productTitle: 'Flexible Packaging Film',
      priceRange: '₹180 – ₹400 / kg',
      moq: 'MOQ: 100 kg',
    ),
    AiChatSeller(
      category: 'Packaging',
      location: 'Mumbai',
      supplierName: 'Mumbai Pack Co',
      productTitle: 'Shrink Wrap & Stretch Film',
      priceRange: '₹120 – ₹280 / kg',
      moq: 'MOQ: 50 kg',
    ),
    // Construction & Building
    AiChatSeller(
      category: 'Construction & Building',
      location: 'Noida',
      supplierName: 'Noida BuildMart',
      productTitle: 'Cement & Tiles',
      priceRange: '₹300 – ₹800 / bag or sq m',
      moq: 'MOQ: 50 bags',
    ),
    AiChatSeller(
      category: 'Construction & Building',
      location: 'Delhi NCR',
      supplierName: 'Delhi Construction Supply',
      productTitle: 'Steel TMT Bars',
      priceRange: '₹55 – ₹72 / kg',
      moq: 'MOQ: 5 tonnes',
    ),
    AiChatSeller(
      category: 'Construction & Building',
      location: 'Pune',
      supplierName: 'Pune Builders Supply',
      productTitle: 'Sand & Aggregate',
      priceRange: '₹800 – ₹1,500 / tonne',
      moq: 'MOQ: 10 tonnes',
    ),
    // Industrial Equipment
    AiChatSeller(
      category: 'Industrial Equipment',
      location: 'Noida',
      supplierName: 'Industrial Equip Noida',
      productTitle: 'Pumps & Motors',
      priceRange: '₹5,000 – ₹2,00,000',
      moq: 'MOQ: 1 unit',
    ),
    AiChatSeller(
      category: 'Industrial Equipment',
      location: 'Mumbai',
      supplierName: 'Heavy Equip Co',
      productTitle: 'Generators & Compressors',
      priceRange: '₹50,000 – ₹5,00,000',
      moq: 'MOQ: 1 unit',
    ),
    AiChatSeller(
      category: 'Industrial Equipment',
      location: 'Chennai',
      supplierName: 'Chennai Industrial',
      productTitle: 'Boilers & Heat Exchangers',
      priceRange: '₹1,00,000 – ₹15,00,000',
      moq: 'MOQ: 1 unit',
    ),
    // Food & Beverage
    AiChatSeller(
      category: 'Food & Beverage',
      location: 'Noida',
      supplierName: 'Agro Foods Noida',
      productTitle: 'Edible Oils & Spices',
      priceRange: '₹150 – ₹400 / kg',
      moq: 'MOQ: 25 kg',
    ),
    AiChatSeller(
      category: 'Food & Beverage',
      location: 'Delhi NCR',
      supplierName: 'Delhi Food Traders',
      productTitle: 'Pulses & Lentils',
      priceRange: '₹60 – ₹120 / kg',
      moq: 'MOQ: 50 kg',
    ),
    AiChatSeller(
      category: 'Food & Beverage',
      location: 'Mumbai',
      supplierName: 'Western Food Co',
      productTitle: 'Bulk Snacks & Ingredients',
      priceRange: '₹80 – ₹250 / kg',
      moq: 'MOQ: 100 kg',
    ),
    // Plastics & Polymers
    AiChatSeller(
      category: 'Plastics & Polymers',
      location: 'Noida',
      supplierName: 'Polymer World Noida',
      productTitle: 'PP & PE Granules',
      priceRange: '₹85 – ₹110 / kg',
      moq: 'MOQ: 500 kg',
    ),
    AiChatSeller(
      category: 'Plastics & Polymers',
      location: 'Mumbai',
      supplierName: 'Mumbai Polymers',
      productTitle: 'PVC Compound',
      priceRange: '₹90 – ₹130 / kg',
      moq: 'MOQ: 250 kg',
    ),
    AiChatSeller(
      category: 'Plastics & Polymers',
      location: 'Vadodara',
      supplierName: 'Gujarat Plastics',
      productTitle: 'Engineering Plastics',
      priceRange: '₹120 – ₹350 / kg',
      moq: 'MOQ: 100 kg',
    ),
    // Rubber
    AiChatSeller(
      category: 'Rubber',
      location: 'Delhi NCR',
      supplierName: 'Delhi Rubber Co',
      productTitle: 'Natural & Synthetic Rubber',
      priceRange: '₹140 – ₹220 / kg',
      moq: 'MOQ: 100 kg',
    ),
    AiChatSeller(
      category: 'Rubber',
      location: 'Chennai',
      supplierName: 'Chennai Rubber Works',
      productTitle: 'Rubber Sheets & Gaskets',
      priceRange: '₹200 – ₹600 / kg',
      moq: 'MOQ: 50 kg',
    ),
    // Paper & Paper Products
    AiChatSeller(
      category: 'Paper & Paper Products',
      location: 'Noida',
      supplierName: 'Paper Mart Noida',
      productTitle: 'Kraft Paper & Board',
      priceRange: '₹35 – ₹85 / kg',
      moq: 'MOQ: 100 kg',
    ),
    AiChatSeller(
      category: 'Paper & Paper Products',
      location: 'Mumbai',
      supplierName: 'Mumbai Paper Co',
      productTitle: 'Tissue & Napkins',
      priceRange: '₹80 – ₹200 / kg',
      moq: 'MOQ: 50 kg',
    ),
    // Paints & Coatings
    AiChatSeller(
      category: 'Paints & Coatings',
      location: 'Noida',
      supplierName: 'Coatings Noida',
      productTitle: 'Industrial Paints',
      priceRange: '₹200 – ₹600 / litre',
      moq: 'MOQ: 20 litres',
    ),
    AiChatSeller(
      category: 'Paints & Coatings',
      location: 'Delhi NCR',
      supplierName: 'Delhi Paints Ltd',
      productTitle: 'Powder Coating',
      priceRange: '₹150 – ₹400 / kg',
      moq: 'MOQ: 50 kg',
    ),
    // Tools & Hardware
    AiChatSeller(
      category: 'Tools & Hardware',
      location: 'Noida',
      supplierName: 'Noida Tools & Hardware',
      productTitle: 'Power Tools & Fasteners',
      priceRange: '₹500 – ₹25,000 / unit',
      moq: 'MOQ: 10 units',
    ),
    AiChatSeller(
      category: 'Tools & Hardware',
      location: 'Mumbai',
      supplierName: 'Mumbai Hardware Co',
      productTitle: 'Hand Tools & Abrasives',
      priceRange: '₹50 – ₹2,000 / piece',
      moq: 'MOQ: 25 pieces',
    ),
    // Electrical Equipment
    AiChatSeller(
      category: 'Electrical Equipment',
      location: 'Noida',
      supplierName: 'Electricals Noida',
      productTitle: 'Cables & Wires',
      priceRange: '₹30 – ₹200 / metre',
      moq: 'MOQ: 100 metres',
    ),
    AiChatSeller(
      category: 'Electrical Equipment',
      location: 'Delhi NCR',
      supplierName: 'Delhi Electricals',
      productTitle: 'Switchgear & DB',
      priceRange: '₹500 – ₹15,000 / unit',
      moq: 'MOQ: 5 units',
    ),
    AiChatSeller(
      category: 'Electrical Equipment',
      location: 'Bangalore',
      supplierName: 'Bangalore Electrical',
      productTitle: 'Solar Panels & Inverters',
      priceRange: '₹25 – ₹45 / watt',
      moq: 'MOQ: 1 kW',
    ),
    // Safety Equipment
    AiChatSeller(
      category: 'Safety Equipment',
      location: 'Noida',
      supplierName: 'Safety First Noida',
      productTitle: 'PPE & Safety Gear',
      priceRange: '₹100 – ₹2,500 / piece',
      moq: 'MOQ: 10 pieces',
    ),
    AiChatSeller(
      category: 'Safety Equipment',
      location: 'Mumbai',
      supplierName: 'Industrial Safety Co',
      productTitle: 'Fire Extinguishers & Masks',
      priceRange: '₹500 – ₹5,000 / unit',
      moq: 'MOQ: 5 units',
    ),
    // Medical & Pharma
    AiChatSeller(
      category: 'Medical & Pharma',
      location: 'Noida',
      supplierName: 'Pharma Supplies Noida',
      productTitle: 'Pharma Raw Materials',
      priceRange: '₹500 – ₹5,000 / kg',
      moq: 'MOQ: 1 kg',
    ),
    AiChatSeller(
      category: 'Medical & Pharma',
      location: 'Mumbai',
      supplierName: 'Mumbai Pharma Co',
      productTitle: 'Packaging for Pharma',
      priceRange: '₹2 – ₹50 / unit',
      moq: 'MOQ: 1,000 units',
    ),
    // Agriculture
    AiChatSeller(
      category: 'Agriculture',
      location: 'Noida',
      supplierName: 'Agro Inputs Noida',
      productTitle: 'Seeds & Fertilizers',
      priceRange: '₹50 – ₹500 / kg',
      moq: 'MOQ: 25 kg',
    ),
    AiChatSeller(
      category: 'Agriculture',
      location: 'Delhi NCR',
      supplierName: 'Delhi Agri Supply',
      productTitle: 'Pesticides & Equipment',
      priceRange: '₹200 – ₹2,000 / litre or unit',
      moq: 'MOQ: 5 litres',
    ),
    AiChatSeller(
      category: 'Agriculture',
      location: 'Pune',
      supplierName: 'Pune Agri Mart',
      productTitle: 'Tractors & Implements',
      priceRange: '₹2,50,000 – ₹8,00,000',
      moq: 'MOQ: 1 unit',
    ),
    // Auto Parts
    AiChatSeller(
      category: 'Auto Parts',
      location: 'Noida',
      supplierName: 'Auto Parts Noida',
      productTitle: 'Bicycle & Bike Spares',
      priceRange: '₹50 – ₹2,000 / piece',
      moq: 'MOQ: 10 pieces',
    ),
    AiChatSeller(
      category: 'Auto Parts',
      location: 'Delhi NCR',
      supplierName: 'Delhi Auto Parts',
      productTitle: 'Engine & Transmission Parts',
      priceRange: '₹500 – ₹50,000 / piece',
      moq: 'MOQ: 1 piece',
    ),
    AiChatSeller(
      category: 'Auto Parts',
      location: 'Chennai',
      supplierName: 'Chennai Auto Components',
      productTitle: 'OEM Auto Components',
      priceRange: '₹100 – ₹5,000 / piece',
      moq: 'MOQ: 50 pieces',
    ),
    // Furniture & Office
    AiChatSeller(
      category: 'Furniture & Office',
      location: 'Noida',
      supplierName: 'Office Furniture Noida',
      productTitle: 'Office Chairs & Desks',
      priceRange: '₹3,000 – ₹25,000 / unit',
      moq: 'MOQ: 5 units',
    ),
    AiChatSeller(
      category: 'Furniture & Office',
      location: 'Delhi NCR',
      supplierName: 'Delhi Furniture Co',
      productTitle: 'Modular Furniture',
      priceRange: '₹5,000 – ₹50,000 / set',
      moq: 'MOQ: 1 set',
    ),
    // Lab & Scientific
    AiChatSeller(
      category: 'Lab & Scientific',
      location: 'Noida',
      supplierName: 'Lab Equip Noida',
      productTitle: 'Lab Instruments & Glassware',
      priceRange: '₹500 – ₹50,000 / unit',
      moq: 'MOQ: 1 unit',
    ),
    AiChatSeller(
      category: 'Lab & Scientific',
      location: 'Mumbai',
      supplierName: 'Scientific Supplies Mumbai',
      productTitle: 'Testing Equipment',
      priceRange: '₹10,000 – ₹2,00,000',
      moq: 'MOQ: 1 unit',
    ),
  ];

  static const List<AiChatFaqEntry> faq = [
    AiChatFaqEntry(
      keywords: ['moq', 'minimum order', 'minimum order quantity'],
      answer:
          'MOQ stands for Minimum Order Quantity. It is the smallest amount a supplier is willing to sell. For example, "MOQ: 100 kg" means you need to order at least 100 kg. You can see MOQ on each product listing.',
    ),
    AiChatFaqEntry(
      keywords: ['quote', 'price', 'get quote', 'how much', 'cost'],
      answer:
          'To get a quote: use "Get Instant Quotes" on the Home screen, or tap "Get Best Price" on any product. Sellers will respond with their best price and terms.',
    ),
    AiChatFaqEntry(
      keywords: ['payment', 'pay', 'terms', 'advance'],
      answer:
          'Payment terms vary by seller. Common options include advance payment, partial advance with balance on delivery, and credit terms for verified buyers. Discuss directly with the seller via Call or enquiry.',
    ),
    AiChatFaqEntry(
      keywords: ['delivery', 'shipping', 'dispatch', 'how long'],
      answer:
          'Delivery time depends on product, quantity, and seller location. Sellers usually mention typical delivery or reply in 24–48 hours. Use "Call Now" or "Get Best Price" to confirm delivery timelines.',
    ),
    AiChatFaqEntry(
      keywords: ['local', 'near me', 'nearby', 'sellers in'],
      answer:
          'You can find local sellers by using the location filter on the search/listing page (e.g. Noida, Delhi) or by asking me for sellers in a specific city and product category.',
    ),
    AiChatFaqEntry(
      keywords: ['verified', 'gst', 'trustseal'],
      answer:
          'Verified sellers have verified GST details. TrustSEAL is a badge for trusted sellers. Look for these badges on product cards for more reliability.',
    ),
    AiChatFaqEntry(
      keywords: ['category', 'categories', 'what do you have'],
      answer:
          'We have sellers across many categories: Rice, Machinery, Raw Materials, Electronics, Textiles, Chemicals, Packaging, Construction, Industrial Equipment, Food & Beverage, Plastics, Rubber, Paper, Paints, Tools & Hardware, Electrical, Safety, Medical, Agriculture, Auto Parts, Furniture, Lab & Scientific. Ask for a category and city to see local sellers.',
    ),
  ];
}
