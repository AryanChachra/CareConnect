import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';


class TeamDetailsPage extends StatelessWidget {
  final Team team;

  const TeamDetailsPage({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team logo
            Image.asset(
              'assets/images/team_logo.png',
              width: 500,
              height: 200,
            ),

            // Divider
            const Divider(
              height: 18,
              thickness: 5,
            ),
            const Text(
              'Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: team.members.length,
                itemBuilder: (context, index) {
                  final member = team.members[index];
                  return TeamMemberItem(member: member);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}

class TeamMemberItem extends StatelessWidget {
  final TeamMember member;

  const TeamMemberItem({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MemberDetailsPage(member: member)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(member.photoPath),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  member.role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Team {
  final String name;
  final List<TeamMember> members;

  const Team({required this.name, required this.members});
}

class TeamMember {
  final String name;
  final String role;
  final String photoPath;
  final String desc;

  const TeamMember(
      {required this.name,
      required this.role,
      required this.photoPath,
      required this.desc});
}

final team = Team(
  name: 'My Team',
  members: [
    TeamMember(
        name: 'Aryan Chachra',
        role: 'App Developer',
        photoPath: 'assets/images/ProfessionalPic.jpg',
        desc: 'Flutter Developer, Former GDSC-CDGI Lead, Currently Interning at Taygete Software Solutions Pvt.Ltd.'),
    TeamMember(
        name: 'Gaurav Kadskar',
        role: 'Backend Developer',
        photoPath: 'assets/images/gaurav.jpg',
        desc: 'Django Developer, I build APIs '),
    TeamMember(
        name: 'Kunal Bamoriya',
        role: 'Frontend Developer',
        photoPath: 'assets/images/kunal.jpg',
        desc: 'Frontend Developer, My Tech Stack Includes Java, MERN, Springboot.'),
  ],
);

class MemberDetailsPage extends StatelessWidget {
  final TeamMember member;

  const MemberDetailsPage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(member.photoPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: ClipPath(
                clipper: ArcClipper(height: 30),
                // edge: VxEdge.top,
                // arcType: VxArcType.convey,
                child: Container(
                  color: MyTheme.blueColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'Name: ${member.name}',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      Text(
                        'Role: ${member.role}',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          member.desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  final double height;

  ArcClipper({required this.height});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, height);
    path.quadraticBezierTo(size.width / 2, height + 40, size.width, height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
