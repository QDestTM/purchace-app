import 'package:sql_test/enums/purchase_category.dart';
import 'package:flutter/material.dart';


const Map<PurchaseCategory, String> categoryId =
{
	PurchaseCategory.none           : "none",
	PurchaseCategory.food           : "food",
	PurchaseCategory.electronics    : "electronics",
	PurchaseCategory.clothing       : "clothing",
	PurchaseCategory.cosmetics      : "cosmetics",
	PurchaseCategory.homeAppliances : "home_appliances",
	PurchaseCategory.books          : "books",
	PurchaseCategory.toys           : "toys",
	PurchaseCategory.furniture      : "furniture",
	PurchaseCategory.autoAccesories : "auto_accesories",
	PurchaseCategory.sports         : "sports",
	PurchaseCategory.medicine       : "medicine",
	PurchaseCategory.pets           : "pets",
	PurchaseCategory.stationery     : "stationery",
};


const Map<String, PurchaseCategory> categoryEnum =
{
	"none"            : PurchaseCategory.none,
	"food"            : PurchaseCategory.food,
	"electronics"     : PurchaseCategory.electronics,
	"clothing"        : PurchaseCategory.clothing,
	"cosmetics"       : PurchaseCategory.cosmetics,
	"home_appliances" : PurchaseCategory.homeAppliances,
	"books"           : PurchaseCategory.books,
	"toys"            : PurchaseCategory.toys,
	"furniture"       : PurchaseCategory.furniture,
	"auto_accesories" : PurchaseCategory.autoAccesories,
	"sports"          : PurchaseCategory.sports,
	"medicine"        : PurchaseCategory.medicine,
	"pets"            : PurchaseCategory.pets,
	"stationery"      : PurchaseCategory.stationery,
};


const Map<PurchaseCategory, String> categoryName =
{
	PurchaseCategory.none           : "Не обрано",
	PurchaseCategory.food           : "Продукти",
	PurchaseCategory.electronics    : "Електроніка",
	PurchaseCategory.clothing       : "Одяг",
	PurchaseCategory.cosmetics      : "Косметика",
	PurchaseCategory.homeAppliances : "Побутова техніка",
	PurchaseCategory.books          : "Книги",
	PurchaseCategory.toys           : "Іграшки",
	PurchaseCategory.furniture      : "Меблі",
	PurchaseCategory.autoAccesories : "Авто та аксесуари",
	PurchaseCategory.sports         : "Спорт",
	PurchaseCategory.medicine       : "Медицина",
	PurchaseCategory.pets           : "Зоотовари",
	PurchaseCategory.stationery     : "Канцелярія",
};


const Map<PurchaseCategory, IconData> categoryIcon =
{
	PurchaseCategory.none           : Icons.filter_alt,
	PurchaseCategory.food           : Icons.shopping_cart_outlined,
	PurchaseCategory.electronics    : Icons.devices,
	PurchaseCategory.clothing       : Icons.checkroom,
	PurchaseCategory.cosmetics      : Icons.brush,
	PurchaseCategory.homeAppliances : Icons.blender,
	PurchaseCategory.books          : Icons.menu_book,
	PurchaseCategory.toys           : Icons.toys,
	PurchaseCategory.furniture      : Icons.chair,
	PurchaseCategory.autoAccesories : Icons.directions_car,
	PurchaseCategory.sports         : Icons.fitness_center,
	PurchaseCategory.medicine       : Icons.medication,
	PurchaseCategory.pets           : Icons.pets,
	PurchaseCategory.stationery     : Icons.school,
};
