import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../models/news_model.dart';
import '../../../models/user_model.dart';
import '../../../services/helpers.dart';
import '../../../services/news_services.dart';
import '../../news/comments.dart';
import '../../news/news_view.dart';
import 'add.dart';
import 'edit.dart';

class AdminPanelNews extends StatefulWidget {
  const AdminPanelNews({
    super.key,
    required this.currentUser,
    required this.newsList,
    required this.notifyRefresh,
  });
  final Function(bool refresh) notifyRefresh;
  final UserModel currentUser;
  final List<NewsModel> newsList;

  @override
  State<AdminPanelNews> createState() => _AdminPanelNewsState();
}

class _AdminPanelNewsState extends State<AdminPanelNews> {
  List<dynamic> filteredData = [];

  final searchController = TextEditingController();

  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? widget.newsList
          : widget.newsList
              .where((news) =>
                  news.title.toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  void initState() {
    filteredData = widget.newsList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filteredData = widget.newsList;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Manage News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNews(
                    currentUser: widget.currentUser,
                  ),
                ),
              );
              widget.notifyRefresh(true);
            },
            icon: Icon(
              Icons.playlist_add_rounded,
              color: getColorByBackground(context),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Text(
              'View all news here. Search news by typing to the textbox. Edit or Delete news by clicking on the actions button. Tap on star icon to feature the news in news carousel.',
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  columns: <DataColumn>[
                    DataColumn(
                      label: const Text('Title'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.newsList.sort((itemA, itemB) =>
                                itemB.title.compareTo(itemA.title));
                          } else {
                            _isAscending = true;
                            widget.newsList.sort((itemA, itemB) =>
                                itemA.title.compareTo(itemB.title));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Created By'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.newsList.sort((itemA, itemB) => itemB
                                .author!.name
                                .compareTo(itemA.author!.name));
                          } else {
                            _isAscending = true;
                            widget.newsList.sort((itemA, itemB) => itemA
                                .author!.name
                                .compareTo(itemB.author!.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Created At'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.newsList.sort((itemA, itemB) =>
                                itemB.createdAt.compareTo(itemA.createdAt));
                          } else {
                            _isAscending = true;
                            widget.newsList.sort((itemA, itemB) =>
                                itemA.createdAt.compareTo(itemB.createdAt));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Edited By'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.newsList.sort((itemA, itemB) => itemB
                                .updatedBy!.name
                                .compareTo(itemA.updatedBy!.name));
                          } else {
                            _isAscending = true;
                            widget.newsList.sort((itemA, itemB) => itemA
                                .updatedBy!.name
                                .compareTo(itemB.updatedBy!.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Edited At'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.newsList.sort((itemA, itemB) =>
                                itemB.updatedAt.compareTo(itemA.updatedAt));
                          } else {
                            _isAscending = true;
                            widget.newsList.sort((itemA, itemB) =>
                                itemA.updatedAt.compareTo(itemB.updatedAt));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Likes'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.newsList.sort((itemA, itemB) {
                              int itemALikeCount = itemA.likedBy == null
                                  ? 0
                                  : itemA.likedBy!.length;
                              int itemBLikeCount = itemB.likedBy == null
                                  ? 0
                                  : itemB.likedBy!.length;

                              return itemBLikeCount.compareTo(itemALikeCount);
                            });
                          } else {
                            _isAscending = true;
                            widget.newsList.sort((itemA, itemB) {
                              int itemALikeCount = itemA.likedBy == null
                                  ? 0
                                  : itemA.likedBy!.length;
                              int itemBLikeCount = itemB.likedBy == null
                                  ? 0
                                  : itemB.likedBy!.length;

                              return itemALikeCount.compareTo(itemBLikeCount);
                            });
                          }
                        });
                      },
                    ),
                    const DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: List.generate(
                    filteredData.length,
                    (index) {
                      final NewsModel news = filteredData[index];
                      return DataRow(
                        cells: [
                          DataCell(SizedBox(
                            width: 350,
                            child: Text(
                              news.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                          )),
                          DataCell(Text(news.author!.name)),
                          DataCell(Text(DateFormat('dd/MM/yyyy hh:mm a')
                              .format(news.createdAt))),
                          DataCell(Text(news.updatedBy == null
                              ? "None"
                              : news.updatedBy!.name)),
                          DataCell(Text(DateFormat('dd/MM/yyyy hh:mm a')
                              .format(news.updatedAt))),
                          DataCell(Text(news.likedBy == null
                              ? '0'
                              : news.likedBy!.length.toString())),
                          DataCell(
                            Row(
                              children: [
                                // Starred
                                IconButton(
                                  icon: Icon(news.starred
                                      ? Icons.star
                                      : Icons.star_outline),
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text(news.starred
                                          ? 'Unstar News?'
                                          : 'Star News?'),
                                      content: Text(
                                        news.starred
                                            ? 'Are you sure you want to unstar this news? This news will not feature in news carousel anymore. Select OK to confirm.'
                                            : 'Are you sure you want to star this news? This news will feature in news carousel anymore. Select OK to confirm.',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (news.starred) {
                                              final unstar = await NewsService()
                                                  .star(
                                                      news: news, star: false);

                                              print("Unstar: $unstar");

                                              Fluttertoast.showToast(
                                                  msg:
                                                      "${news.title} unstarred");
                                            } else {
                                              final star = await NewsService()
                                                  .star(news: news, star: true);

                                              print("Star: $star");

                                              Fluttertoast.showToast(
                                                  msg: "${news.title} starred");
                                            }

                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              widget.notifyRefresh(true);
                                            }
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // View
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => NewsView(
                                          mainContext: context,
                                          news: news,
                                          user: widget.currentUser,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Edit
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditNews(
                                          currentUser: widget.currentUser,
                                          news: news,
                                        ),
                                      ),
                                    );
                                    widget.notifyRefresh(true);
                                  },
                                ),
                                // Comment
                                IconButton(
                                  icon: const Icon(Icons.chat_bubble),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NewsComments(
                                        news: news,
                                        currentUser: widget.currentUser,
                                      ),
                                    ),
                                  ),
                                ),
                                // Delete
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Delete News?'),
                                      content: const Text(
                                          'Are you sure you want to delete this news? Deleted data may can\'t be retrieved back. Select OK to confirm.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final result = await NewsService()
                                                .delete(news: news);
                                            if (result == true &&
                                                context.mounted) {
                                              Fluttertoast.showToast(
                                                  msg: "${news.title} deleted");
                                              Navigator.pop(context);
                                              widget.notifyRefresh(true);
                                            }
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              color: CustomColor.danger,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
