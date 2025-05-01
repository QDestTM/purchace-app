import 'package:sql_test/constants/category_data.dart';
import 'package:sql_test/models/purchase_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:math';


class PurchaseDisplay extends StatelessWidget
{
	// Final values
	static final timeFormat = DateFormat("dd MMMM yyyyр. HH:mm", "uk");

	// Constants
	static const Radius radius = Radius.circular(8.0);

	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final Function() onUpdateAction;
	final Function() onDeleteAction;

	final ValueKey<int> vkey;
	final PurchaseData data;

	final double height;

	// Constructors
	const PurchaseDisplay({
		required this.vkey,
		required this.data,
		required this.onUpdateAction,
		required this.onDeleteAction,
		required this.height
	})
	: super(key: vkey);

	// # ----------------------------------------------------------------------------------------------------<

	Future<bool> _confirmDismiss(BuildContext context, DismissDirection direction) async
	{
		final theme = Theme.of(context);
		final scheme = theme.colorScheme;

		// Awaiting for result from showDialog call
		final confirm = await showDialog<bool>(
			context: context,

			builder: (context)
			{
				// Building tree of widgets
				return AlertDialog(
					title: Text("Видалення",
						style: theme.textTheme.titleMedium,
						textAlign: TextAlign.center,
					),

					content: Text(
						"Ця дія видалить запис про цю покупку із списку.",
						style: theme.textTheme.bodyMedium
					),

					actions: <Widget>
					[
						TextButton(
							onPressed: () {
								Navigator.of(context).pop<bool>(false);
							},

							child: const Text("Залишити")
						),

						TextButton(
							style: TextButton.styleFrom(
								backgroundColor: scheme.error,
								foregroundColor: scheme.surface
							),

							onPressed: () {
								Navigator.of(context).pop<bool>(true);
							},

							child: const Text("Видалити!")
						),
					],
				);
			},
		);

		return confirm ?? false;
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildTopRow(BuildContext context)
	{
		final theme = Theme.of(context);

		// Building tree of widgets
		return Row(
			spacing: 8.0,

			children: <Widget>
			[
				Icon(categoryIcon[data.category], size: height * 0.5),

				Expanded(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,

						children: <Widget>
						[
							Text(data.name,
								style: theme.textTheme.titleSmall,
							),

							Text(
								"${data.price}€ x ${data.quantity} од.",
								style: theme.textTheme.bodyMedium,
							)
						],
					)
				),
			],
		);
	}


	Widget _buildBotRow(BuildContext context)
	{
		final theme = Theme.of(context);

		// Building tree of widgets
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			crossAxisAlignment: CrossAxisAlignment.center,

			children: <Widget>
			[
				Text(
					categoryName[data.category]!,
					style: theme.textTheme.bodySmall,
				),

				Text(
					timeFormat.format(data.date),
					style: theme.textTheme.bodySmall,

					textAlign: TextAlign.center,
				)
			],
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildContent(BuildContext context)
	{
		// Building tree of widgets
		return Padding(
			padding: EdgeInsets.all(8.0),

			child: Column(
				spacing: 4.0,

				children: <Widget>
				[
					Expanded(flex: 3, child: _buildTopRow(context)),
					Expanded(flex: 1, child: const Divider()),
					Expanded(flex: 1, child: _buildBotRow(context)),
				],
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Define dismiss progress value
		final progressListenable = ValueNotifier<double>(0);

		// Building tree of widgets
		return ValueListenableBuilder(
			valueListenable: progressListenable,

			builder: (context, value, child)
			{
				final color = Color.lerp(
					scheme.secondaryFixed, Colors.red, value)!;

				// Building tree of widgets
				return DecoratedBox(
					decoration: BoxDecoration(
						borderRadius: const BorderRadius.all(radius),
						color: color,
					),

					child: child,
				);
			},

			//* Child of ValueListenableBuilder
			child: Dismissible(
				direction: DismissDirection.startToEnd,
				key: vkey,

				dismissThresholds: {
					DismissDirection.startToEnd : 0.6
				},

				confirmDismiss: (direction) async {
					final confirm = await _confirmDismiss(context, direction);

					if (confirm) onDeleteAction();
					return confirm;
				},

				onUpdate: (details) {
					progressListenable.value = min(details.progress * 1.7, 1.0);
				},

				background: ValueListenableBuilder(
					valueListenable: progressListenable,

					builder: (context, value, child)
					{
						// Building tree of widgets
						return Padding(
							padding: const EdgeInsets.all(10.0),

							child: Align(
								alignment: Alignment.centerLeft,

								child: Transform.scale(
									scale: value, child: child,
								),
							),
						);
					},

					//* Child of ValueListenableBuilder
					child: Icon(Icons.delete, size: height * 0.6),
				),

				child: ValueListenableBuilder(
					valueListenable: progressListenable,
					builder: (context, value, child)
					{
						final color = Color.lerp(
							scheme.secondaryFixed, Colors.red, value)!;

						// Building tree of widgets
						return Material(
							type: MaterialType.transparency,

							child: Ink(
								decoration: BoxDecoration(
									color: scheme.surfaceContainer,
									borderRadius: const BorderRadius.all(radius),

									border: Border(
										left: BorderSide(
											color: color, width: 8.0
										),
									)
								),

								child: child,
							),
						);
					},

					//* Child of ValueListenableBuilder
					child: InkWell(
						splashColor: scheme.surfaceContainerHighest,
						onLongPress: onUpdateAction,

						borderRadius: const BorderRadius.only(
							topRight: radius, bottomRight: radius
						),

						child: _buildContent(context),
					),
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
