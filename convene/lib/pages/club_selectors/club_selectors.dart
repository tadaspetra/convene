import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_set.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';

class ClubSelectorsPage extends StatefulWidget {
  final String clubId;
  const ClubSelectorsPage({Key key, this.clubId}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const ClubSelectorsPage());

  @override
  _ClubSelectorsPageState createState() => _ClubSelectorsPageState();
}

class _ClubSelectorsPageState extends State<ClubSelectorsPage> {
  TextEditingController bookController = TextEditingController();

  String searchText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                  final AsyncValue<List<DatabaseUser>> members = watch(membersController(widget.clubId));
                  final AsyncValue<List<DatabaseUser>> selectors = watch(selectorsController(widget.clubId));
                  final AsyncValue<ClubSet> club = watch(clubController(widget.clubId).state);
                  final AsyncValue<DatabaseUser> currentUser = watch(currentUserController.state);

                  return members.when(
                    error: (Object error, StackTrace stackTrace) {
                      return const Text("Error retrieving books");
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    data: (List<DatabaseUser> members) {
                      if (members.isEmpty) {
                        return Container();
                      } else {
                        return ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(members[index].name ?? "Error: no name"),
                              trailing: currentUser.maybeWhen(
                                data: (user) {
                                  return club.maybeWhen(data: (clubset) {
                                    if (clubset.club.leader == user.uid) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          selectors.when(
                                            data: (List<DatabaseUser> selectors) {
                                              if (selectors.contains(members[index])) {
                                                return IconButton(
                                                  icon: const Icon(Icons.check_box),
                                                  onPressed: () {
                                                    context.read(clubLogic).removeSelector(widget.clubId, members[index].uid);
                                                  },
                                                );
                                              }
                                              return IconButton(
                                                icon: const Icon(Icons.check_box_outline_blank),
                                                onPressed: () {
                                                  context.read(clubLogic).addSelector(widget.clubId, members[index]);
                                                },
                                              );
                                            },
                                            error: (Object error, StackTrace stackTrace) {
                                              return const Icon(Icons.check_box_outline_blank);
                                            },
                                            loading: () {
                                              return const Icon(Icons.check_box_outline_blank);
                                            },
                                          ),
                                          () {
                                            if (members[index].uid != clubset.club.leader) {
                                              return RaisedButton(
                                                onPressed: () {
                                                  context.read(clubLogic).removeMember(widget.clubId, members[index].uid);
                                                },
                                                child: const Text("Delete"),
                                              );
                                            } else {
                                              return Container(
                                                width: 90,
                                              );
                                            }
                                          }()
                                        ],
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: selectors.when(
                                          data: (List<DatabaseUser> selectors) {
                                            if (selectors.contains(members[index])) {
                                              return const Icon(Icons.check_box);
                                            }
                                            return const Icon(Icons.check_box_outline_blank);
                                          },
                                          error: (Object error, StackTrace stackTrace) {
                                            return const Icon(Icons.check_box_outline_blank);
                                          },
                                          loading: () {
                                            return const Icon(Icons.check_box_outline_blank);
                                          },
                                        ),
                                      );
                                    }
                                  }, orElse: () {
                                    return Container();
                                  });
                                },
                                orElse: () {
                                  return Container();
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
