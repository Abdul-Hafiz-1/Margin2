import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class MemberAvatarStack extends StatelessWidget {
  final List<TeamMember> members;
  final double avatarSize;
  final int maxVisible;

  const MemberAvatarStack({
    super.key,
    required this.members,
    this.avatarSize = 28,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = members.length > maxVisible ? maxVisible : members.length;
    final extraCount = members.length - visibleCount;

    return SizedBox(
      height: avatarSize,
      width: (visibleCount * (avatarSize * 0.7)) + (extraCount > 0 ? (avatarSize * 0.8) : avatarSize * 0.3),
      child: Stack(
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * (avatarSize * 0.65),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(members[i].colorValue),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  members[i].name.substring(0, 1).toUpperCase(),
                  style: MarginTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: avatarSize * 0.42,
                  ),
                ),
              ),
            ),
          if (extraCount > 0)
            Positioned(
              left: visibleCount * (avatarSize * 0.65),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MarginColors.lavender,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  "+$extraCount",
                  style: MarginTypography.caption.copyWith(
                    color: MarginColors.purpleDark,
                    fontWeight: FontWeight.w700,
                    fontSize: avatarSize * 0.38,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
