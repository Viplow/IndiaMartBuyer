import 'models/listing_item.dart';
import 'models/company.dart';
import 'models/home_models.dart';

class MockData {
  static const String placeholderImage = 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400';
  static const String placeholderBanner = 'https://images.unsplash.com/photo-1565793298595-6a879b1d2a0f?w=800';
  static const String placeholderLogo = 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200';

  static List<ListingItem> get listings => [
        const ListingItem(
          id: '1',
          title: 'Industrial CNC Milling Machine 5-Axis',
          imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400',
          priceRange: '₹12,50,000 – ₹18,00,000 / unit',
          moq: 'MOQ: 1 unit',
          supplierName: 'Precision Tools India',
          verified: true,
          location: 'Mumbai, Maharashtra',
          category: 'Machinery',
        ),
        const ListingItem(
          id: '2',
          title: 'Raw Steel Coils CRCA Grade',
          imageUrl: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=400',
          priceRange: '₹58 – ₹72 / kg',
          moq: 'MOQ: 5 tonnes',
          supplierName: 'Metallurgy Solutions',
          verified: true,
          location: 'Jamshedpur, Jharkhand',
          category: 'Raw Materials',
        ),
        const ListingItem(
          id: '3',
          title: 'Hydraulic Press 100 Ton Capacity',
          imageUrl: 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=400',
          priceRange: '₹8,00,000 – ₹15,00,000',
          moq: 'MOQ: 1 unit',
          supplierName: 'Heavy Equip Co',
          verified: false,
          location: 'Pune, Maharashtra',
          category: 'Machinery',
        ),
        const ListingItem(
          id: '4',
          title: 'HDPE Granules Virgin Grade',
          imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
          priceRange: '₹95 – ₹112 / kg',
          moq: 'MOQ: 500 kg',
          supplierName: 'Polymer World',
          verified: true,
          location: 'Vadodara, Gujarat',
          category: 'Raw Materials',
        ),
        const ListingItem(
          id: '5',
          title: 'Industrial Conveyor Belt System',
          imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400',
          priceRange: '₹2,50,000 – ₹6,00,000',
          moq: 'MOQ: 1 set',
          supplierName: 'ConveyTech Systems',
          verified: true,
          location: 'Chennai, Tamil Nadu',
          category: 'Industrial Goods',
        ),
        const ListingItem(
          id: '6',
          title: 'Copper Wire 99.9% Pure',
          imageUrl: 'https://images.unsplash.com/photo-1596495578065-6e0763fa16b1?w=400',
          priceRange: '₹720 – ₹850 / kg',
          moq: 'MOQ: 100 kg',
          supplierName: 'Prime Cables Ltd',
          verified: false,
          location: 'Delhi NCR',
          category: 'Raw Materials',
        ),
      ];

  static CompanyProfile get companyProfile => CompanyProfile(
        id: 'c1',
        name: 'Prakash Machineries Private Limited',
        tagline: 'Transformative Engineering',
        logoUrl: placeholderLogo,
        bannerUrl: placeholderBanner,
        verified: true,
        yearsInBusiness: '12 yrs',
        rating: '4.1',
        ratingCount: '259',
        responseRate: '74%',
        gstNumber: 'GST 06AABCA0227HIZA',
        certifications: ['ISO 9001', 'CE Certified', 'Make in India'],
        location: 'Faridabad',
        products: [
          CompanyProduct(
            id: 'p1',
            name: 'CNC Milling Machine 5-Axis',
            imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400',
            priceRange: '₹12.5L – ₹18L',
            moq: '1 unit',
          ),
          CompanyProduct(
            id: 'p2',
            name: 'Lathe Machine Heavy Duty',
            imageUrl: 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=400',
            priceRange: '₹6L – ₹9L',
            moq: '1 unit',
          ),
          CompanyProduct(
            id: 'p3',
            name: 'Drilling Machine Column Type',
            imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400',
            priceRange: '₹1.2L – ₹2.5L',
            moq: '2 units',
          ),
        ],
        galleryUrls: [
          'https://images.unsplash.com/photo-1565793298595-6a879b1d2a0f?w=600',
          'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600',
          'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=600',
        ],
        about:
            'Precision Tools India is a leading manufacturer and supplier of industrial CNC machinery, lathes, and automation equipment. We serve OEMs and large-scale manufacturers across India and export to South Asia.',
      );

