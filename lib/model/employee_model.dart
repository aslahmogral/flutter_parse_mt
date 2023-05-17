class employeeModel {
  String? className;
  String? objectId;
  String? createdAt;
  String? updatedAt;
  String? name;
  int? rating;
  int? age;

  employeeModel(
      {this.className,
      this.objectId,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.rating,
      this.age});

  employeeModel.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    rating = json['rating'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    data['objectId'] = this.objectId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['age'] = this.age;
    return data;
  }
}
