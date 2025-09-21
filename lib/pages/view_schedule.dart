
import 'package:assignment/classes/delivery.dart';
import 'package:assignment/database.dart';
import 'package:assignment/pages/view_delivery.dart';
import 'package:assignment/utils.dart';
import 'package:flutter/material.dart';

class ViewSchedule extends StatefulWidget {
  const ViewSchedule({super.key});

  @override
  State<StatefulWidget> createState() => _ViewScheduleState();
}

enum _SortBy {
  part,
  destination,
  date,
  status,
  priority,
  ;

  @override
  String toString() => switch (this) {
    part => 'Part',
    date => 'Date',
    destination => 'Destination',
    status => 'Status',
    priority => 'Priority',
  };
}

class _ViewScheduleState extends State<ViewSchedule> {
  final _search = TextEditingController();
  _SortBy _sort = _SortBy.part;
  bool _sortAscending = true;
  bool _hideDelivered = false;
  bool _loading = true;
  List<Delivery> _deliveries = [];

  Future<void> _fetchDeliveries() async {
    await Database.fetch();
    _deliveries = List.from(Database.deliveries); // copy to a new mutable list
    setState(() => _loading = false);
  }
  
  Widget _deliveryView(Delivery delivery) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(8),
      minimumSize: Size(double.infinity, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: Colors.black,
    ),
    onPressed: navigate(context, () => ViewDelivery(delivery: delivery)),
    child: Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Row(
        spacing: 16,
        children: [
          Image.network(
            delivery.part.image,
            width: 64,
            height: 64,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${delivery.part.name} (×${delivery.quantity})')),
                    Text('${delivery.priority}'),
                  ],
                ),
                const Divider(),
                Text(delivery.part.description),
                Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.arrow_forward, size: 16),
                    Expanded(child: Text('${delivery.destination} by ${dateFormat.format(delivery.requiredDate)}')),
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    Icon(
                      switch (delivery.status) {
                        DeliveryStatus.pending => Icons.schedule,
                        DeliveryStatus.pickedUp => Icons.inventory,
                        DeliveryStatus.enRoute => Icons.local_shipping,
                        DeliveryStatus.delivered => Icons.check,
                      },
                      size: 16,
                    ),
                    Expanded(child: Text(delivery.fullStatus)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _deliveryListView() {
    final query = _search.text;
    final deliveries = List<Delivery>.from(_deliveries.where(
      (delivery) => (!_hideDelivered || delivery.status != DeliveryStatus.delivered)
          && (query.isEmpty
          || matchString(delivery.part.name, query)
          || matchString(delivery.destination, query))
    ));

    // ignore: prefer_function_declarations_over_variables
    Comparator<Delivery> comparator = (a, b) => switch (_sort) {
      _SortBy.part => a.part.name.compareTo(b.part.name),
      _SortBy.destination => a.destination.compareTo(b.destination),
      _SortBy.date => a.requiredDate.compareTo(b.requiredDate),
      _SortBy.status => a.status.index.compareTo(b.status.index),
      _SortBy.priority => a.priority.index.compareTo(b.priority.index),
    };

    deliveries.sort(_sortAscending ? comparator : (b, a) => comparator(a, b));

    return Expanded(child: RefreshIndicator(
      onRefresh: _fetchDeliveries,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        itemBuilder: (_, i) => _deliveryView(deliveries[i]),
        separatorBuilder: (_, _) => const Divider(),
        itemCount: deliveries.length,
      ),
    ));
  }

  Widget _sortOption(_SortBy sort) => ElevatedButton(
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
    child: Text(sort.toString()),
  );

  @override
  void initState() {
    super.initState();
    _fetchDeliveries();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextField(
        decoration: const InputDecoration(
          hintText: "Search part name or destination",
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Column(
        children: [
          Row(
            spacing: 16,
            children: [
              const Text("Sort by:"),
              Expanded(
                child: IntrinsicHeight(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _SortBy.values.map(_sortOption).toList()
                    ),
                  ),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: _hideDelivered,
            onChanged: (hide) => setState(() => _hideDelivered = hide!),
            title: const Text('Hide delivered'),
            controlAffinity: ListTileControlAffinity.leading,
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