  // Home screen (static content for SDUI)
  static const String homeUserName = 'Rajesh Kumar';

  static List<EnquiryItem> get enquiries => const [
        EnquiryItem(
          id: '1',
          title: 'Web Development Services',
          supplierName: 'TechNova Solutions',
          status: 'Responded',
          timeAgo: '2h ago',
          statusColor: 'green',
        ),
        EnquiryItem(
          id: '2',
          title: 'Industrial Machinery Quote',
          supplierName: 'Heavy Equip Co',
          status: 'Pending',
          timeAgo: '5h ago',
          statusColor: 'orange',
        ),
        EnquiryItem(
          id: '3',
          title: 'Raw Material Inquiry',
          supplierName: 'Metallurgy Solutions',
          status: 'Viewed',
          timeAgo: '1d ago',
          statusColor: 'blue',
        ),
      ];

  static List<RecommendedItem> get recommended => const [
        RecommendedItem(
          id: '1',
          title: 'Online Mobile Development',
          imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400',
          priceDisplay: '10,000 / 12 Days',
          supplierName: 'WebCraft Solutions',
          rating: '4.7',
          verified: true,
          trustedSeller: true,
          location: 'Mumbai, Maharashtra',
          reviewCount: '156 reviews',
          priceRange: '₹25,000 - ₹2,00,000',
          responseTime: 'Replies in 2 hrs',
          descriptionSnippet: 'A mobile application developed for an Android/iOS device is called an Android/iOS app. Android is a mobile operating system...',
        ),
        RecommendedItem(
          id: '2',
          title: 'Digital Marketing Service',
          imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
          priceDisplay: '14,000 / 16 Days',
          supplierName: 'AppForge India',
          rating: '4.8',
          verified: true,
          trustedSeller: true,
          location: 'Bangalore, Karnataka',
          reviewCount: '89 reviews',
          priceRange: '₹50,000 - ₹5,00,000',
          responseTime: 'Replies in 1 hr',
          descriptionSnippet: 'Digital marketing is the component of marketing that utilizes the internet and online-based digital technologies such as desktop...',
        ),
        RecommendedItem(
          id: '3',
          title: 'Cloud Computing Services',
          imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
          priceDisplay: '20,000 / 40 Days',
          supplierName: 'CloudTech Services',
          rating: '4.9',
          verified: true,
          trustedSeller: false,
          location: 'Hyderabad, Telangana',
          reviewCount: '42 reviews',
          priceRange: '₹1,00,000 - ₹10,00,000',
          responseTime: 'Replies in 4 hrs',
          descriptionSnippet: 'Cloud computing is the on-demand availability of computer system resources, especially data storage and computing power...',
        ),
        RecommendedItem(
          id: '4',
          title: 'ERP Implementations',
          imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400',
          priceDisplay: '18,000 / 12 Days',
          supplierName: 'GrowthMarketers',
          rating: '4.7',
          verified: true,
          trustedSeller: true,
          location: 'Delhi NCR',
          reviewCount: '203 reviews',
          priceRange: '₹15,000 - ₹1,50,000',
          responseTime: 'Replies in 3 hrs',
          descriptionSnippet: 'ERP systems integrate all facets of an operation, including product planning, development, manufacturing, sales and marketing...',
        ),
      ];

  static List<ContinueCategory> get continueCategories => const [
        ContinueCategory(
          id: '1',
          title: 'Web Development',
          subtitle: 'IT Services',
          sellerCount: '2,450 sellers',
        ),
        ContinueCategory(
          id: '2',
          title: 'Industrial Machinery',
          subtitle: 'Manufacturing',
          sellerCount: '1,820 sellers',
        ),
        ContinueCategory(
          id: '3',
          title: 'Raw Materials',
          subtitle: 'Commodities',
          sellerCount: '3,100 sellers',
        ),
      ];

