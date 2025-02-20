class ServiceTypes {
  final String image;
  final String title;
  final String description;

  ServiceTypes({
    this.image = 'https://via.placeholder.com/150',  // Using a URL instead of local asset
    this.title = 'Untitled Service',
    this.description = 'No description available',
  });

  factory ServiceTypes.fromJson(Map<String, dynamic> json) {
    return ServiceTypes(
      image: json['image']?.toString() ?? 'https://via.placeholder.com/150',
      title: json['title']?.toString() ?? 'Untitled Service',
      description: json['description']?.toString() ?? 'No description available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'description': description,
    };
  }

  // Optional: Factory for custom default values
  factory ServiceTypes.defaultService() {
    return ServiceTypes(
      image: 'https://via.placeholder.com/150',
      title: 'New Service',
      description: 'This is a default service description',
    );
  }
}