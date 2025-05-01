import 'package:sql_test/enums/purchase_category.dart';
import 'package:flutter/material.dart';


class PurchaseData
{
	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final int id;

	final String name;
	final PurchaseCategory category;

	final double price;
	final int quantity;

	final DateTime date;

	// Properties
	TimeOfDay get time => TimeOfDay.fromDateTime(date);

	// Contstructors
	const PurchaseData({
		required this.name,
		required this.category,

		required this.price,
		required this.quantity,

		required this.date,
		this.id = 0
	});

	// ------------------------------------------------------------------------------------------------------<
}