  static List<TrendingItem> get trending => const [
        TrendingItem(rank: 1, name: 'AI/ML Services', sellerCount: '340 sellers', growthPercent: '+45%'),
        TrendingItem(rank: 2, name: 'Cybersecurity Solutions', sellerCount: '189 sellers', growthPercent: '+32%'),
        TrendingItem(rank: 3, name: 'Green Energy Equipment', sellerCount: '521 sellers', growthPercent: '+28%'),
        TrendingItem(rank: 4, name: 'Packaging Automation', sellerCount: '276 sellers', growthPercent: '+21%'),
        TrendingItem(rank: 5, name: 'Industrial IoT', sellerCount: '412 sellers', growthPercent: '+18%'),
      ];

  static List<BrowseCategory> get browseCategories => const [
        BrowseCategory(id: '1', name: 'Web Development', iconKey: 'code'),
        BrowseCategory(id: '2', name: 'Digital Marketing', iconKey: 'campaign'),
        BrowseCategory(id: '3', name: 'UI/UX Design', iconKey: 'palette'),
        BrowseCategory(id: '4', name: 'Industrial Machinery', iconKey: 'precision_manufacturing'),
        BrowseCategory(id: '5', name: 'Raw Materials', iconKey: 'layers'),
        BrowseCategory(id: '6', name: 'Packaging', iconKey: 'inventory_2'),
        BrowseCategory(id: '7', name: 'Electrical', iconKey: 'electrical_services'),
        BrowseCategory(id: '8', name: 'Chemicals', iconKey: 'science'),
      ];

  /// Bicycle spare parts – search listing (photo medium imp, 3 ISQs, overlay: GST Verified + TrustSEAL).
  static List<SearchProductItem> get searchProductsBicycleSpareParts => const [
        SearchProductItem(
          id: 'bp1',
          title: 'Premium Bicycle Chain Set - 6/7/8...',
          imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=400',
          price: '₹180',
          priceUnit: 'per piece',
          isqs: ['Speed Compatibility: 6/7/8 Speed', 'Material: Alloy Steel', 'Links: 116 Links'],
          supplierName: 'Shri Balaji Cycle ...',
          rating: '4.8',
          location: 'Ludhiana, Punjab',
          verified: true,
          trustedSeller: true,
        ),
        SearchProductItem(
          id: 'bp2',
          title: 'MTB Brake Pads Set - V-Brake...',
          imageUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?w=400',
          price: '₹85',
          priceUnit: 'per pair',
          isqs: ['Type: V-Brake', 'Material: Rubber Compound', 'Length: 70mm'],
          supplierName: 'Royal Cycle Acce...',
          rating: '4.6',
          location: 'Delhi NCR',
          verified: true,
          trustedSeller: true,
        ),
      ];

  /// Paper making machine – search listing (photo important), TrustSEAL, GST Verified, 3 ISQs.
  static List<SearchProductItem> get searchProductsPaperMakingMachine => const [
        SearchProductItem(
          id: 'pm1',
          title: 'Electric Honeycomb Paper Machine VPS-HC20pro',
          imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600',
          price: '₹70,000',
          priceUnit: 'unit',
          isqs: ['Type: Honeycomb Paper', 'Automation: Electric', 'Capacity: 20 sheets/min'],
          supplierName: 'Vijay Packaging System',
          rating: '4.2',
          location: 'Thiruvananthapuram',
          verified: true,
          trustedSeller: true,
        ),
        SearchProductItem(
          id: 'pm2',
          title: 'Semi-Auto Paper Cup Making Machine',
          imageUrl: 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=600',
          price: '₹2,50,000',
          priceUnit: 'piece',
          isqs: ['Output: 30-40 cups/min', 'Power: 3.5 kW', 'Material: SS 304'],
          supplierName: 'Prakash Offset',
          rating: '4.5',
          location: 'Faridabad',
          verified: true,
          trustedSeller: true,
        ),
      ];
}
