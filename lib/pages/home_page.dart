import 'package:sql_test/widgets/purchase_display.dart';
import 'package:sql_test/widgets/append_button.dart';
import 'package:sql_test/models/purchase_data.dart';
import 'package:sql_test/widgets/input_modal.dart';

import 'package:sql_test/database.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	// Constructors
	const HomePage({
		super.key
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<HomePage> createState() => HomePageState();

	// ------------------------------------------------------------------------------------------------------<
}


class HomePageState extends State<HomePage>
{
	static const double displaySpacing = 8.0;
	static const double displayHeight = 96.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final DatabaseAccess _database = DatabaseAccess(dbPath: "appdata.db");

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void dispose()
	{
		super.dispose();

		// Closing database
		_database.close();
	}

	// @ ----------------------------------------------------------------------------------------------------<

	void _showInputModal(BuildContext context, PurchaseData? data)
	{
		final inputCallback = (data == null)
			? _database.append : _database.update;

		// Create modal sheet for data input
		showModalBottomSheet(
			context: context,

			isScrollControlled: true,
			isDismissible: true,
			enableDrag: false,

			builder: (_) => InputModal(
				updateData: data, inputCallback: inputCallback
			)
		);
	}


	Widget _buildProgressIndicator(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Center(
			child: CircularProgressIndicator(
				color: scheme.secondaryFixed,
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildBodyListView(BuildContext context)
	{
		// Building tree of widgets
		return FutureBuilder(
			future: _database.sequence(),

			builder: (context, snapshot)
			{
				if (!snapshot.hasData) {
					return _buildProgressIndicator(context);
				}

				final itemsList = snapshot.data ?? [];

				// Building tree of widgets
				return ListView.builder(
					padding: const EdgeInsets.all(12.0),

					itemExtent: displayHeight + displaySpacing,
					itemCount: itemsList.length,

					itemBuilder: (context, index)
					{
						final data = itemsList.elementAt(index);

						// Building tree of widgets
						return Padding(
							padding: const EdgeInsets.only(
								bottom: displaySpacing
							),

							child: PurchaseDisplay(
								vkey: ValueKey<int>(data.id),
								data: data, height: displayHeight,

								onUpdateAction: () {
									_showInputModal(context, data);
								},

								onDeleteAction: () {
									_database.remove(data);
								},
							),
						);
					},
				);
			},
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildScaffoldBody(BuildContext context)
	{
		// Building tree of widgets
		return FutureBuilder(
			future: _database.init(),

			builder: (context, snapshot)
			{
				if ( !snapshot.hasData ) {
					return _buildProgressIndicator(context);
				}

				// Building tree of widgets
				return ListenableBuilder(
					listenable: _database,

					builder: (context, _) {
						return _buildBodyListView(context);
					},
				);
			},
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Scaffold(
			appBar: AppBar(
				backgroundColor: scheme.secondaryFixed,
			),

			// Main part of app widgets
			body: _buildScaffoldBody(context),

			floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
			resizeToAvoidBottomInset: false,

			// Bottom part of app widgets
			floatingActionButton: AppendButton(
				size: 76,

				onPressed: () {
					_showInputModal(context, null);
				},
			),

			bottomNavigationBar: BottomAppBar(
				color: scheme.secondaryFixed,
				notchMargin: 10, height: 56,

				shape: const CircularNotchedRectangle(),
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
