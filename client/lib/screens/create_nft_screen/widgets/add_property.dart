import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';

class AddPropertyWidget extends StatefulWidget {
  const AddPropertyWidget({Key? key, required this.add}) : super(key: key);

  final Function add;

  @override
  _AddPropertyWidgetState createState() => _AddPropertyWidgetState();
}

class _AddPropertyWidgetState extends State<AddPropertyWidget> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  _add() {
    widget.add(_typeController.text, _valueController.text);

    Navigation.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80 * rHeightMultiplier,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: rh(space4x)),
            Center(
              child: UpperCaseText(
                'Add properties',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: rh(space3x)),
            CustomTextFormField(
              controller: _typeController,
              isAutoFocused: true,
              labelText: 'Type',
              validator: validator,
            ),
            SizedBox(height: rh(space2x)),
            CustomTextFormField(
              controller: _valueController,
              labelText: 'Value',
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (e) => _add(),
              validator: validator,
            ),
            SizedBox(height: rh(space4x)),
            Buttons.flexible(
              width: double.infinity,
              context: context,
              text: 'Add property',
              onPressed: _add,
            ),
          ],
        ),
      ),
    );
  }
}
