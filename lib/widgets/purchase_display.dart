import 'package:sql_test/constants/category_data.dart';
import 'package:sql_test/models/purchase_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class PurchaseDisplay extends StatelessWidget
{
	// Final values
	static final timeFormat = DateFormat("dd MMMM yyyyр. HH:mm", "uk");

	// Constants
	static const Radius radius = Radius.circular(8.0);
	static const double height = 96.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final Function() onLongPress;
	final PurchaseData data;

	// Constructors
	const PurchaseDisplay({
		super.key,
		required this.data,
		required this.onLongPress
	});

	// # ----------------------------------------------------------------------------------------------------<

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

		// Building tree of widgets
		return ConstrainedBox(
			constraints: BoxConstraints.expand(height: height),

			child: Ink(
				decoration: BoxDecoration(
					color: scheme.surfaceContainer,
					borderRadius: const BorderRadius.all(radius),

					border: Border(
						left: BorderSide(
							color: scheme.secondaryFixed, width: 8.0
						),
					)
				),

				child: InkWell(
					splashColor: scheme.surfaceContainerHighest,
					onLongPress: onLongPress,

					borderRadius: const BorderRadius.only(
						topRight: radius, bottomRight: radius
					),

					child: _buildContent(context),
				),
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
