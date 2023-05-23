import 'dart:ffi';

class All_Data {
  String? Link;
  String? Name;
  String? Image;
  String? Color;
  String? Full_prices;
  String? Company;
  String? Description;
  String? Gender;
  String? Seller;
  String? Sp_Filter;
  String? Type;

  All_Data(
      {this.Link,
      this.Name,
      this.Image,
      this.Color,
      this.Company,
      this.Description,
      this.Gender,
      this.Seller,
      this.Sp_Filter,
      this.Type,
      });

  All_Data.fromJson(Map<String,dynamic> json)
  {
    Link = json['Link'];
    Name = json['Name'];
    Image = json['Image'];
    Color = json['Color'];
    Full_prices = json['Full_prices'];
    Description = json['Description'];
    Type = json['Type'];
    Company = json['Company'];
    Gender = json['Gender'];
    Seller = json['Seller'];
    Sp_Filter = json['Sp_filter'];
  }
}

