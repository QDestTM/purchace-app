
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sql_test/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


void main()
{
	final scheme = ColorScheme.fromSeed(seedColor: Colors.teal);

	// Setting color of bottom bottom nav-bar for mobile devices
	SystemChrome.setSystemUIOverlayStyle(
		SystemUiOverlayStyle(
			systemNavigationBarColor: scheme.secondaryFixed
		),
	);

	// Initializing app widget
	final Widget app = SQLTest(scheme: scheme);

	// Starting app
	runApp(app);
}


class SQLTest extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final ColorScheme scheme;

	// Constructors
	const SQLTest({
		super.key, required this.scheme
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final theme = ThemeData(colorScheme: scheme);

		// Building tree of widgets
		return MaterialApp(
			title: 'Purchase List', theme: theme,
			supportedLocales: [
				Locale('uk', 'UA')
			],

			localizationsDelegates: [
				...GlobalMaterialLocalizations.delegates,
				GlobalWidgetsLocalizations.delegate
			],

			home: const HomePage(),
			debugShowCheckedModeBanner: false,
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
