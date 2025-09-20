
import 'package:assignment/classes/delivery.dart';
import 'package:assignment/database.dart';
import 'package:assignment/providers/time_provider.dart';
import 'package:flutter/material.dart';

class ViewSchedule extends StatefulWidget {
  const ViewSchedule({super.key});

  @override
  State<StatefulWidget> createState() => _ViewScheduleState();
}

enum _SortBy {
  name,
  date,
  priority,
}

class _ViewScheduleState extends State<ViewSchedule> {
  final _search = TextEditingController();
  _SortBy _sort = _SortBy.name;
  bool _sortAscending = true;
  bool _loading = true;
  List<Delivery> _deliveries = [];

  Future<void> _fetchDeliveries() async {
    await Database.fetch();
    _deliveries = List.from(Database.deliveries); // copy to a new mutable list
    setState(() => _loading = false);
  }
  
  Widget _deliveryView(Delivery delivery) {
    final part = Database.partsMap[delivery.part]!;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        minimumSize: Size(double.infinity, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        foregroundColor: Colors.black,
      ),
      child: Align(
        alignment: AlignmentGeometry.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${part.name} (x${delivery.quantity})'),
            Text(part.description),
            Text('-> ${delivery.destination} by ${dateFormat.format(delivery.requiredDate)}'),
          ],
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _deliveryListView() {
    // ignore: prefer_function_declarations_over_variables
    Comparator<Delivery> comparator = (a, b) => switch (_sort) {
      _SortBy.name => a.id.compareTo(b.id),
      _SortBy.date => a.quantity.compareTo(b.quantity),
      _SortBy.priority => a.priority.index.compareTo(b.priority.index),
    };

    _deliveries.sort(_sortAscending ? comparator : (b, a) => comparator(a, b));

    return Expanded(child: RefreshIndicator(
      onRefresh: _fetchDeliveries,
      child: ListView.separated(
        padding: EdgeInsets.all(32),
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        itemBuilder: (_, i) => _deliveryView(_deliveries[i]),
        separatorBuilder: (_, _) => const Divider(),
        itemCount: _deliveries.length,
      ),
    ));
  }

  Widget _sortOption(_SortBy sort, String text) => ElevatedButton(
    onPressed: () => setState(() {
      if (_sort == sort) { _sortAscending = !_sortAscending; }
      else { _sort = sort; }
    }),
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: Colors.black,
      backgroundColor: _sort == sort ? Colors.grey[400] : Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    child: Text(text),
  );

  @override
  void initState() {
    super.initState();
    _fetchDeliveries();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        decoration: const InputDecoration(
          hintText: "Search part",
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
        controller: _search,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => setState(() {}),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Sort by:"),
              _sortOption(_SortBy.name, "Name"),
              _sortOption(_SortBy.date, "Date"),
              _sortOption(_SortBy.priority, "Priority"),
            ],
          ),
          _loading ? const Expanded(child: Center(child: CircularProgressIndicator())) : _deliveryListView(),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }
}
