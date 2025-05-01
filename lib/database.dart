import 'package:sql_test/constants/category_data.dart';
import 'package:sql_test/models/purchase_data.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseAccess extends ChangeNotifier
{
	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	late final Database _database;
	final String dbPath;

	bool _dbInitialized = false;

	// Constructors
	DatabaseAccess({
		required this.dbPath
	});

	// # ----------------------------------------------------------------------------------------------------<

	Future<List<PurchaseData>> sequence() async
	{
		final queryResult = await _database.rawQuery("SELECT * FROM products");

		// Use map to convert query into list of purchase data
		final mapping = queryResult.map((element)
		{
			final date = DateTime.fromMillisecondsSinceEpoch(element["date"] as int);
			final category = categoryEnum[element["category"] as String]!;

			return PurchaseData(
				id : element["id"] as int,
				name: element["name"] as String,
				price: element["price"] as double,
				quantity: element["quantity"] as int,
				category: category,
				date: date
			);
		});

		return mapping.toList();
	}


	Future<void> append(PurchaseData data) async
	{
		final maxIdQuery = await _database.rawQuery(
			"SELECT MAX(id) FROM products");

		// Current max id + 1 will be an id of added data
		final maxId = Sqflite.firstIntValue(maxIdQuery);

		await _database.insert("products", {
			"id" : maxId == null ? 0 : (maxId + 1),
			"name" : data.name,
			"category" : categoryId[data.category]!,
			"price" : data.price,
			"quantity" : data.quantity,
			"date" : data.date.millisecondsSinceEpoch
		});

		// Notify about changes in database
		notifyListeners();
	}


	Future<void> update(PurchaseData data) async
	{
		await _database.update("products", {
			"name" : data.name,
			"category" : categoryId[data.category]!,
			"price" : data.price,
			"quantity" : data.quantity,
			"date" : data.date.millisecondsSinceEpoch
		},
			where: "id = ?",
			whereArgs: [data.id]
		);

		// Notify about changes in database
		notifyListeners();
	}


	Future<void> remove(PurchaseData data) async
	{
		await _database.delete("products",
			where: "id = ?", whereArgs: [data.id]
		);

		// Notify about changes in database
		notifyListeners();
	}

	// ------------------------------------------------------------------------------------------------------<

	Future<int> init() async
	{
		if (_dbInitialized) return 0;

		// Initializing database
		_database = await openDatabase(
			dbPath, version: 1,

			onCreate: (db, version)
			{
				db.execute("""
					CREATE TABLE products (
						id INTEGER PRIMARY KEY,
						name TEXT NOT NULL,
						category TEXT NOT NULL,
						price REAL NOT NULL,
						quantity INTEGER NOT NULL,
						date INTEGER NOT NULL
					)
				""");
			}
		);

		_dbInitialized = true;
		return 0;
	}


	Future<int> close() async
	{
		if (!_dbInitialized) return -1;
		await _database.close();

		_dbInitialized = false;
		return 0;
	}

	// ------------------------------------------------------------------------------------------------------<
}
