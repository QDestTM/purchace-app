import 'package:sql_test/constants/category_data.dart';
import 'package:sql_test/enums/purchase_category.dart';
import 'package:sql_test/models/purchase_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class InputModal extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final Function(PurchaseData) inputCallback;
	final PurchaseData? updateData;

	// Constructors
	const InputModal({
		super.key,
		this.updateData,
		required this.inputCallback,
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<InputModal> createState() => InputModalState();

	// ------------------------------------------------------------------------------------------------------<
}


class InputModalState extends State<InputModal>
{
	static const double iconSize = 26.0;
	static const double wrapSpace = 86.0;
	static const double spacing = 12.0;

	// Final values
	static final dateFormat = DateFormat("yyyy-MM-dd", "uk");
	static final timeFormat = DateFormat("HH:mm",      "uk");

	static final dropdownEntries = PurchaseCategory.values.map((element)
	{
		final label = categoryName[element]!;
		final icon = categoryIcon[element]!;

		return DropdownMenuEntry<PurchaseCategory>(
			value: element, label: label,
			leadingIcon: Icon(icon)
		);
	}
	).toList();

	static final priceInputFormatters = [
		LengthLimitingTextInputFormatter(13),
		FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
	];

	static final quantityInputFormatters = [
		LengthLimitingTextInputFormatter(8),
		FilteringTextInputFormatter.digitsOnly
	];

	// ^ ----------------------------------------------------------------------------------------------------<

	// Members
	final _keyNameInput     = GlobalKey<FormFieldState<String>>();
	final _keyCategoryInput = GlobalKey<FormFieldState<PurchaseCategory>>();
	final _keyPriceInput    = GlobalKey<FormFieldState<double>>();
	final _keyQuantityInput = GlobalKey<FormFieldState<int>>();

	final _keyDateInput = GlobalKey<FormFieldState<DateTime>>();
	final _keyTimeInput = GlobalKey<FormFieldState<TimeOfDay>>();

	final _focusNodeQuantity = FocusNode();
	final _focusNodePrice    = FocusNode();
	final _focusNodeName     = FocusNode();

	late final TextEditingController _textControllerName;
	late final TextEditingController _textControllerDate;
	late final TextEditingController _textControllerTime;

	late final TextEditingController _textControllerPrice;
	late final TextEditingController _textControllerQuantity;

	late final PurchaseData _initialDataPart;

	final DateTime _initialDateValue = DateTime.now();
	final TimeOfDay _initialTimeValue = TimeOfDay.now();

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Initialize initial data
		final PurchaseData? data = widget.updateData;

		_initialDataPart = PurchaseData(
			name: "", quantity: 0, price: 0.0,
			category: data?.category ?? PurchaseCategory.none,
			date: data?.date ?? DateTime.now()
		);

		// Set initial date and time
		final formatDate = dateFormat.format(_initialDataPart.date);
		final formatTime = timeFormat.format(_initialDataPart.date);

		_textControllerDate = TextEditingController(text: formatDate);
		_textControllerTime = TextEditingController(text: formatTime);

		// Set initial name
		_textControllerName = TextEditingController(
			text: data?.name ?? ""
		);

		// Set initial price and quantity
		_textControllerPrice = TextEditingController(
			text: data?.price.toString() ?? ""
		);

		_textControllerQuantity = TextEditingController(
			text: data?.quantity.toString() ?? ""
		);
	}


	@override
	void dispose()
	{
		super.dispose();

		// Dispose text controllers
		_textControllerName.dispose();
		_textControllerDate.dispose();
		_textControllerTime.dispose();

		_textControllerPrice.dispose();
		_textControllerQuantity.dispose();
	}

	// @ ----------------------------------------------------------------------------------------------------<

	void _showDatePickerAndUpdateField(FormFieldState<DateTime> fieldState)
	{
		showDatePicker(
			context: context,
			locale: Locale('uk', 'UA'),

			initialDate: fieldState.value!,

			firstDate: DateTime(2000),
			lastDate: DateTime(2128)
		)
		.then((value)
		{
			if ( value == null ) return;
			final format = dateFormat.format(value);

			_textControllerDate.text = format;
			fieldState.didChange(value);
		});
	}


	void _showTimePickerAndUpdateField(FormFieldState<TimeOfDay> fieldState)
	{
		showTimePicker(
			context: context,
			initialTime: fieldState.value!
		)
		.then((value)
		{
			if ( value == null ) return;
			final newDate = DateTime(
				0, 0, 0, value.hour, value.minute, 0
			);

			_textControllerTime.text = timeFormat.format(newDate);
			fieldState.didChange(value);
		});
	}


	void _onAppendButtonPress()
	{
		bool inputValid = true;

		// Validate name
		final stateNameInput = _keyNameInput.currentState!;
		inputValid = stateNameInput.validate() && inputValid;

		// Validate category
		final stateCategoryInput = _keyCategoryInput.currentState!;
		inputValid = stateCategoryInput.validate() && inputValid;

		// Validate price
		final statePriceInput = _keyPriceInput.currentState!;
		inputValid = statePriceInput.validate() && inputValid;

		// Validate quantity
		final stateQuantityInput = _keyQuantityInput.currentState!;
		inputValid = stateQuantityInput.validate() && inputValid;

		// Validate data
		final stateDateInput = _keyDateInput.currentState!;
		inputValid = stateDateInput.validate() && inputValid;

		// Validate time
		final stateTimeInput = _keyTimeInput.currentState!;
		inputValid = stateTimeInput.validate() && inputValid;

		if ( !inputValid )
		{
			return; //! Invalid inputs in form
		}

		// Build and save purchase data
		final date = stateDateInput.value!;
		final time = stateTimeInput.value!;

		final data = PurchaseData(
			name: stateNameInput.value!,
			category: stateCategoryInput.value!,
			price: statePriceInput.value!,
			quantity: stateQuantityInput.value!,

			date: DateTime(
				date.year, date.month, date.day, time.hour, time.minute
			),

			id: widget.updateData?.id ?? 0
		);

		widget.inputCallback(data);

		// Close input modal panel
		Navigator.pop(context);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildNameInput(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return SizedBox(
			width: double.infinity,
			height: InputModalState.wrapSpace,

			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				crossAxisAlignment: CrossAxisAlignment.baseline,

				textBaseline: TextBaseline.ideographic,
				spacing: InputModalState.spacing,

				children: <Widget>
				[
					Icon(
						Icons.shopping_cart,
						size: InputModalState.iconSize,
						color: scheme.inverseSurface,
					),

					Expanded(
						child: FormField<String>(
							key: _keyNameInput,
							initialValue: _textControllerName.text,

							autovalidateMode: AutovalidateMode.onUserInteraction,

							builder: (fieldState)
							{
								// Building tree of widgets
								return TextField(
									focusNode: _focusNodeName,
									controller: _textControllerName,

									decoration: InputDecoration(
										labelText: "Назва покупки",
										hintText: "Введіть назву покупки",
										border: const OutlineInputBorder(),

										errorText: fieldState.errorText,
										alignLabelWithHint: true,
									),

									onTapOutside: (_) {
										_focusNodeName.unfocus();
									},

									onChanged: (value) {
										fieldState.didChange(value);
									},
								);
							},

							validator: (value)
							{
								if ( value == null || value.isEmpty ) {
									return "Це поле не може бути пустим";
								}
								if ( value.length > 32 ) {
									return "Ввід не може перевищувати 32 символи";
								}

								return null;
							},
						),
					),
				],
			)
		);
	}


	Widget _buildCategoryMenu(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return SizedBox(
			width: double.infinity,
			height: InputModalState.wrapSpace,

			child: FormField<PurchaseCategory>(
				key: _keyCategoryInput,

				initialValue: _initialDataPart.category,
				autovalidateMode: AutovalidateMode.onUserInteraction,

				builder: (fieldState)
				{
					// Building tree of widgets
					return Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						crossAxisAlignment: CrossAxisAlignment.baseline,

						textBaseline: TextBaseline.ideographic,
						spacing: InputModalState.spacing,

						children: <Widget>
						[
							Icon(
								categoryIcon[fieldState.value],
								size: InputModalState.iconSize,
								color: scheme.inverseSurface,
							),

							Expanded(
								child: DropdownMenu(
									expandedInsets: const EdgeInsets.all(0),

									label: const Text("Категорія"),
									errorText: fieldState.errorText,

									initialSelection: fieldState.value,
									dropdownMenuEntries: dropdownEntries,

									onSelected: (value)
									{
										if ( value is PurchaseCategory )
										{
											fieldState.didChange(value);
										}
									},
								),
							)
						],
					);
				},

				validator: (value)
				{
					if ( value == PurchaseCategory.none ) {
						return "Не обрана категорія продукту";
					}

					return null;
				},
			),
		);
	}


	Widget _buildPriceAndQuantityInput(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return SizedBox(
			width: double.infinity,
			height: InputModalState.wrapSpace,

			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				crossAxisAlignment: CrossAxisAlignment.baseline,

				textBaseline: TextBaseline.ideographic,
				spacing: InputModalState.spacing,

				children: <Widget>
				[
					Icon(
						Icons.euro, // Widget icon
						size: InputModalState.iconSize,
						color: scheme.inverseSurface,
					),

					// Input for price
					Expanded(
						child: FormField<double>(
							key: _keyPriceInput,

							initialValue: widget.updateData?.price,
							autovalidateMode: AutovalidateMode.onUserInteraction,

							builder: (fieldState)
							{
								// Building tree of widgets
								return TextField(
									focusNode: _focusNodePrice,
									controller: _textControllerPrice,

									decoration: InputDecoration(
										labelText: "Ціна",
										hintText: "Введіть ціну",

										errorText: fieldState.errorText,
										border: const OutlineInputBorder(),
									),

									inputFormatters: InputModalState.priceInputFormatters,

									keyboardType: const TextInputType.numberWithOptions(
										signed: false, decimal: true
									),

									onTapOutside: (_) {
										_focusNodePrice.unfocus();
									},

									onChanged: (value) {
										final price = double.tryParse(value);
										fieldState.didChange(price);
									},

									onSubmitted: (value)
									{
										_focusNodePrice.unfocus();
										_focusNodeQuantity.requestFocus();
									},
								);
							},

							validator: (value)
							{
								if ( value == null ) {
									return "Обов'язковo*";
								}
								if ( value < 0.01 ) {
									return "Ціна < 0.01";
								}
								if ( value > 32678 ) {
									return "Ціна > 32678";
								}

								return null;
							},
						),
					),

					// Input for quantity
					Expanded(
						child: FormField<int>(
							key: _keyQuantityInput,

							initialValue: widget.updateData?.quantity,
							autovalidateMode: AutovalidateMode.onUserInteraction,

							builder: (fieldState)
							{
								return TextField(
									focusNode: _focusNodeQuantity,
									controller: _textControllerQuantity,

									decoration: InputDecoration(
										labelText: "Кількість",
										hintText: "Введіть к-ть",

										errorText: fieldState.errorText,
										border: const OutlineInputBorder(),
									),

									inputFormatters: InputModalState.quantityInputFormatters,

									keyboardType: const TextInputType.numberWithOptions(
										signed: false, decimal: false
									),

									onTapOutside: (_) {
										_focusNodeQuantity.unfocus();
									},

									onChanged: (value) {
										final quantity = int.tryParse(value);
										fieldState.didChange(quantity);
									},

									onSubmitted: (value)
									{
										_focusNodeQuantity.unfocus();
									},
								);
							},

							validator: (value)
							{
								if ( value == null ) {
									return "Обов'язковo*";
								}
								if ( value < 1 ) {
									return "К-ть < 1";
								}
								if ( value > 32768 ) {
									return "К-ть > 32768";
								}

								return null;
							},
						),
					),

					Icon(
						Icons.add_shopping_cart, // Widget icon
						size: InputModalState.iconSize,
						color: scheme.inverseSurface,
					),
				]
			),
		);
	}


	Widget _buildDatePicker(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Row(
			spacing: InputModalState.spacing,

			children: <Widget>
			[
				Icon(
					Icons.calendar_month, // Widget icon
					size: InputModalState.iconSize,
					color: scheme.inverseSurface,
				),

				// Purchase date calendar picker
				Expanded(
					child: FormField<DateTime>(
						key: _keyDateInput,

						initialValue: widget.updateData?.date ?? _initialDateValue,

						builder: (fieldState)
						{
							// Building tree of widgets
							return TextField(
								decoration: const InputDecoration(
									labelText: "Дата покупки",
									border: OutlineInputBorder(),
								),

								controller: _textControllerDate,
								enableInteractiveSelection: false,

								onTapAlwaysCalled: true,
								readOnly: true,

								onTap: () {
									_showDatePickerAndUpdateField(fieldState);
								},
							);
						},
					),
				),

				// Purchase date calendar clock
				Expanded(
					child: FormField<TimeOfDay>(
						key: _keyTimeInput,

						initialValue: widget.updateData?.time ?? _initialTimeValue,

						builder: (fieldState)
						{
							// Building tree of widgets
							return TextField(
								decoration: const InputDecoration(
									labelText: "Час покупки",
									border: OutlineInputBorder(),
								),

								controller: _textControllerTime,
								enableInteractiveSelection: false,

								onTapAlwaysCalled: true,
								readOnly: true,

								onTap: () {
									_showTimePickerAndUpdateField(fieldState);
								}
							);
						}
					),
				),

				Icon(
					Icons.timer, // Widget icon
					size: InputModalState.iconSize,
					color: scheme.inverseSurface,
				),
			]
		);
	}


	Widget _buildBottomButton(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Define button text
		final buttonText = widget.updateData == null
			? "Додати" : "Оновити";

		// Building tree of widgets
		return TextButton(
			style: TextButton.styleFrom(
				backgroundColor: scheme.primaryFixed,
				disabledBackgroundColor: scheme.primaryFixedDim
			),

			onPressed: _onAppendButtonPress,

			child: Text(buttonText,
				style: TextStyle(
					fontSize: 16, color: scheme.inverseSurface
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildMainContent(BuildContext context)
	{
		final theme = Theme.of(context);

		// Define title text
		final titleText = widget.updateData == null
			? "Додати покупку" : "Оновити покупку";

		// Building tree of widgets
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,

			children: <Widget>
			[
				Text(titleText,
					textAlign: TextAlign.center,
					style: theme.textTheme.titleLarge,
				),

				const SizedBox(height: 24), // GAP

				_buildNameInput(context),
				_buildCategoryMenu(context),

				const Divider(thickness: 2, height: 0), // GAP
				const SizedBox(height: 24), // GAP

				_buildPriceAndQuantityInput(context),

				_buildDatePicker(context),
				const SizedBox(height: 20), // GAP

				Expanded(
					child: _buildBottomButton(context),
				),
			],
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final viewInsets = MediaQuery.viewInsetsOf(context);
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Padding(
			padding: viewInsets,

			child: DecoratedBox(
				decoration: BoxDecoration(
					color: scheme.surfaceDim,

					borderRadius: const BorderRadius.only(
						topLeft: Radius.circular(20.0),
						topRight: Radius.circular(20.0)
					),
				),

				child: ConstrainedBox(
					constraints: const BoxConstraints.expand(
						height: 512
					),

					child: Padding(
						padding: const EdgeInsets.symmetric(
							vertical: 25.0, horizontal: 30.0
						),

						child: _buildMainContent(context)
					),
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
