import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../models/collection.dart';
import '../../../provider/user_provider.dart';

class ChooseCollectionWidget extends StatefulWidget {
  const ChooseCollectionWidget({Key? key, required this.selectCollection})
      : super(key: key);

  final Function selectCollection;

  @override
  State<ChooseCollectionWidget> createState() => _ChooseCollectionWidgetState();
}

class _ChooseCollectionWidgetState extends State<ChooseCollectionWidget> {
  _selectCollection(Collection collection) {
    widget.selectCollection(collection);

    Navigation.pop(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<UserProvider>(context, listen: false)
        .fetchCurrentUserCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80 * rHeightMultiplier,
      padding: const EdgeInsets.symmetric(horizontal: space2x),
      child: Consumer<UserProvider>(builder: (context, provider, child) {
        if (provider.state == UserState.loading) {
          return const LoadingIndicator();
        }

        if (provider.userCollections.isEmpty) {
          return const EmptyWidget(text: 'No Collections Created');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: rh(space3x)),
            Center(
              child: UpperCaseText(
                'Choose Collection',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: rh(space3x)),

            //List
            Expanded(
              child: ListView.separated(
                itemCount: provider.userCollections.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: rh(space3x));
                },
                itemBuilder: (BuildContext context, int index) {
                  final collection = provider.userCollections[index];
                  return GestureDetector(
                    onTap: () => _selectCollection(collection),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          UpperCaseText(
                            collection.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Icon(Icons.check, size: rf(space2x)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
