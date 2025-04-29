import 'dart:convert';

List<UserInfoData> userInfoDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => UserInfoData.fromJson(item)).toList();
}

String userInfoDataToJson(UserInfoData? data) => json.encode(data!.toJson());

class UserInfoData {
  const UserInfoData({
    this.userId,
    this.type,
    this.district,
    this.firstName,
    this.lastName,
    this.motherLastName,
    this.username,
    this.imageName,
    this.email,
    this.password,
    this.userNumber,
    this.membership,
    this.store,
    this.address,
    this.gallery,
    this.numberPlaced,
    this.numberCard,
    this.dateExpiration,
    this.dataCard,
    this.businessName,
    this.dni,
    this.razonSocial,
    this.ruc,
    this.bankAccount,
    this.bank,
    this.cardNumber,
    this.number,
    this.department,
    this.province,
    this.mobile,
    this.userAddress,
    this.politics,
    this.acceptTerms,
    this.date,
    this.cvc,
    this.status,
    this.viewNoti,
    this.addressGallery,
    this.numberStore,
    this.codDistrito,
    this.codRubro,
    this.codTipoServicio,
    this.idUserCreate,
    this.idRol,
    this.alias,
    this.permiso,
    this.rubroDescripcion,
    this.distritoNombre,
  });

  final int? userId;
  final int? type;
  final String? district;
  final String? firstName;
  final String? lastName;
  final String? motherLastName;
  final String? username;
  final String? imageName;
  final String? email;
  final String? password;
  final String? userNumber;
  final String? membership;
  final String? store;
  final String? address;
  final String? gallery;
  final String? numberPlaced;
  final String? numberCard;
  final String? dateExpiration;
  final String? dataCard;
  final String? businessName;
  final String? dni;
  final String? razonSocial;
  final String? ruc;
  final String? bankAccount;
  final String? bank;
  final String? cardNumber;
  final String? number;
  final String? department;
  final String? province;
  final String? mobile;
  final String? userAddress;
  final String? politics;
  final String? acceptTerms;
  final String? date;
  final String? cvc;
  final int? status;
  final int? viewNoti;
  final String? addressGallery;
  final String? numberStore;
  final String? codDistrito;
  final String? codRubro;
  final String? codTipoServicio;
  final String? idUserCreate;
  final String? idRol;
  final String? alias;
  final String? permiso;
  final String? rubroDescripcion;
  final String? distritoNombre;

  factory UserInfoData.fromJson(Map<String, dynamic> json) => UserInfoData(
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        type: int.tryParse(json['type'].toString()) ?? 0,
        district: json['district'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        motherLastName: json['mother_last_name'] as String?,
        username: json['username'] as String?,
        imageName: json['image_name'] as String?,
        email: json['email'] as String?,
        password: json['password'] as String?,
        userNumber: json['user_number'] as String?,
        membership: json['membership'] as String?,
        store: json['store'] as String?,
        address: json['address'] as String?,
        gallery: json['gallery'] as String?,
        numberPlaced: json['number_placed'] as String?,
        numberCard: json['number_card'] as String?,
        dateExpiration: json['date_expiration'] as String?,
        dataCard: json['data_card'] as String?,
        businessName: json['business_name'] as String?,
        dni: json['dni'] as String?,
        razonSocial: json['razon_social'] as String?,
        ruc: json['ruc'] as String?,
        bankAccount: json['bank_account'] as String?,
        bank: json['bank'] as String?,
        cardNumber: json['card_number'] as String?,
        number: json['number'] as String?,
        department: json['department'] as String?,
        province: json['province'] as String?,
        mobile: json['mobile'] as String?,
        userAddress: json['useraddress'] as String?,
        politics: json['politics'] as String?,
        acceptTerms: json['accept_terms'] as String?,
        date: json['date'] as String?,
        cvc: json['cvc'] as String?,
        status: int.tryParse(json['status'].toString()) ?? 0,
        viewNoti: int.tryParse(json['view_noti'].toString()) ?? 0,
        addressGallery: json['address_gallery'] as String?,
        numberStore: json['number_store'] as String?,
        codDistrito: json['cod_distrito'] as String?,
        codRubro: json['cod_rubro'] as String?,
        codTipoServicio: json['cod_tipo_servicio'] as String?,
        idUserCreate: json['id_user_create'] as String?,
        idRol: json['id_rol'] as String?,
        alias: json['alias'] as String?,
        permiso: json['permiso'] as String?,
        rubroDescripcion: json['rubro_descripcion'] as String?,
        distritoNombre: json['distrito_nombre'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "type": type,
        "district": district,
        "first_name": firstName,
        "last_name": lastName,
        "mother_last_name": motherLastName,
        "username": username,
        "image_name": imageName,
        "email": email,
        "password": password,
        "user_number": userNumber,
        "membership": membership,
        "store": store,
        "address": address,
        "gallery": gallery,
        "number_placed": numberPlaced,
        "number_card": numberCard,
        "date_expiration": dateExpiration,
        "data_card": dataCard,
        "business_name": businessName,
        "dni": dni,
        "razon_social": razonSocial,
        "ruc": ruc,
        "bank_account": bankAccount,
        "bank": bank,
        "card_number": cardNumber,
        "number": number,
        "department": department,
        "province": province,
        "mobile": mobile,
        "useraddress": userAddress,
        "politics": politics,
        "accept_terms": acceptTerms,
        "date": date,
        "cvc": cvc,
        "status": status,
        "view_noti": viewNoti,
        "address_gallery": addressGallery,
        "number_store": numberStore,
        "cod_distrito": codDistrito,
        "cod_rubro": codRubro,
        "cod_tipo_servicio": codTipoServicio,
        "id_user_create": idUserCreate,
        "id_rol": idRol,
        "alias": alias,
        "permiso": permiso,
        "rubro_descripcion": rubroDescripcion,
        "distrito_nombre": distritoNombre,
      };
}
