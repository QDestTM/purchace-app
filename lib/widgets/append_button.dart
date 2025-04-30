import 'package:flutter/material.dart';


class AppendButton extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final void Function() onPressed;
	final double size;

	// Constructors
	const AppendButton({
		super.key,
		required this.size,
		required this.onPressed
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return DecoratedBox(
			decoration: BoxDecoration(
				color: scheme.primaryFixed,
				shape: BoxShape.circle
			),

			child: SizedBox.square(
				dimension: size,

				child: IconButton(
					onPressed: onPressed,
					iconSize: size * 0.8,

					highlightColor: scheme.primaryFixedDim,
					icon: const Icon(Icons.add),
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
