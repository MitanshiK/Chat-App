class ProductsModel {
  int? id;
  String? title;
  String? description;
  String? category;
  double? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  List<String>? tags;
  String? brand;
  String? sku;
  int? weight;
  // Dimensions? dimensions;
  String? warrantyInformation;
  String? shippingInformation;
  String? availabilityStatus;
  // List<Reviews>? reviews;
  String? returnPolicy;
  int? minimumOrderQuantity;
  Meta? meta;
  List<String>? images;
  String? thumbnail;

  ProductsModel({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    // this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    // this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  
  ProductsModel.fromMap(Map<String, dynamic> mapData) {
   
      id = mapData["id"];
      title = mapData["title"];
      description = mapData["description"];
      category = mapData["category"];
      price = mapData["price"]?.toDouble();
      discountPercentage = mapData["discountPercentage"]?.toDouble();
      rating = mapData["rating"]?.toDouble();
      stock = mapData["stock"];
      tags = mapData["tags"] == null ? null : List<String>.from(mapData["tags"]);
      brand = mapData["brand"];
      sku = mapData["sku"];
      weight = mapData["weight"];
      // dimensions = mapData["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
      warrantyInformation = mapData["warrantyInformation"];
      shippingInformation = mapData["shippingInformation"];
      availabilityStatus = mapData["availabilityStatus"];
      // reviews = mapData["reviews"] == null ? null : (json["reviews"] as List).map((e) => Reviews.fromJson(e)).toList(),
      returnPolicy = mapData["returnPolicy"];
      minimumOrderQuantity = mapData["minimumOrderQuantity"];
      meta = mapData["meta"] == null ? null : Meta.fromJson(mapData["meta"]);
      images = mapData["images"] == null ? null : List<String>.from(mapData["images"]);
      thumbnail = mapData["thumbnail"];

  }


  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      category: json["category"],
      price: json["price"]?.toDouble(),
      discountPercentage: json["discountPercentage"]?.toDouble(),
      rating: json["rating"]?.toDouble(),
      stock: json["stock"],
      tags: json["tags"] == null ? null : List<String>.from(json["tags"]),
      brand: json["brand"],
      sku: json["sku"],
      weight: json["weight"],
      // dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
      warrantyInformation: json["warrantyInformation"],
      shippingInformation: json["shippingInformation"],
      availabilityStatus: json["availabilityStatus"],
      // reviews: json["reviews"] == null ? null : (json["reviews"] as List).map((e) => Reviews.fromJson(e)).toList(),
      returnPolicy: json["returnPolicy"],
      minimumOrderQuantity: json["minimumOrderQuantity"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      images: json["images"] == null ? null : List<String>.from(json["images"]),
      thumbnail: json["thumbnail"],
    );
  }



  // Map<String, dynamic> toMap() {
  //   return {
  //   "chatRoomId": chatRoomId, 
  //   "participantsId": participantsId,
  //    "lastMessage": lastMessage,
  //     "lastTime": lastTime
     
  //   };
    
  // }


  Map<String, dynamic> toMap() {
return{
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "discountPercentage": discountPercentage,
    "rating": rating,
    "stock": stock,
    // if (tags != null) {
      "tags": tags,
    // }
    "brand": brand,
    "sku": sku,
    "weight": weight,
    // if (dimensions != null) {
    //   "dimensions": dimensions?.toJson();
    // }
    "warrantyInformation": warrantyInformation,
    "shippingInformation": shippingInformation,
    "availabilityStatus": availabilityStatus,
    // if (reviews != null) {
    //   "reviews": reviews?.map((e) => e.toJson()).toList();
    // }
    "returnPolicy": returnPolicy,
    "minimumOrderQuantity": minimumOrderQuantity,
    // // if (meta != null) {
    //   "meta": meta?.to(),
    // }
    // if (images != null) {
      "images": images,
    // }
    "thumbnail": thumbnail
  };
  
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["description"] = description;
    data["category"] = category;
    data["price"] = price;
    data["discountPercentage"] = discountPercentage;
    data["rating"] = rating;
    data["stock"] = stock;
    if (tags != null) {
      data["tags"] = tags;
    }
    data["brand"] = brand;
    data["sku"] = sku;
    data["weight"] = weight;
    // if (dimensions != null) {
    //   data["dimensions"] = dimensions?.toJson();
    // }
    data["warrantyInformation"] = warrantyInformation;
    data["shippingInformation"] = shippingInformation;
    data["availabilityStatus"] = availabilityStatus;
    // if (reviews != null) {
    //   data["reviews"] = reviews?.map((e) => e.toJson()).toList();
    // }
    data["returnPolicy"] = returnPolicy;
    data["minimumOrderQuantity"] = minimumOrderQuantity;
    if (meta != null) {
      data["meta"] = meta?.toJson();
    }
    if (images != null) {
      data["images"] = images;
    }
    data["thumbnail"] = thumbnail;
    return data;
  }
}

class Meta {
  String? createdAt;
  String? updatedAt;
  String? barcode;
  String? qrCode;

  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      barcode: json["barcode"],
      qrCode: json["qrCode"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    data["barcode"] = barcode;
    data["qrCode"] = qrCode;
    return data;
  }
}

// class Reviews {
//   int? rating;
//   String? comment;
//   String? date;
//   String? reviewerName;
//   String? reviewerEmail;

//   Reviews({this.rating, this.comment, this.date, this.reviewerName, this.reviewerEmail});

//   factory Reviews.fromJson(Map<String, dynamic> json) {
//     return Reviews(
//       rating: json["rating"],
//       comment: json["comment"],
//       date: json["date"],
//       reviewerName: json["reviewerName"],
//       reviewerEmail: json["reviewerEmail"],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["rating"] = rating;
//     data["comment"] = comment;
//     data["date"] = date;
//     data["reviewerName"] = reviewerName;
//     data["reviewerEmail"] = reviewerEmail;
//     return data;
//   }



  
// }

// class Dimensions {
//   double? width;
//   double? height;
//   double? depth;

//   Dimensions({this.width, this.height, this.depth});

//   factory Dimensions.fromJson(Map<String, dynamic> json) {
//     return Dimensions(
//       width: json["width"]?.toDouble(),
//       height: json["height"]?.toDouble(),
//       depth: json["depth"]?.toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["width"] = width;
//     data["height"] = height;
//     data["depth"] = depth;
//     return data;
//   }
// }
