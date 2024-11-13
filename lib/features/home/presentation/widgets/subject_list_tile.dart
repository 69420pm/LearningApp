import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/progress_indicators/ui_circular_progress_indicator.dart';
import 'package:learning_app/features/file_system/domain/entities/subject.dart';
import 'package:learning_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/generated/l10n.dart';

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({super.key, required this.subjectId});
  final String subjectId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          context.namedLocation(
            'subject',
            pathParameters: <String, String>{'subjectId': subjectId},
          ),
        );
      },
      child: SizedBox(
        height: UIConstants.defaultSize * 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: context.read<HomeBloc>().subscribedStreams[subjectId],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!snapshot.data!.deleted) {
                    final Subject subject = snapshot.data!.value! as Subject;
                    const nextClassTestInDays = 14;
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: UIConstants.defaultSize * 2,
                        right: UIConstants.defaultSize,
                      ),
                      child: Row(
                        children: [
                          // Icon with progress indicator
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              UICircularProgressIndicator(
                                value: 1,
                                color: subject.disabled
                                    ? UIColors.primaryDisabled
                                    : UIColors.green,
                              ),
                              UIIcons.download.copyWith(
                                size: 24,
                                color: subject.disabled
                                    ? UIColors.primaryDisabled
                                    : UIColors.green,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: UIConstants.itemPaddingLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.name,
                                style: UIText.labelBold.copyWith(
                                  color: subject.disabled
                                      ? UIColors.smallText
                                      : UIColors.textLight,
                                ),
                              ),
                              if (nextClassTestInDays > -1 &&
                                  nextClassTestInDays < 15)
                                Column(
                                  children: [
                                    const SizedBox(
                                        height: UIConstants.defaultSize / 2),
                                    Text(S
                                        .of(context)
                                        .classTestIn(nextClassTestInDays)),
                                  ],
                                ),
                            ],
                          ),
                          const Spacer(),
                          UIIcons.arrowForwardMedium
                              .copyWith(color: UIColors.smallText),
                        ],
                      ),
                    );
                  }
                  return const Text("deleted");
                } else {
                  return const Text('error');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
